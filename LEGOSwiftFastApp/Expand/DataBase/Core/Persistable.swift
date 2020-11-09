//
//  Persistable.swift
//  LEGOSwiftFastApp
//
//  Created by 马陈爽 on 2020/11/4.
//

import Foundation
import CoreData

protocol Persistable: NSFetchRequestResult {
    static func fetchRequest() -> NSFetchRequest<Self>
}
