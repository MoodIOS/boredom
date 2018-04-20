//
//  Movie.swift
//  boredom
//
//  Created by Melissa Phuong Nguyen on 4/20/18.
//  Copyright © 2018 Melissa Phuong Nguyen. All rights reserved.
//

import Foundation

class Movie {
    var title: String
    var posterUrl: URL?
    var overview: String
    var backDropUrl: URL?
    var releaseDate: String
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        overview = dictionary["overview"] as? String ?? "No overview"
        
        let posterPathString = dictionary["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let backdropPathString = dictionary["backdrop_path"] as! String
        posterUrl = URL(string: baseURLString + posterPathString)!
        backDropUrl = URL(string: baseURLString + backdropPathString)!
        releaseDate = dictionary["release_date"] as! String
        
    }
    
    func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
    
}
