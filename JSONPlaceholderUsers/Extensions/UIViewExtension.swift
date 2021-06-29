//
//  UIViewExtension.swift
//  JSONPlaceholderUsers
//
//  Created by Daniel Duran Schutz on 28/06/21.
//

import Foundation
import UIKit

extension UIView {
    
    /// Instantiate a view from xib.
    ///
    /// - Returns: Instantiatd view from XIB
    @objc class func instanceFromNib() -> UIView {
        return UINib(nibName: String(describing: self), bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }

    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 1
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func boxStyle1(){
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor.copy(alpha: 0.3)
        self.dropShadow(color: UIColor.lightGray,
                        opacity: 0.50,
                        offSet: CGSize(width: 0, height: 2.3),
                        radius: 1,
                        scale: true)
        self.layer.cornerRadius = 2
    }
    
}
