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
}

class DefaultDownloadsManager: DownloadsEditor {
    
    var observers = NSHashTable<AnyObject>.weakObjects()

    var typedListeners: [DownloadsEditorObserver] {
        typedListeners(for: observers)
    }
    
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
    
    func notifyObservers() {
        typedListeners.forEach { $0.foo() }
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
