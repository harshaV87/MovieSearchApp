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

final class MovieViewModelSearchServiceTests: XCTestCase {

    var sut : MovieSearchViewModelInterface!
    var searchService: SearchDebounceService!
    var movieSearchMock : MockMovieRetrievalServiceForDebounce!
    
    override func setUp() {
        super.setUp()
        movieSearchMock = MockMovieRetrievalServiceForDebounce()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
        searchService = nil
        movieSearchMock = nil
    }
    

    func testInitialisationWithEmptySearchText() {
        sut = MovieSearchViewModel(movieSearchService: movieSearchMock, debounceSearchService: MockDebounceService(completionInjection: ""))
           let expectation = XCTestExpectation(description: "EmptySearchText")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            XCTAssertEqual(self?.movieSearchMock.defaultMovieDetailsCalled, true)
            XCTAssertEqual(self?.movieSearchMock.getMovieDetailsCalled, false)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}



class MockMovieRetrievalServiceForDebounce: MovieSearchRetrievalService {
    
    private(set) var getMovieDetailsCalled = false
    private(set) var defaultMovieDetailsCalled = false
    
    func getMovieDetails(name: String) -> (MovieSearchApp.MovieSearchModel?, NetworkKit.NetworkServiceError?) {
        getMovieDetailsCalled = true
        return(nil, nil)
    }
    
    func getDefaultMovieDetails() -> (MovieSearchApp.MovieSearchModel?, NetworkKit.NetworkServiceError?) {
        defaultMovieDetailsCalled = true
        return(nil, nil)
    }
}
