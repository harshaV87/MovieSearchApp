//
//  MockDebounceSearchServiceTests.swift
//  MovieSearchAppTests
//
//  Created by BV Harsha on 2024-06-30.
//

import XCTest
import Combine
import NetworkKit
@testable import MovieSearchApp

final class MockDebounceSearchServiceTests: XCTestCase {

    var sut: SearchDebounce!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = SearchDebounce()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        cancellables = nil
    }
    
    func testDebounceEmitsValueAfterDelay() {
        let expectation = expectation(description: "debounce value should be emitted after delay")
        let testPublisher = PassthroughSubject<String, Never>()
        var receivedValue: String?
        sut.getSearchText(textPublisher: testPublisher.eraseToAnyPublisher()) { value in
            receivedValue = value
            expectation.fulfill()
        }
        testPublisher.send("test value")
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(receivedValue, "test value")
    }
    
    func testDebounceEmitsValueWithMultipleInputsDelay() {
        let expectation = expectation(description: "debounce value should be emitted after multiple inputs and delay")
        let testPublisher = PassthroughSubject<String, Never>()
        var receivedValue: String?
        sut.getSearchText(textPublisher: testPublisher.eraseToAnyPublisher()) { value in
            receivedValue = value
            expectation.fulfill()
        }
        testPublisher.send("first value")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            testPublisher.send("second value")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            testPublisher.send("third value")
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            testPublisher.send("fourth value")
        }
        wait(for: [expectation], timeout: 3.0)
        XCTAssertEqual(receivedValue, "fourth value")
    }
}
