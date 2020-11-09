//
//  MathOperator + Ext.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/9.
//

import Foundation
import UIKit

func radians2Degrees(radians: CGFloat) -> CGFloat {
    return radians * 180.0 / CGFloat.pi
}

func degrees2Radians(angle: CGFloat) -> CGFloat {
    return angle / 180.0 * CGFloat.pi
}

func abscgf(_ val: CGFloat) -> CGFloat {
    return val >= 0.0 ? val : -val
}

func sqrtcgf(_ val: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(val)))
}

func powcgf(_ val: CGFloat) -> CGFloat {
    return val * val
}

func *(l: CGSize, r: CGFloat)-> CGSize {
    return CGSize(width: r * l.width, height: r * l.height)
}

func *(l: CGSize, r: CGSize)-> CGSize{
    return CGSize(width: l.width * r.width, height: l.height * r.height)
}

func /(l: CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width / r.width, height: l.height / r.height)
}

func /(size: CGSize, factory: CGFloat) -> CGSize {
    return CGSize(width: size.width / factory, height: size.height / factory)
}

func -(l : CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width - r.width, height: l.height - r.height)
}

func +(l : CGSize, r: CGSize) -> CGSize {
    return CGSize(width: l.width + r.width, height: l.height + r.height)
}

func -(l : CGPoint, r: CGPoint) -> CGPoint {
    return  CGPoint(x: l.x - r.x, y: l.y - r.y)
}

func +(l : CGPoint, r: CGPoint) -> CGPoint {
    return  CGPoint(x: l.x + r.x, y: l.y + r.y)
}

func -(point : CGPoint, offset: CGSize) -> CGPoint {
    return  CGPoint(x: point.x - offset.width, y: point.y - offset.height)
}

func +(point : CGPoint, offset: CGSize) -> CGPoint {
    return  CGPoint(x: point.x + offset.width, y: point.y + offset.height)
}

func /(point: CGPoint, factory: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / factory, y: point.y / factory)
}

func /(point: CGPoint, factory: CGSize) -> CGPoint {
    return CGPoint(x: point.x / factory.width, y: point.y / factory.height)
}

func *(point: CGPoint, factory: CGSize) -> CGPoint {
    return CGPoint(x: point.x * factory.width, y: point.y * factory.height)
}

func *(point: CGPoint, factory: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * factory, y: point.y * factory)
}
