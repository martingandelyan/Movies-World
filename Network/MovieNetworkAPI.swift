//
//  MovieNetworkApi.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 27.12.25.
//

import Foundation

enum MovieNetworkAPI {
    
    private static let apiKey: String = "fd67c604"
    private static let generalUrl: String = "https://www.omdbapi.com/"
    
    //MARK: - Get searched movie URL
    static func getSearchUrl(searchedName: String, page: Int) -> URL {
        
        guard var components = URLComponents(string: generalUrl) else { fatalError("Invalid URL") }
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "s", value: searchedName),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        
        guard let modifiedURL = components.url else { fatalError("Invalid URL") }
        
        return modifiedURL
    }
    
    //MARK: - Get details page of specific movie URL
    static func getDetailsUrl(imdbID: String) -> URL {
        
        guard var components = URLComponents(string: generalUrl) else { fatalError("Invalid URL") }
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "i", value: imdbID)
        ]
        
        guard let detailsURL = components.url else { fatalError("Invalid URL") }
        
        return detailsURL
    }
}
