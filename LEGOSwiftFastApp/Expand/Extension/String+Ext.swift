//
//  String+Ext.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/9.
//

import Foundation
import UIKit

extension String {
    func getWidth(with font: UIFont, height: CGFloat) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        
        return strSize.width
    }
    
    func getHeight(with font: UIFont, width: CGFloat) -> CGFloat {
        let statusLabelText: NSString = self as NSString
        let size = CGSize(width: width, height: CGFloat(MAXFLOAT))
        let dic = NSDictionary(object: font, forKey: NSAttributedString.Key.font as NSCopying)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [NSAttributedString.Key : AnyObject], context: nil).size
        
        return strSize.height
    }
}
