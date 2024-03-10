//
//  CustomButton.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/9.
//

import UIKit

class CustomButton: UIButton {

    var pressedBtnCallback: NormalCompletion?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.addTarget(self, action: #selector(didPressedBtn), for: .touchUpInside)
    }

    @objc private func didPressedBtn() {
        pressedBtnCallback?()
    }
}
