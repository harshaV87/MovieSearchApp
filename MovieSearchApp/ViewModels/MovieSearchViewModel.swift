//
//  MovieSearchViewModel.swift
//  MovieSearchApp
//
//  Created by BV Harsha on 2024-06-29.
//

import Foundation

protocol MovieSearchViewModelInterface {
    var movieDetails: MovieSearchModel? {get}
    var serviceError: String? {get}
    var searchText: String {get set}
    func fetchMovieDetails(name: String)
    func fecthDefaultMovieDetails()
}


class MovieSearchViewModel: MovieSearchViewModelInterface, ObservableObject {
    
    @Published private(set) var serviceError: String?
    @Published private(set) var movieDetails: MovieSearchModel?
    @Published var searchText: String = ""
    
    private let movieSearchService: MovieSearchRetrievalService
    private let debounceSearchService: SearchDebounceService
    
    
    init(movieSearchService: MovieSearchRetrievalService, debounceSearchService: SearchDebounceService) {
        self.movieSearchService = movieSearchService
        self.debounceSearchService = debounceSearchService
        let searchPublisher = $searchText.eraseToAnyPublisher()
        debounceSearchService.getSearchText(textPublisher: searchPublisher) { [weak self] value in
            
         value != "" ? self?.fetchMovieDetails(name: value ?? "") : self?
                .fecthDefaultMovieDetails()
        }
    }
    
    func fetchMovieDetails(name: String) {
        DispatchQueue.global().async { [weak self] in
            let result = self?.movieSearchService.getMovieDetails(name: name)
            DispatchQueue.main.async { [weak self] in
                self?.movieDetails = result?.0
                self?.serviceError = result?.1?.localizedDescription
            }
        }
    }
    
    func fecthDefaultMovieDetails() {
        DispatchQueue.global().async { [weak self] in
            let result = self?.movieSearchService.getDefaultMovieDetails()
            DispatchQueue.main.async { [weak self] in
                self?.movieDetails = result?.0
                self?.serviceError = result?.1?.localizedDescription
            }
        }
    }
}



