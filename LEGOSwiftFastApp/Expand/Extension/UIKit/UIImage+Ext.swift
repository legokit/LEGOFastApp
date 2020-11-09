//
//  UIImage+Ext.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/6.
//

import Foundation
import UIKit

extension UIImage {
    class func createImage(with color: UIColor, imageSize size: CGSize) -> UIImage {
        let image = UIImage()
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.nativeScale)
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIRectFill(bounds)
        image.draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }
}
