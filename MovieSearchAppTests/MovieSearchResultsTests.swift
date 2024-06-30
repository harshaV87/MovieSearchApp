//
//  MovieSearchAppTests.swift
//  MovieSearchAppTests
//
//  Created by BV Harsha on 2024-06-28.
//

import XCTest
import NetworkKit
import Combine
@testable import MovieSearchApp

final class MovieSearchAppTests: XCTestCase {

    var movieSearchResultsProvider: MovieSearchRetrievalService!
    var mockAPIClient: NetworkServiceInterface!
    var cancellables : Set<AnyCancellable>!
   
    
    override func setUp() {
     super.setUp()
        cancellables = []
    }
    
    override func tearDown() {
        super.tearDown()
        cancellables = nil
        mockAPIClient = nil
        movieSearchResultsProvider = nil
    }
    
    
    func testMovieDetailsSuccess() {
        let mockMovie = MovieSearchModel(title: "Test Movie", year: "2022", rated: "", released: "", runtime: "", genre: "", director: "", writer: "", actors: "", plot: "", language: "", country: "", awards: "", poster: "", ratings: [], metascore: "", imdbRating: "", imdbVotes: "", imdbID: "", type: "", dvd: "", boxOffice: "", production: "", website: "", response: "")
        // success block injection
        // Injecting a publisher
        let resultPublisher = Just(mockMovie).setFailureType(to: NetworkServiceError.self).eraseToAnyPublisher()
        mockAPIClient = MockNetworkClient(session: URLSession.shared, result: resultPublisher)
        movieSearchResultsProvider = MovieSearchResultsProvider(apiServiceClient: mockAPIClient)
       let results = movieSearchResultsProvider.getMovieDetails(name: "someMovie")
        XCTAssertEqual(results.0?.title, "Test Movie")
    }
    
    func testMovieResultFailure() {
        // Nil injection
        mockAPIClient = MockNetworkClient(session: URLSession.shared, result: nil)
        movieSearchResultsProvider = MovieSearchResultsProvider(apiServiceClient: mockAPIClient)
       let results = movieSearchResultsProvider.getMovieDetails(name: "someMovie")
        XCTAssertNil(results.0)
        XCTAssertEqual(results.1?.localizedDescription, "The request has failed. Error: There is no result set in the mock client")
    }
}


class MockNetworkClient: NetworkServiceInterface {
    var session: URLSession
    
    var result : AnyPublisher<MovieSearchModel, NetworkServiceError>?
    
    init(session: URLSession, result: AnyPublisher<MovieSearchModel, NetworkServiceError>?) {
        self.session = session
        self.result = result
    }
    
    func fetchData<T>(from URLBuilder: any NetworkKit.URLBuilderInterface, response: T.Type) -> AnyPublisher<T, NetworkKit.NetworkServiceError> where T : Decodable {
        // nothing is set, return the fail publisher
        guard let result = result else {
            return Fail(error: NetworkServiceError.requestFailed(NSError(domain: "MockNetworkClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "There is no result set in the mock client"]))).eraseToAnyPublisher()
        }
        // else return the result
        return result.tryMap { movieModel in
            guard let model = movieModel as? T else {
                throw NetworkServiceError.decodingFailed(NSError(domain: "MockNetworkClient", code: -1, userInfo: [NSLocalizedDescriptionKey: "The decodinh has failed in the mock client"]))
            }
            return model
        }.mapError { error in // handle error
            if let networkError = error as? NetworkServiceError {
                return networkError
            } else {
                return NetworkServiceError.requestFailed(error)
            }
        }.eraseToAnyPublisher()
    }
}
