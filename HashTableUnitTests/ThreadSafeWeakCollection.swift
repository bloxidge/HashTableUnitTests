//
//  ThreadSafeWeakCollection.swift
//  HashTableUnitTests
//
//  Created by Peter Bloxidge on 26/11/2024.
//

import Foundation

final class ThreadSafeWeakCollection<T: AnyObject> {
    private let queue = DispatchQueue(label: "com.HashTableUnitTests.ThreadSafeWeakCollection")
    private let storage = NSHashTable<T>.weakObjects()

    var allObjects: [T] {
        queue.sync {
            storage.allObjects
        }
    }

    var count: Int {
        queue.sync {
            storage.count
        }
    }

    func add(_ object: T?) {
        queue.sync(flags: .barrier) {
            storage.add(object)
        }
    }

    func remove(_ object: T?) {
        queue.sync(flags: .barrier) {
            storage.remove(object)
        }
    }

    func removeAllObjects() {
        queue.sync(flags: .barrier) {
            storage.removeAllObjects()
        }
    }

    func contains(_ anObject: T?) -> Bool {
        queue.sync {
            storage.contains(anObject)
        }
    }
}
