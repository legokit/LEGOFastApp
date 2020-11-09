//
//  NSManagedObjectContext+Ext.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/4.
//

import Foundation

import CoreData

extension NSManagedObjectContext {
    func create<T: NSFetchRequestResult>() -> T {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: String(describing: T.self),
                into: self) as? T else {
            fatalError()
        }
        return entity
    }
}
