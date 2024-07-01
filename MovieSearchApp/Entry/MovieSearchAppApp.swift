//
//  MovieSearchAppApp.swift
//  MovieSearchApp
//
//  Created by BV Harsha on 2024-06-28.
//

import SwiftUI

@main
struct MovieSearchAppApp: App {
   
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: MovieSearchViewModel(movieSearchService: MovieSearchResultsProvider(), debounceSearchService: SearchDebounce()))
        }
    }
}
