//
//  ViewController.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

class MoviesMainViewModel {
    
    private let moviesManager = MoviesNetworkManager.shared
    
    private(set) var movies: [Movie] = []
    private var isFetching = false
    private var currentPage = 1
    private var currentTotalResult = 0
    private var currentSelectedWord = ""
    
    var moviesUploaded: (() -> Void)?
    
    private var randomSearchedWords = [
        "world",
        "dark",
        "super",
        "man",
        "iron",
        "girl",
        "war",
        "city",
        "night"
    ]
    
    func loadMoreOnMainIfNeeded(index: Int) {
        if index >= movies.count - 2, movies.count < currentTotalResult {
                loadRandomMovies()
            }
        }
    
    func loadRandomMovies() {
        guard !isFetching else { return }
        isFetching = true
        
        if currentSelectedWord.isEmpty {
            currentSelectedWord = randomSearchedWords.randomElement() ?? "city"
            currentPage = 1
            movies.removeAll()
            currentTotalResult = 0
        }
        
        moviesManager.getMovies(searchedName: currentSelectedWord, page: currentPage) { [weak self] randomLoadedMovies, totalresult in
            print("movies loaded: \(randomLoadedMovies?.count ?? 0), Total result is: \(totalresult)")
            
            guard let self = self else { return }
            guard let loadedMovies = randomLoadedMovies else {
                isFetching = false
                return
            }
            
            if self.currentTotalResult == 0 {
                self.currentTotalResult = totalresult
            }
            
            DispatchQueue.main.async {
                self.movies.append(contentsOf: loadedMovies)
                self.currentPage += 1
                self.moviesUploaded?()
                self.isFetching = false
            }
        }
    }
}

