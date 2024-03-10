//
//  UIView+Corner.swift
//  Pokemon
//
//  Created by Chang Chin-Ming on 2024/3/7.
//

import UIKit

extension UIView {
    
    func addCorner(_ bounds: Bool, radius: CGFloat, width: CGFloat, color: UIColor) {
        let layer = self.layer
        layer.masksToBounds = bounds
        layer.cornerRadius = radius
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
