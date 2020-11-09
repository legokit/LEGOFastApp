//
//  SHACrypto.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/9.
//

import Foundation
import CommonCrypto

public enum Algorithm {
    case md5, sha1, sha224, sha256, sha384, sha512

    fileprivate var hmacAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .md5:        result = kCCHmacAlgMD5
        case .sha1:        result = kCCHmacAlgSHA1
        case .sha224:    result = kCCHmacAlgSHA224
        case .sha256:    result = kCCHmacAlgSHA256
        case .sha384:    result = kCCHmacAlgSHA384
        case .sha512:    result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }

    fileprivate typealias DigestAlgorithm = (UnsafeRawPointer, CC_LONG, UnsafeMutablePointer<UInt8>) -> UnsafeMutablePointer<UInt8>?

    fileprivate var digestAlgorithm: DigestAlgorithm {
        switch self {
        case .md5:      return CC_MD5
        case .sha1:     return CC_SHA1
        case .sha224:   return CC_SHA224
        case .sha256:   return CC_SHA256
        case .sha384:   return CC_SHA384
        case .sha512:   return CC_SHA512
        }
    }

    public var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .md5:        result = CC_MD5_DIGEST_LENGTH
        case .sha1:        result = CC_SHA1_DIGEST_LENGTH
        case .sha224:    result = CC_SHA224_DIGEST_LENGTH
        case .sha256:    result = CC_SHA256_DIGEST_LENGTH
        case .sha384:    result = CC_SHA384_DIGEST_LENGTH
        case .sha512:    result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

public protocol Cryptoable {
    associatedtype Hash
    func digest(_ algorithm: Algorithm, key: String?) -> Hash

    var md5: Hash { get }
    var sha1: Hash { get }
    var sha224: Hash { get }
    var sha256: Hash { get }
    var sha384: Hash { get }
    var sha512: Hash { get }
}

extension Cryptoable {

    public var md5: Hash {
        return digest(.md5, key: nil)
    }

    public var sha1: Hash {
        return digest(.sha1, key: nil)
    }

    public var sha224: Hash {
        return digest(.sha224, key: nil)
    }

    public var sha256: Hash {
        return digest(.sha256, key: nil)
    }

    public var sha384: Hash {
        return digest(.sha384, key: nil)
    }

    public var sha512: Hash {
        return digest(.sha512, key: nil)
    }

}

extension String: Cryptoable {

    public func digest(_ algorithm: Algorithm) -> String {
        return digest(algorithm, key: Optional<Data>.none)
    }

    public func digest(_ algorithm: Algorithm, key: String?) -> String {
        return digest(algorithm, key: key?.data(using: .utf8))
    }

    public func digest(_ algorithm: Algorithm, key: Data?) -> String {
        let str = Array(self.utf8CString)
        let strLen = str.count-1
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)

        if let key = key {
            
            #if swift(>=5.0)
            
            key.withUnsafeBytes {
                
                CCHmac(algorithm.hmacAlgorithm, $0.baseAddress, key.count, str, count, result)
            }
            
            #elseif swift(>=4.2) && compiler(>=5.0)
            
            key.withUnsafeBytes { (bytes: UnsafePointer<[Int8]>) -> Void in
                let buffer = UnsafeBufferPointer(start: bytes, count: key.count)
                CCHmac(algorithm.hmacAlgorithm, Array(buffer), key.count, str, count, result)
            }
            
            #else
            
            key.withUnsafeBytes { body in
                CCHmac(algorithm.hmacAlgorithm, UnsafeRawPointer(body), key.count, str, count, result)
            }
            
            #endif

        } else {
            _ = algorithm.digestAlgorithm(str, CC_LONG(strLen), result)
        }

        let digest = result.toHexString(count: digestLen)

        result.deallocate()

        return digest
    }

}

extension Data: Cryptoable {

    public func digest(_ algorithm: Algorithm) -> Data {
        return digest(algorithm, key: Optional<Data>.none)
    }

    public func digest(_ algorithm: Algorithm, key: String?) -> Data {
        return digest(algorithm, key: key?.data(using: .utf8))
    }

    public func digest(_ algorithm: Algorithm, key: Data?) -> Data {
        let count = self.count
        let digestLen = algorithm.digestLength

        #if swift(>=5.0)
        return self.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> Data in
            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
            defer {
                result.deallocate()
            }
            
            if let key = key {
    
                key.withUnsafeBytes {
                    
                    CCHmac(algorithm.hmacAlgorithm, $0.baseAddress, key.count, bytes.baseAddress, count, result)
                }
            } else {
                _ = algorithm.digestAlgorithm(bytes.baseAddress!, CC_LONG(count), result)
            }
            
            return Data(bytes: result, count: digestLen)
        }
        #else
        return self.withUnsafeBytes { (bytes: UnsafePointer<UInt8>) -> Data in
            let result = UnsafeMutablePointer<UInt8>.allocate(capacity: digestLen)
            defer {
                result.deallocate()
            }
            
            if let key = key {
                key.withUnsafeBytes { body in
                    CCHmac(algorithm.hmacAlgorithm, UnsafeRawPointer(body), key.count, bytes, count, result)
                }
            } else {
                _ = algorithm.digestAlgorithm(bytes, CC_LONG(count), result)
            }
            
            return Data(bytes: result, count: digestLen)
        }
        #endif
        
        
    }

}

private extension UnsafeMutablePointer where Pointee == CUnsignedChar {

    func toHexString(count: Int) -> String {
        var result = String()
        for i in 0..<count {
            let s = String(self[i], radix: 16)
            if s.count % 2 == 1 {
                result.append("0"+s)
            } else {
                result.append(s)
            }
        }
        return result
    }

}
