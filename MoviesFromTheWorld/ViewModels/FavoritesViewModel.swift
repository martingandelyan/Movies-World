//
//  ViewController.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

class FavoritesViewModel {
    
    static let shared = FavoritesViewModel()
    private init() {}

    var favoriteMovies: [MovieDetails] {
        FavoritesManager.shared.favoriteMovies
    }
    
    var movieAdded: (() -> Void)?
    
    func refreshTab() {
        movieAdded?()
    }
}

