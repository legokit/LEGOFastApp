//
//  CoreDataStack.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/4.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    static let share = CoreDataStack()
    
    private let storeCoordinator: NSPersistentStoreCoordinator
    let context: NSManagedObjectContext
    
    public init() {
        let bundle = Bundle(for: CoreDataStack.self)
        guard let url = bundle.url(forResource: "Database", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError()
        }
        self.storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        self.context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.storeCoordinator
        self.migrateStore()
    }
    
    public init(named: String) {
        let bundle = Bundle(for: CoreDataStack.self)
        guard let url = bundle.url(forResource: named, withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: url) else {
            fatalError()
        }
        self.storeCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        self.context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.context.persistentStoreCoordinator = self.storeCoordinator
        self.migrateStore()
    }
    
    private func migrateStore() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
            fatalError()
        }
        let storeUrl = url.appendingPathComponent("Model.sqlite")
        do {
            try storeCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                    configurationName: nil,
                    at: storeUrl,
                    options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
}
