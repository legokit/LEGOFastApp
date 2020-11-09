//
//  GoreGraphics+Ext.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/9.
//

import Foundation
import UIKit

extension CGPoint {
    
    func rotateBy(rad: CGFloat, for center: CGPoint) -> CGPoint {
        return CGPoint(x: (self.x - center.x) * cos(rad) - (self.y - center.y) * sin(rad) + center.x,
                       y: (self.x - center.x) * sin(rad) + (self.y - center.y) * cos(rad) + center.y)
    }
    
    func scaleBy(size: CGSize, for center: CGPoint) -> CGPoint {
        return CGPoint(x: (self.x - center.x) * size.width + center.x,
                       y: (self.y - center.y) * size.height + center.y)
    }
    
    func isNear(for pivot: CGPoint, distance: CGFloat) -> Bool {
        return CGRect(x: pivot.x - distance, y: pivot.y - distance, width: distance * 2, height: distance * 2).contains(self)
    }
    
    /* 计算两点间距 */
    func distanceWithPoint(startPoint: CGPoint) -> CGFloat{
    let x = startPoint.x - self.x;
    let y = startPoint.y - self.y;
    return sqrt(x * x + y * y);
    }
    
    static func middle(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) * 0.5, y: (p1.y + p2.y) * 0.5)
    }
    
    func distance(to other: CGPoint) -> CGFloat {
        let p = pow(x - other.x, 2) + pow(y - other.y, 2)
        return sqrt(p)
    }
}
