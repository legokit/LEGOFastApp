//
//  UserDefaults+Ext.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/9.
//

import Foundation



protocol UserDefaultsSettingEnable {
    associatedtype defaultKeys: RawRepresentable
}

extension UserDefaultsSettingEnable where defaultKeys.RawValue == String {
    static func string(forKey key:defaultKeys) -> String? {
        let akey = key.rawValue
        return UserDefaults.standard.string(forKey: akey)
    }
    
    static func set(value: Int, forKey key:defaultKeys) {//Int
        let akey = key.rawValue
        UserDefaults.standard.set(value, forKey: akey)
    }
    
    static func integer(forKey key:defaultKeys) -> Int {
        let akey = key.rawValue
        return UserDefaults.standard.integer(forKey: akey)
    }
    
    static func set(value: Double, forKey key:defaultKeys) {//Double
        let akey = key.rawValue
        UserDefaults.standard.set(value, forKey: akey)
    }
    
    static func double(forKey key:defaultKeys) -> Double {
        let akey = key.rawValue
        return UserDefaults.standard.double(forKey: akey)
    }
    
    static func set(value: Float, forKey key:defaultKeys) {//Float
        let akey = key.rawValue
        UserDefaults.standard.set(value, forKey: akey)
    }
    
    static func float(forKey key:defaultKeys) -> Float {
        let akey = key.rawValue
        return UserDefaults.standard.float(forKey: akey)
    }
    
    static func set(value: Data, forKey key:defaultKeys) {//Data
        let akey = key.rawValue
        UserDefaults.standard.set(value, forKey: akey)
    }
    
    static func data(forKey key:defaultKeys) -> Data {
        let akey = key.rawValue
        return UserDefaults.standard.data(forKey: akey) ?? Data()
    }
    
    static func set(value: Bool, forKey key:defaultKeys) {//Bool
        let akey = key.rawValue
        UserDefaults.standard.set(value, forKey: akey)
    }
    
    static func bool(forKey key:defaultKeys) -> Bool {
        let akey = key.rawValue
        return UserDefaults.standard.bool(forKey: akey)
    }
}
