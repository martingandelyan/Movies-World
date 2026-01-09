//
//  MainMoviesManager.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import Foundation

final class MoviesNetworkManager {
    
    static let shared = MoviesNetworkManager()
    private init() {}
    
    //MARK: - Get searched movie
    func getMovies(searchedName: String, page: Int, completion: @escaping ([Movie]?, Int) -> Void) {
        
        print("get movies called")
        
        let url = MovieNetworkAPI.getSearchUrl(searchedName: searchedName, page: page)
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                print(error)
                return
            }
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            guard response.statusCode == 200 else { return }
            print("Response:", response)
            
            do {
                let decodedMovie = try JSONDecoder().decode(SearchResponse.self, from: data)
                let movies = decodedMovie.search
                let totalResult = Int(decodedMovie.totalResults)
                DispatchQueue.main.async {
                    completion(movies, totalResult ?? 0)
                    print("movies decoded")
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, 0)
                    print("decode error \(error)")
                }
            }
        }.resume()
    }
    
    //MARK: - Networking for getting details of the specific movie
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
            print("Response:", response)
            
            
            do {
                let decodedDetails = try JSONDecoder().decode(MovieDetails.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedDetails)
                    print("completed")
                }
            } catch {
                DispatchQueue.main.async {
                    print("decode error\(error)")
                }
            }
        }.resume()
    }
}
