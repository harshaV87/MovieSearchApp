//
//  SearchDebounce.swift
//  MovieSearchApp
//
//  Created by BV Harsha on 2024-06-30.
//

import Foundation
import Combine

protocol SearchDebounceService {
    func getSearchText(textPublisher: AnyPublisher<String, Never>, completion: @escaping (String?) -> ())
}


class SearchDebounce: SearchDebounceService {
    var cancellables = Set<AnyCancellable>()
    func getSearchText(textPublisher: AnyPublisher<String, Never>, completion: @escaping (String?) -> ()) {
        textPublisher.debounce(for: .seconds(1), scheduler: RunLoop.main).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
            break
            }
        } receiveValue: { value in
            completion(value)
        }.store(in: &cancellables)

    }
}
