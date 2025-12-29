//
//  MainMoviesManager.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation
import UIKit

final class MoviesNetworkManager {
    
    static let shared = MoviesNetworkManager()
    private init() {}
    
    func getMovies(searchedName: String, completion: @escaping ([Movie]) -> Void) {
        
        print("get movies called")
        
        let url = MovieNetworkAPI.getSearchUrl(searchedName: searchedName)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error)
                return
            }
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else { return }
            
            
            do {
                let decodedMovie = try JSONDecoder().decode(SearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedMovie.search)
                }
            } catch {
                print("decode error \(error)")
            }
        }.resume()
    }
    
    func getDetails(imdbID: String, completion: @escaping (MovieDetails) -> Void) {
        let url = MovieNetworkAPI.getDetailsUrl(imdbID: imdbID)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error)
                return
            }
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else { return }
            
            
            do {
                let decodedDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedDetails)
                    print("completed")
                }
            } catch {
                print("decode error\(error)")
            }
        }.resume()
    }
    
    func loadPosterImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}
