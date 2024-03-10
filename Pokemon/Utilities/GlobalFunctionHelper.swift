//
//  GlobalFunctionHelper.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/5.
//

import Foundation

typealias NormalCompletion = () -> Void
typealias DetailDatasCompletion = (_: [DetailData]) -> Void
typealias StringCompletion = (_: String) -> Void
typealias BoolCompletion = (_: Bool) -> Void

enum LanguageCode: String {
    case traditionalChinese = "zh-Hant"
    case english = "en"
}

func isTraditionalChinese() -> Bool {
    if let language = Locale.preferredLanguages.first,
       language.contains(LanguageCode.traditionalChinese.rawValue) {
        return true
    }
    return false
}

enum AccessibilityId: String {
    case listCollectionView = "ListCollectionView"
    case listCollectionViewCell = "ListCollectionViewCell"
    case detailViewController_OwnedButton = "DetailViewController_OwnedButton"
    
    static func loadListCollectionViewCell(name: String) -> String {
        return AccessibilityId.listCollectionViewCell.rawValue + "_" + name
    }
}

enum OwnedButtonTitle: String {
    case owned = "Owned"
    case Unowned = "Unowned"
}
