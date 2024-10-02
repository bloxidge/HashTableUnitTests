//
//  ContentViewModel.swift
//  HashTableUnitTests
//
//  Created by Dan Ellis on 30/09/2024.
//

import Foundation

class ContentViewModel: ObservableObject {
    
    static let downloadManager: DefaultDownloadsManager = DefaultDownloadsManager()
    
    var dm: DefaultDownloadsManager {
        Self.downloadManager
    }
    
    @Published var observerCount = 0
    
    var observers: [DownloadsEditorObserver] = []
    
    func refreshCount() {
        observerCount = dm.observers.count
    }
    
    func addObserver() {
        let observer = DefaultDownloadsEditorObserver()
        observers.append(observer)
        dm.add(observer: observer)
        
        dm.notifyObservers()
    }
    
    func popObserver() {
        guard let observer = observers.popLast() else { return }
        dm.remove(observer: observer)
    }
    
    func removeNewObserver() {
        let newObserver = DefaultDownloadsEditorObserver()
        dm.remove(observer: newObserver)
    }
    
    func removeDuringDeinit() {
        var observer: DefaultRemovingDownloadsEditorObserver? = DefaultRemovingDownloadsEditorObserver()
        
        observer?.observable = dm
        
        dm.add(observer: observer!)
        dm.notifyObservers()
        refreshCount()
        observer = nil
    }
    
    func removeMultipleThreads() {
        let observer = DefaultDownloadsEditorObserver()
        let observer2 = DefaultDownloadsEditorObserver()
//        observers.append(observer)
        dm.add(observer: observer)
        dm.add(observer: observer2)
        
        dm.notifyObservers()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            print("Removing from \(Thread.current)")
            self.dm.remove(observer: observer)
        }
        
        DispatchQueue.global().asyncAfter(deadline: .now()) {
            print("Removing from \(Thread.current)")
            self.dm.remove(observer: observer2)
        }
    }
    
    func removeManyThreads() {

        let iterations = 10
        var observers: [DefaultDownloadsEditorObserver] = []
        
        for i in 0...iterations {
            let observer = DefaultDownloadsEditorObserver()
            self.dm.add(observer: observer)
            observers.append(observer)
        }
        
        DispatchQueue.concurrentPerform(iterations: 10) { i in
//            print("Performing \(i) from \(Thread.current)")
//            print("Performing \(i)")
            
//            let observer = DefaultDownloadsEditorObserver()
//            self.dm.add(observer: observer)
            
            self.dm.remove(observer: observers[i])
        }
    }
    
    func mainActorRemoveManyThreads() {
        let iterations = 10
        var observers: [DefaultDownloadsEditorObserver] = []
        
        for _ in 0...iterations {
            let observer = DefaultDownloadsEditorObserver()
            Task {
                await self.dm.addSafe(observer: observer)
            }
            observers.append(observer)
        }
        
        DispatchQueue.concurrentPerform(iterations: 10) { i in

            let obs = observers[i]
            Task {
                await self.dm.removeSafe(observer: obs)
            }
        }
    }
    
    func mainActorRemoveManyThreadsDeinit() {
        let iterations = 10
        var observers: [DefaultSafeRemovingDownloadsEditorObserver] = []
        
        for _ in 0...iterations {
            let observer = DefaultSafeRemovingDownloadsEditorObserver()
            Task {
                await self.dm.addSafe(observer: observer)
            }
            observers.append(observer)
        }
        
        DispatchQueue.concurrentPerform(iterations: 10) { i in
            _ = observers.popLast()
        }
        refreshCount()
    }
    
}
