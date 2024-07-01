//
//  ContentView.swift
//  MovieSearchApp
//
//  Created by BV Harsha on 2024-06-28.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: MovieSearchViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            TextField("Search", text: $viewModel.searchText
            )
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            if let _ = viewModel.serviceError {
                Text("No results. Please try again or search for a different movie name")
                    .foregroundColor(.red).padding()
            } else {
                    VStack {
                        AsyncImage(url: URL(string: viewModel.movieDetails?.poster ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 250, height: 250)
                        } placeholder: {
                            ProgressView().padding()
                        }
                        VStack(alignment: .center) {
                            Text(viewModel.movieDetails?.title ?? "")
                                .font(.headline)
                            Text(viewModel.movieDetails?.year ?? "")
                                .font(.headline)
                            Text(viewModel.movieDetails?.country ?? "")
                                .font(.subheadline)
                            Text("Director: \(viewModel.movieDetails?.director ?? "")")
                                .font(.subheadline)
                            Text(viewModel.movieDetails?.language ?? "")
                                .font(.subheadline)
                        }
                        Spacer()
                        Button(action: {
                            // To do
                        }) {
                            Text("Button") .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                        }.padding()
                    }
            }
        }
    }
}
