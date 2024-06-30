//
//  ContentView.swift
//  MovieSearchApp
//
//  Created by BV Harsha on 2024-06-28.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = MovieSearchViewModel(movieSearchService: MovieSearchResultsProvider())
    
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            TextField("Search", text: $searchText , onCommit: {
            viewModel.fetchMovieDetails(name: searchText) }
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            if let _ = viewModel.serviceError {
                Text("Search results are not available. Please try again or search for a different movie name")
                    .foregroundColor(.red)
            } else {
                
                    HStack {
                        AsyncImage(url: URL(string: viewModel.movieDetails?.poster ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        } placeholder: {
                            ProgressView()
                        }
                        VStack(alignment: .leading) {
                            Text(viewModel.movieDetails?.title ?? "")
                                .font(.headline)
                            Text(viewModel.movieDetails?.year ?? "")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            // Do nothing
                        }) {
                            Text("Button")
                        }
                    }
            }
        }
        .onAppear() {
            viewModel.fetchMovieDetails(name: "Guardians+of+the+Galaxy+Vol.")
        }
    }
}


#Preview {
    ContentView()
}
