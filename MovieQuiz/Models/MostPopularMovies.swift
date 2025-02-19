//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Pavel Seleznev on 11/28/24.
//

import Foundation

/// Movie struct for displaying network error message and array of movie items
struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

/// Movie struct containing movie title, rating, IMDB's poster URL. resizedImageURL for loading high resolution poster images
struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        let urlString = imageURL.absoluteString
        let imageUrlString = urlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newURL = URL(string: imageUrlString) else {
            return imageURL
        }
        
        return newURL
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
