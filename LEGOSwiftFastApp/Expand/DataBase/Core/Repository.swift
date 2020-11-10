//
//  Repository.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/4.
//

import Foundation
import CoreData

protocol AbstractRepository {
    associatedtype T
    
    /// 异步查询数据
    /// - Parameters:
    ///   - predicate: SQL语句
    ///   - sortDescriptors: 数据顺序，可选
    ///   - closure: 回调内容，数组 or 错误，默认子线程
    func query(with predicate: NSPredicate?,
               sortDescriptors: [NSSortDescriptor]?,
               complete closure: @escaping ([T]?, Error?) -> Void)
    
    /// 更新或者插入单项数据
    /// - Parameters:
    ///   - predicate: SQL语句
    ///   - updateClosure: 用于更新或者插入数据的回调，默认子线程
    ///   - completeClosure: 更新或插入结果
    func save(with predicate: NSPredicate?,
        update updateClosure: @escaping (T) -> Void,
    complete completeClosure: @escaping (Error?) -> Void)
    
    /// 删除单项数据
    /// - Parameters:
    ///   - predicate: SQL语句
    ///   - closure: 删除结果回调，默认子线程
    func delete(with predicate: NSPredicate, complete closure: @escaping (Error?) -> Void)
    
    func batchUpdate(with predicate: NSPredicate,
               update updateClosure: @escaping ([T]?) -> Void,
           complete completeClosure: @escaping (Error?) -> Void)
    
    func batchInsert(with count: Int,
           update updateClosure: @escaping ([T]) -> Void,
       complete completeClosure: @escaping (Error?) -> Void)
    
    func batchDelete(with predicate: NSPredicate, complete closure: @escaping (Error?) -> Void)
}



final class Repository<T: Persistable>: AbstractRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func query(with predicate: NSPredicate?,
               sortDescriptors: [NSSortDescriptor]?,
               complete closure: @escaping ([T]?, Error?) -> Void) {
        self.context.perform { [weak self] in
            guard let `self` = self else { return }
            let request = T.fetchRequest()
            request.predicate = predicate
            if let descriptors = sortDescriptors {
                request.sortDescriptors = descriptors
            }
            do {
                let entities = try self.context.fetch(request)
                closure(entities, nil)
            } catch {
                closure(nil, error)
            }
        }
    }
    
    func save(with predicate: NSPredicate?,
        update updateClosure: @escaping (T) -> Void,
    complete completeClosure: @escaping (Error?) -> Void) {
        self.context.perform { [weak self] in
            guard let `self` = self else { return }
            let request = T.fetchRequest()
            if let predicate = predicate {
                request.predicate = predicate
            }
            do {
                let result = try self.context.fetch(request).first ?? self.context.create()
                updateClosure(result)
                try self.context.save()
                completeClosure(nil)
            } catch  {
                completeClosure(error)
            }
        }
    }
    
    func delete(with predicate: NSPredicate, complete closure: @escaping (Error?) -> Void) {
        self.context.perform { [weak self] in
            guard let `self` = self else { return }
            let request = T.fetchRequest()
            request.predicate = predicate
            do {
                guard let result = try self.context.fetch(request).first as? NSManagedObject else {
                    closure(nil)
                    return
                }
                self.context.delete(result)
                try self.context.save()
                closure(nil)
            } catch {
                closure(error)
            }
        }
    }
    
    
    func batchUpdate(with predicate: NSPredicate,
               update updateClosure: @escaping ([T]?) -> Void,
           complete completeClosure: @escaping (Error?) -> Void) {
        self.context.perform { [weak self] in
            guard let `self` = self else { return }
            let request = T.fetchRequest()
            request.predicate = predicate
            do {
                let results = try self.context.fetch(request)
                updateClosure(results)
                try self.context.save()
                completeClosure(nil)
            } catch  {
                completeClosure(error)
            }
        }
        
    }
    
    func batchInsert(with count: Int,
           update updateClosure: @escaping ([T]) -> Void,
       complete completeClosure: @escaping (Error?) -> Void) {
        self.context.perform { [weak self] in
            guard let `self` = self else { return }
            do {
                var results = [T]()
                for _ in 0 ..< count {
                    results.append(self.context.create())
                }
                updateClosure(results)
                try self.context.save()
                completeClosure(nil)
            } catch  {
                completeClosure(error)
            }
        }
    }
    
    func batchDelete(with predicate: NSPredicate,
                   complete closure: @escaping (Error?) -> Void) {
        self.context.perform { [weak self] in
            guard let `self` = self else { return }
            let request = T.fetchRequest()
            request.predicate = predicate
            do {
                guard let results = try self.context.fetch(request) as? [NSManagedObject] else {
                    closure(nil)
                    return
                }
                results.forEach {
                    self.context.delete($0)
                }
                try self.context.save()
                closure(nil)
            } catch {
                closure(error)
            }
        }
    }
}

