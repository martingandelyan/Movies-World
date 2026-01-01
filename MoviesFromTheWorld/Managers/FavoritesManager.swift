//
//  FavoritesManager.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

final class FavoritesManager {
    
    static let shared = FavoritesManager()
    private init() {
        threadSafeQueue.sync {
            loadFavoritesFromStorage()
        }
    }
    private(set) var favoriteMovies: [MovieDetails] = [] {
        didSet {
            saveFavoritesToStorage()
        }
    }
    
    private let threadSafeQueue = DispatchQueue(label: "com.martin.tabbarcontroller.favorites.queue")
    
    func isFavoriteMovie(movie: MovieDetails) -> Bool {
        threadSafeQueue.sync {
            favoriteMovies.contains(where: { $0.imdbID == movie.imdbID } )
        }
    }
    
    func addMovieToFavorite(movie: MovieDetails) {
        threadSafeQueue.async {
            if self.favoriteMovies.isEmpty || !self.favoriteMovies.contains(where: {
                $0.imdbID == movie.imdbID } ) {
                self.favoriteMovies.append(movie)
            }
        }
    }
    
    func removeMovieFromFavorites(movie: MovieDetails) {
        threadSafeQueue.async {
            self.favoriteMovies.removeAll(where: { $0.imdbID == movie.imdbID } )
        }
    }
    
    private func saveFavoritesToStorage() {
        guard let dataForSave = try? JSONEncoder().encode(favoriteMovies) else { return }
        UserDefaults.standard.set(dataForSave, forKey: UserDefaultKeys.favoriteMovies.rawValue)
    }
    
    private func loadFavoritesFromStorage() {
        guard let dataToLoad = UserDefaults.standard.data(forKey: UserDefaultKeys.favoriteMovies.rawValue),
              let loadedMovies = try? JSONDecoder().decode([MovieDetails].self, from: dataToLoad)
        else { return }
        
        favoriteMovies = loadedMovies
    }
    
    func toggleFavoriteMovie(movie: MovieDetails) -> Bool {
        if isFavoriteMovie(movie: movie) {
            removeMovieFromFavorites(movie: movie)
            return false
        } else {
            addMovieToFavorite(movie: movie)
            return true
        }
    }
}
