//
//  Networkable.swift
//  MovieSearchApp
//
//  Created by BV Harsha on 2024-06-28.
//

import Foundation
import NetworkKit
import Combine


protocol MovieSearchRetrievalService {
    func getMovieDetails(name: String, year: String) -> (MovieSearchModel?, NetworkServiceError?)
    func getDefaultMovieDetails() -> (MovieSearchModel?, NetworkServiceError?)
}




class MovieSearchResultsProvider: MovieSearchRetrievalService {
    
    private let apiServiceClient: NetworkServiceInterface
    var cancellables = Set<AnyCancellable>()
    
    init(apiServiceClient: NetworkServiceInterface = NetworkService()) {
        self.apiServiceClient = apiServiceClient
    }
    
    func getMovieDetails(name: String, year: String) -> (MovieSearchModel?, NetworkServiceError?) {
        return fetchData(from: .getMovieDetails(fromName: name, fromYear: year), response: MovieSearchModel.self)
    }
    
    func getDefaultMovieDetails() -> (MovieSearchModel?, NetworkServiceError?){
        return fetchData(from: .getDefaultMovieDetails, response: MovieSearchModel.self)
    }
    
    func fetchData<T: Decodable>(from endPoint: MovieSearchEndPoint, response: T.Type) -> (T?, NetworkServiceError?){
        var result: T?
        var networkError: NetworkServiceError?
        let semaphore = DispatchSemaphore(value: 0)
        apiServiceClient.fetchData(from: endPoint, response: response).sink { completion in
            switch completion {
            case .finished: semaphore.signal()
            case .failure(let error) :
                networkError = error
                semaphore.signal()
            }
        } receiveValue: { object in
           result = object
        }.store(in: &cancellables)
        semaphore.wait()
        return (result, networkError)
    }
}

