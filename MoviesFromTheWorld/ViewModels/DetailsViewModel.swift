//
//  DetailsViewModel.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

class DetailsViewModel {
    
    private let detailsNetworkManager = MoviesNetworkManager.shared
    
    private var imdbID: String
    init(imdbID: String) {
        self.imdbID = imdbID
    }
    
    var detailsMovie: MovieDetails?
    
    var detailsUploaded: (() -> Void)?
    
    func refreshTab() {
        detailsUploaded?()
    }
    
    func loadDetails() {
        detailsNetworkManager.getDetails(imdbID:imdbID) { [weak self] detailsOfmovie in
            self?.detailsMovie = detailsOfmovie
            
            DispatchQueue.main.async {
                self?.detailsUploaded?()
            }
        }
    }
    
    func addMovieToFavorites(movie: MovieDetails) {
        FavoritesManager.shared.addMovieToFavorite(movie: movie)
        FavoritesViewModel.shared.refreshTab()
    }
    
    func removeMovieFromFavorites(movie: MovieDetails) {
        FavoritesManager.shared.removeMovieFromFavorites(movie: movie)
        FavoritesViewModel.shared.refreshTab()
    }
    
    func isFavorite(movie: MovieDetails) -> Bool {
        FavoritesManager.shared.isFavoriteMovie(movie: movie)
    }
    
    func toggleFavoriteMovie(movie: MovieDetails) -> Bool {
        if FavoritesManager.shared.isFavoriteMovie(movie: movie) {
            removeMovieFromFavorites(movie: movie)
            return false
        } else {
            addMovieToFavorites(movie: movie)
            return true
        }
    }
}
