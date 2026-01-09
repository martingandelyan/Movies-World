//
//  SearchViewModel.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

class SearchViewModel {
    
    private(set) var searchedMovies: [Movie] = []
    private var currentPage = 1
    private var currentEnteredText = ""
    private var isFetching = false
    
    var currentSortedType: SearchSortType = .name
    
    var isSearching = false
    var isLoading = false
    
    var updateSrch: (() -> Void)?
    
    // MARK: - New Search
    func search(text: String) {
        guard !text.isEmpty else {
            DispatchQueue.main.async {
                self.searchedMovies.removeAll()
                self.isSearching = false
                self.isLoading = false
                self.updateSrch?()
            }
                return
        }
        
        //MARK: New search
        currentPage = 1
        currentEnteredText = text
        
        DispatchQueue.main.async {
            self.searchedMovies.removeAll()
            self.isSearching = true
            self.isLoading = true
            self.updateSrch?()
        }
        fetchSearchedMovies()
    }
    
    func loadMoreMoviesIfNeeded(index: Int) {
        if index == self.searchedMovies.count - 2 {
            fetchSearchedMovies()
        }
    }
    
    func fetchSearchedMovies() {
        guard !isFetching else { return }
        isLoading = true
        isFetching = true
        
        DispatchQueue.main.async {
            MoviesNetworkManager.shared.getMovies(searchedName: self.currentEnteredText, page: self.currentPage) { [weak self] searchedMvs, _ in
                
                guard let self else { return }
                
                self.searchedMovies.append(contentsOf: searchedMvs ?? [])
                self.currentPage += 1
                self.isFetching = false
                self.isLoading = false
                self.updateSrch?()
            }
        }
    }
    
    func sortByTitle() {
        DispatchQueue.main.async {
            self.searchedMovies.sort { $0.title < $1.title }
            self.updateSrch?()
        }
    }

    func sortByYear() {
        DispatchQueue.main.async {
            self.searchedMovies.sort { $0.year > $1.year }
            self.updateSrch?()
        }
    }
    
    func sortByType() {
        DispatchQueue.main.async {
            self.searchedMovies.sort { $0.type < $1.type }
            self.updateSrch?()
        }
    }
}

enum SearchSortType {
    case name
    case year
    case type
}
