//
//  Constant.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/9.
//

import Foundation
import UIKit

struct Constant {
    struct UI {
        /**
         *  状态栏高度
         */
        static let UI_SATAUSBAR_ADD_HEIGHT = (IS_IPHONE_X || IS_IPHONE_XR) ? 24 : 0
        static let UI_SATAUSBAR_HEIGHT = (IS_IPHONE_X || IS_IPHONE_XR) ? 44 : 20
        static let UI_SAFE_BOTTOM = (IS_IPHONE_X || IS_IPHONE_XR) ? 34 : 0
        static let UI_SAFE_BANGS = (IS_IPHONE_X || IS_IPHONE_XR) ? 44 : 0
        
        
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_BOUNDS = UIScreen.main.bounds
        static let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone ? true : false
        static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad ? true : false
        static let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
        
        /**
         18年适配的iPhoneX 的分辨率（像素）：2436 * 1125 || pt: 812 * 375
         iPhoneXr的分辨率：1792 * 828 || pt: 896 * 414
         iPhoneXs 的分辨率： 2436 * 1125 || pt: 812 * 375
         iPhoneXs Max 的分辨率：2688 * 1242 || pt: 896 * 414
         */
        //MARK:判断机型 参考 https://blog.csdn.net/u012265444/article/details/78538654?utm_source=blogxgwz6
        static let IS_IPHONE_4_OR_LESS = (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)// 320 * 480pt 3.5inch
        static let IS_IPHONE_5 = (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)// 320 * 568   4.0inch
        static let IS_IPHONE_6 = (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)// 375 * 667   4.7inch
        static let IS_IPHONE_6P = (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)// 414 * 736。  5.5inch
        static let IS_IPHONE_X = (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)// 375 * 812。   5.8inch  iphone x, xs
        static let IS_IPHONE_XR = (IS_IPHONE && SCREEN_MAX_LENGTH == 896.0)// 414 * 896  iphone xr6.1inch ，iphone xs_max 6.5inch
    }
}
