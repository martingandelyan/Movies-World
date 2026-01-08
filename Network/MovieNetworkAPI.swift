//
//  MovieNetworkApi.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 27.12.25.
//

import Foundation

enum MovieNetworkAPI {
    
    private static let apiKey: String = "4352a844"
    private static let generalUrl: String = "https://www.omdbapi.com/"
    
    static func getSearchUrl(searchedName: String) -> URL {
        
        guard var components = URLComponents(string: generalUrl) else { fatalError("Invalid URL") }
        components.queryItems = [
            URLQueryItem(name: "apikey", value: apiKey),
            URLQueryItem(name: "s", value: searchedName)
        ]
        
        guard let modifiedURL = components.url else { fatalError("Invalid URL") }
        return modifiedURL
    }
    
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
