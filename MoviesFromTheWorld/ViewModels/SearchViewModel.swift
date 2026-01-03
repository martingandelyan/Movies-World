//
//  SearchViewModel.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

class SearchViewModel {
    
    private(set) var searchedMovies: [Movie] = []
    
    var currentSortedType: SearchSortType = .name
    
    var isSearching = false
    var isLoading = false
    
    var updateSrch: (() -> Void)?

    func search(text: String) {
        guard !text.isEmpty else {
            searchedMovies = []
            isSearching = false
            isLoading = false
            updateSrch?()
            return
        }
        
        isSearching = true
        isLoading = true
        updateSrch?()
        
        
        MoviesNetworkManager.shared.getMovies(searchedName: text) { [weak self] searchedMoviesFromClosure in
            DispatchQueue.main.async {
                self?.searchedMovies = searchedMoviesFromClosure
                self?.isLoading = false
                self?.updateSrch?()
            }
        }
    }
    
    func sortByTitle() {
        searchedMovies.sort { $0.title < $1.title }
        updateSrch?()
    }

    func sortByYear() {
        searchedMovies.sort { $0.year > $1.year }
        updateSrch?()
    }
    
    func sortByType() {
        searchedMovies.sort { $0.type < $1.type }
        updateSrch?()
    }
}

enum SearchSortType {
    case name
    case year
    case type
}
