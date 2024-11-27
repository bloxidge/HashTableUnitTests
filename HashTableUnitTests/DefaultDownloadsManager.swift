//
//  DefaultDownloadsManager.swift
//  HashTableUnitTests
//
//  Created by Dan Ellis on 26/09/2024.
//

import Foundation

@objc protocol DownloadsEditorObserver: AnyObject {
    func foo()
}

protocol DownloadsEditor {
    func add(observer: any DownloadsEditorObserver)
    func remove(observer: any DownloadsEditorObserver)
    func removeSafe(observer: any DownloadsEditorObserver) async
}

class DefaultDownloadsManager: DownloadsEditor {
    
    var observers = ThreadSafeWeakCollection<any DownloadsEditorObserver>()

//    var typedListeners: [DownloadsEditorObserver] {
//        typedListeners(for: observers)
//    }
    
    private func typedListeners(for hashTable: NSHashTable<AnyObject>) -> [DownloadsEditorObserver] {
        return hashTable.objectEnumerator().compactMap({ (listener) -> DownloadsEditorObserver? in
            return listener as? DownloadsEditorObserver
        })
    }

    func add(observer: any DownloadsEditorObserver) {
        observers.add(observer)
    }
    
    func remove(observer: any DownloadsEditorObserver) {
        observers.remove(observer)
    }
    
    @MainActor
    func addSafe(observer: any DownloadsEditorObserver) {
        observers.add(observer)
    }
    
    @MainActor
    func removeSafe(observer: any DownloadsEditorObserver) {
        observers.remove(observer)
    }
    
    func notifyObservers() {
        observers.allObjects.forEach { $0.foo() }
    }
}


class DefaultDownloadsEditorObserver: DownloadsEditorObserver {
    func foo() {
        print("DANE - foo called")
    }
}


class DefaultRemovingDownloadsEditorObserver: DownloadsEditorObserver {
    
    var observable: DownloadsEditor?
    
    deinit {
        if let observable {
            print("DANE - Deinit - Removing Self")
            observable.remove(observer: self)
        } else {
            print("DANE - Deinit - No Observable")
        }
    }
    
    func foo() {
        print("DANE - foo called")
    }
}

class DefaultSafeRemovingDownloadsEditorObserver: DownloadsEditorObserver {
    
    var observable: DownloadsEditor?
    
    deinit {
        Task {
            await observable?.removeSafe(observer: self)
        }
    }
    
    func foo() {
        print("DANE - foo called")
    }
}
