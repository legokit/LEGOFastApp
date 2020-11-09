//
//  ImageManager.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/4.
//

import Foundation
import Kingfisher

class ImageManager {
    
    private let folderName = "FimoAlbum"
    
    
    let imageCache: ImageCache
    
    static let share = ImageManager()
    
    init() {
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        self.imageCache = try! ImageCache(name: folderName, cacheDirectoryURL: url, diskCachePathClosure: nil)
    }
    
    func storeToDisk(_ data: Data, forKey key: String, iCloudEnable enable: Bool = true, completionHandler: ((CacheStoreResult) -> Void)? = nil) {
        if enable {
            self.imageCache.storeToDisk(data, forKey: key, expiration: .never, completionHandler: completionHandler)
        } else {
            self.imageCache.storeToDisk(data, forKey: key, expiration: .never) { (result) in
                switch result.diskCacheResult {
                case .success():
                    let filePathStr = self.imageCache.cachePath(forKey: key)
                    var fileUrl = URL(fileURLWithPath: filePathStr)
                    var resourceValues = URLResourceValues()
                    resourceValues.isExcludedFromBackup = true
                    do {
                        try fileUrl.setResourceValues(resourceValues)
                    } catch  {
                        log.debug("\(error.localizedDescription)")
                    }
                case .failure(let error):
                    log.debug("\(error.localizedDescription)")
                }
            }
        }
    }
}
