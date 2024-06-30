//
//  MovieSearchViewModelTests.swift
//  MovieSearchAppTests
//
//  Created by BV Harsha on 2024-06-29.
//

import XCTest
import UIKit
import NetworkKit
@testable import MovieSearchApp

final class MovieSearchViewModelTests: XCTestCase {

    var movieSearchMock : MovieSearchRetrievalService!
    var movieSearchViewModel: MovieSearchViewModelInterface!
    
    override func setUp() {}
    
    func testModelSuccessFromService() {
        let mockMovie = MovieSearchModel(title: "Test Movie", year: "2022", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", country: "", awards: "", poster: "", ratings: [], metascore: "", imdbRating: "", imdbVotes: "", imdbID: "", type: "", dvd: "", boxOffice: "", production: "", website: "", response: "")
        
        movieSearchMock = MockMovieSearchService(output: (mockMovie, nil))
        movieSearchViewModel = MovieSearchViewModel(movieSearchService: movieSearchMock)
        let result =  movieSearchMock.getMovieDetails(name: "")
          XCTAssertNotNil(result.0)
          XCTAssertNil(result.1)
    }
    
    func testModelFailureFromService() {
        movieSearchMock = MockMovieSearchService(output: (nil, NetworkServiceError.unknown))
        movieSearchViewModel = MovieSearchViewModel(movieSearchService: movieSearchMock)
      let result =  movieSearchMock.getMovieDetails(name: "")
        XCTAssertNil(result.0)
        XCTAssertNotNil(result.1)
        XCTAssertEqual(result.1?.localizedDescription, "An unknown error has occured")
    }
    
    override func tearDown() {
        movieSearchViewModel = nil
        movieSearchMock = nil
    }
}


class MockMovieSearchService: MovieSearchRetrievalService {
   
    var output: (MovieObject: MovieSearchModel?, ServiceOutError: NetworkServiceError?)
       
    init(output: (MovieObject: MovieSearchModel?, ServiceOutError: NetworkServiceError?)) {
        self.output = output
    }
    
    func getMovieDetails(name: String) -> (MovieSearchApp.MovieSearchModel?, NetworkKit.NetworkServiceError?) {
        return (output.MovieObject, output.ServiceOutError)
    }
    
    func getDefaultMovieDetails() -> (MovieSearchApp.MovieSearchModel?, NetworkKit.NetworkServiceError?) {
        return (output.MovieObject, output.ServiceOutError)
    }
}
