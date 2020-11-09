//
//  DESCrypto.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/9.
//

import Foundation

import Foundation
import CommonCrypto

enum CryptoAlgorithm {
    /// 加密的枚举选项 AES/AES128/DES/DES3/CAST/RC2/RC4/Blowfish......
    case aes, aes128, des, des3, cast, rc2, rc4, blowfish
    var algorithm: CCAlgorithm {
        var result: UInt32 = 0
        switch self {
        case .aes:          result = UInt32(kCCAlgorithmAES)
        case .aes128:       result = UInt32(kCCAlgorithmAES128)
        case .des:          result = UInt32(kCCAlgorithmDES)
        case .des3:         result = UInt32(kCCAlgorithm3DES)
        case .cast:         result = UInt32(kCCAlgorithmCAST)
        case .rc2:          result = UInt32(kCCAlgorithmRC2)
        case .rc4:          result = UInt32(kCCAlgorithmRC4)
        case .blowfish:     result = UInt32(kCCAlgorithmBlowfish)
        }
        return CCAlgorithm(result)
    }
    var keyLength: Int {
        var result: Int = 0
        switch self {
        case .aes:          result = kCCKeySizeAES128
        case .aes128:       result = kCCKeySizeAES256
        case .des:          result = kCCKeySizeDES
        case .des3:         result = kCCKeySize3DES
        case .cast:         result = kCCKeySizeMaxCAST
        case .rc2:          result = kCCKeySizeMaxRC2
        case .rc4:          result = kCCKeySizeMaxRC4
        case .blowfish:     result = kCCKeySizeMaxBlowfish
        }
        return Int(result)
    }
    var cryptLength: Int {
        var result: Int = 0
        switch self {
        case .aes:          result = kCCKeySizeAES128
        case .aes128:       result = kCCBlockSizeAES128
        case .des:          result = kCCBlockSizeDES
        case .des3:         result = kCCBlockSize3DES
        case .cast:         result = kCCBlockSizeCAST
        case .rc2:          result = kCCBlockSizeRC2
        case .rc4:          result = kCCBlockSizeRC2
        case .blowfish:     result = kCCBlockSizeBlowfish
        }
        return Int(result)
    }
}

// MARK: - data
extension Data {
    /*
     加密
     - parameter algorithm: 加密方式
     - parameter keyData:   加密key
     
     - return NSData: 加密后的数据 可选值
     */
    mutating func enCrypt(algorithm: CryptoAlgorithm, keyData:Data) -> Data? {
        return crypt(algorithm: algorithm, operation: CCOperation(kCCEncrypt), keyData: keyData)
    }
    
    /*
     解密
     - parameter algorithm: 解密方式
     - parameter keyData:   解密key
     
     - return NSData: 解密后的数据  可选值
     */
    mutating func deCrypt(algorithm: CryptoAlgorithm, keyData:Data) -> Data? {
        return crypt(algorithm: algorithm, operation: CCOperation(kCCDecrypt), keyData: keyData)
    }
    
    
    /*
     解密和解密方法的抽取的封装方法
     - parameter algorithm: 何种加密方式
     - parameter operation: 加密和解密
     - parameter keyData:   加密key
     
     - return NSData: 解密后的数据  可选值
     */
    mutating func crypt(algorithm: CryptoAlgorithm, operation:CCOperation, keyData: Data) -> Data? {
        let keyLength       = Int(algorithm.keyLength)
        let dataLength      = self.count
        let cryptLength     = Int(dataLength+algorithm.cryptLength)
        let cryptPointer    = UnsafeMutablePointer<UInt8>.allocate(capacity: cryptLength)
        let algoritm:  CCAlgorithm = CCAlgorithm(algorithm.algorithm)
        let option:   CCOptions    = CCOptions(kCCOptionECBMode + kCCOptionPKCS7Padding)
        let numBytesEncrypted = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        numBytesEncrypted.initialize(to: 0)
        
        #if swift(>=5.0)
        
        var cryptStatus : CCCryptorStatus!
        
        self.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> Void in
            
            keyData.withUnsafeBytes {
                
               cryptStatus = CCCrypt(operation, algoritm, option, $0.baseAddress, keyLength, nil, bytes.baseAddress, dataLength, cryptPointer, cryptLength, numBytesEncrypted)
                
            }
            
        }

        #elseif swift(>=4.2) && compiler(>=5.0)
        
        let keyBytes : [Int8] = keyData.withUnsafeBytes { (bytes: UnsafePointer<Int8>) -> [Int8] in
            let buffer = UnsafeBufferPointer(start: bytes, count: keyLength)
            return Array(buffer)
        }
        
        let dataBytes: [Int8] = self.withUnsafeBytes { (bytes: UnsafePointer<Int8>) -> [Int8] in
            let buffer = UnsafeBufferPointer(start: bytes, count: dataLength)
            return Array(buffer)
        }
        
        let cryptStatus = CCCrypt(operation, algoritm, option, keyBytes, keyLength, nil, dataBytes, dataLength, cryptPointer, cryptLength, numBytesEncrypted)
        
        #else
        
        var keyBytes: UnsafePointer<Int8>?
        keyData.withUnsafeBytes {(bytes: UnsafePointer<Int8>)->Void in
            keyBytes = bytes
        }
        
        var dataBytes: UnsafePointer<Int8>?
        self.withUnsafeBytes {(bytes: UnsafePointer<CChar>)->Void in
            //            print(bytes)
            dataBytes = bytes
        }

        let cryptStatus = CCCrypt(operation, algoritm, option, keyBytes, keyLength, nil, dataBytes, dataLength, cryptPointer, cryptLength, numBytesEncrypted)
        
        #endif
        
        if CCStatus(cryptStatus) == CCStatus(kCCSuccess) {
            let len = Int(numBytesEncrypted.pointee)
            let data = Data.init(bytes: cryptPointer, count: len)
            numBytesEncrypted.deallocate()
//            numBytesEncrypted.deallocate(capacity: 1)
            return data
        } else {
            numBytesEncrypted.deallocate()
//            numBytesEncrypted.deallocate(capacity: 1)
            cryptPointer.deallocate()
//            cryptPointer.deallocate(capacity: cryptLength)
            return nil
        }
    }
}
