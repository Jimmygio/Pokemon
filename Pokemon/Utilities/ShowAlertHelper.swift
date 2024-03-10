//
//  ShowAlertHelper.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/9.
//

import UIKit

class ShowAlertItem {

    var actionTitle: String
    var actionStyle: UIAlertAction.Style
    var isPreferredAction: Bool
    var completion: NormalCompletion?
    
    init(actionTitle: String, actionStyle: UIAlertAction.Style = .default, isPreferredAction: Bool = false,  completion: NormalCompletion? = nil) {
        self.actionTitle = actionTitle
        self.actionStyle = actionStyle
        self.isPreferredAction = isPreferredAction
        self.completion = completion
    }
}

func alertControllerFactory(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert,
                            itemsArray: [ShowAlertItem]) -> UIAlertController {
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
    
    for i in 0..<itemsArray.count {
        let item = itemsArray[i]
        let action = UIAlertAction(title: item.actionTitle, style: item.actionStyle, handler: { _ in
            if let tCompletion = item.completion {
                tCompletion()
            }
        })
        alertController.addAction(action)
        if item.isPreferredAction {
            alertController.preferredAction = action
        }
    }
    return alertController
}

func showAlert(title: String? = nil, message: String? = nil, preferredStyle: UIAlertController.Style = .alert,
               itemsArray: [ShowAlertItem],
               viewController: UIViewController) {
    
    let alertController = alertControllerFactory(title: title,
                                                 message: message,
                                                 preferredStyle: preferredStyle,
                                                 itemsArray: itemsArray)
    DispatchQueue.main.async {            
        viewController.present(alertController, animated: true, completion: nil)
    }
}
