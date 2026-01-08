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
    
    var moviesUploaded: (() -> Void)?
    
    private let randomSearchedWords = [
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
    
    func loadRandomMovies() {
        let randomWord = randomSearchedWords.randomElement() ?? "city"
        
        moviesManager.getMovies(searchedName: randomWord) { randomLoadedMovies in
            print("movies loaded\(randomLoadedMovies?.count)")
            self.movies = randomLoadedMovies ?? []
            self.moviesUploaded?()
        }
    }
}

