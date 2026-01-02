//
//  SearchViewModel.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

class SearchViewModel {
    
    private(set) var searchedMovies: [Movie] = []

        var updateSrch: (() -> Void)?

        func search(text: String) {
            guard !text.isEmpty else {
                searchedMovies = []
                updateSrch?()
                return
            }
            
            MoviesNetworkManager.shared.getMovies(searchedName: text) { [weak self] searchedMoviesFromClosure in
                DispatchQueue.main.async {
                    self?.searchedMovies = searchedMoviesFromClosure
                    self?.updateSrch?()
                }
            }

        }
}
