//
//  MovieSearchEndpoint.swift
//  MovieSearchApp
//
//  Created by BV Harsha on 2024-06-30.
//

import Foundation
import NetworkKit


// Movie service endpoint
enum MovieSearchEndPoint : URLBuilderInterface {
    
    case getMovieDetails(fromName: String)
    // Write a case for a generic use case that is present when the app is launched
    case getDefaultMovieDetails
    
    func buildURL() -> URL? {
        switch self {
        case .getMovieDetails(let name):
            let queryItemName = URLQueryItem(name: "t", value: "\(name)")
            let queryItemApiKey = URLQueryItem(name: "apikey", value: "d9482b5b")
            let URLComponent = URLComponentsBuilder(scheme: "https", host: "www.omdbapi.com", path: "/", queryItems: [queryItemName, queryItemApiKey])
            return URLComponent.buildURL()
            
        case .getDefaultMovieDetails:
            let queryItemID = URLQueryItem(name: "i", value: "tt3896198")
            let queryItemApiKey = URLQueryItem(name: "apikey", value: "d9482b5b")
            let URLComponent = URLComponentsBuilder(scheme: "https", host: "www.omdbapi.com", path: "/", queryItems: [queryItemID, queryItemApiKey])
            return URLComponent.buildURL()
        }
    }
    
    func isValidURL() throws -> Bool {
        return true
    }
}
