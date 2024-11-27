//
//  HashTableUnitTestsTests.swift
//  HashTableUnitTestsTests
//
//  Created by Dan Ellis on 26/09/2024.
//

import XCTest
@testable import HashTableUnitTests

final class HashTableUnitTestsTests: XCTestCase {
    
    func testBasicAddAndRemove() throws {
        let sut = DefaultDownloadsManager()
        
        let stubObserver = StubDownloadsEditorObserver()
        
        sut.add(observer: stubObserver)
        
        sut.notifyObservers()
        XCTAssertEqual(sut.observers.count, 1)
        
        sut.remove(observer: stubObserver)
        
        XCTAssertEqual(sut.observers.count, 0)
    }
    
    func testRemoveObjectThatIsNotIn() throws {
        let sut = DefaultDownloadsManager()
        
        let stubObserver = StubDownloadsEditorObserver()
        let stubObserver2 = StubDownloadsEditorObserver()
        
        sut.add(observer: stubObserver)
        
        sut.notifyObservers()
        XCTAssertEqual(sut.observers.count, 1)
        
        sut.remove(observer: stubObserver2)
        
        XCTAssertEqual(sut.observers.count, 1)
    }
    
    func testRemoveObjectFromEmpty() throws {
        let sut = DefaultDownloadsManager()
        
        let stubObserver = StubDownloadsEditorObserver()
        
        sut.notifyObservers()
        XCTAssertEqual(sut.observers.count, 0)
        
        sut.remove(observer: stubObserver)
        sut.remove(observer: stubObserver)
        
        XCTAssertEqual(sut.observers.count, 0)
    }
    
    func testRemoveCalledDuringDeinit() async throws {
        let sut = DefaultDownloadsManager()
        
        var stubObserver: RemovingDownloadsEditorObserver? = RemovingDownloadsEditorObserver()
        stubObserver?.observable = sut
        sut.add(observer: stubObserver!)
        sut.notifyObservers()
        XCTAssertEqual(sut.observers.count, 1)
        
        stubObserver = nil
        
        print("DANE - Count \(sut.observers.count)")
        try await Task.sleep(nanoseconds: 100_000)
//        print("DANE - Count \(sut.observers.count)")
        XCTAssertEqual(sut.observers.count, 0)
    }
    
    func testRemoveCalledDuringDeinitAssertNil() async throws {
        let sut = DefaultDownloadsManager()
        
        var stubObserver: RemovingDownloadsEditorObserver? = RemovingDownloadsEditorObserver()
        stubObserver?.observable = sut
        sut.add(observer: stubObserver!)
        sut.notifyObservers()
        XCTAssertEqual(sut.observers.count, 1)
        
        stubObserver = nil
        
        print("DANE - Count \(sut.observers.count)")

        XCTAssertNil(stubObserver)
    }
    
    func testRemoveAlreadyWeakObserver() throws {
        let sut = DefaultDownloadsManager()

        var stubObserver: StubDownloadsEditorObserver? = StubDownloadsEditorObserver()

        sut.add(observer: stubObserver!)

        sut.notifyObservers()
        XCTAssertEqual(sut.observers.count, 1)

        sut.remove(observer: stubObserver!)

        XCTAssertEqual(sut.observers.count, 0)
    }
    
}

class StubDownloadsEditorObserver: DownloadsEditorObserver {
    func foo() {
        print("DANE - foo called")
    }
}


class RemovingDownloadsEditorObserver: DownloadsEditorObserver {
    
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
