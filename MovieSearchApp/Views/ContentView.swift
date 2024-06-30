//
//  ContentView.swift
//  MovieSearchApp
//
//  Created by BV Harsha on 2024-06-28.
//

import SwiftUI


struct ContentView: View {
    
   @StateObject var viewModel = MovieSearchViewModel(movieSearchService: MovieSearchResultsProvider())
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text((viewModel.movieDetails?.country ?? viewModel.serviceError) ?? "")
        }
        .padding().onAppear() {
            viewModel.fetchMovieDetails(name: "Guardians+of+the+Galaxy+Vol.", year: "2017")
        }
    }
}

#Preview {
    ContentView()
}







