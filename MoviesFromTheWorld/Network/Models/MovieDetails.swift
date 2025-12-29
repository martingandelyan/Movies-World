//
//  Untitled.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 27.12.25.
//

struct MovieDetails: Decodable {
    
    let title: String
    let year: String
    let plot: String
    let genre: String
    let runtime: String
    let poster: String

    enum CodingKeys: String, CodingKey {
        
        case title = "Title"
        case year = "Year"
        case plot = "Plot"
        case genre = "Genre"
        case runtime = "Runtime"
        case poster = "Poster"
    }
}
