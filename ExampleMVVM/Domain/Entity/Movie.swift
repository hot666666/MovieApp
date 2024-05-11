//
//  Movie.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/8/24.
//

import Foundation

struct Movie: Equatable, Identifiable, Hashable {
    typealias Identifier = String
    
    let id: Identifier
    let title: String?
    let posterPath: String?
    let overview: String?
    let releaseDate: Date?
}

struct MoviesPage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}

extension Movie {
    static func stub(id: Movie.Identifier = "id1",
                     title: String = "title1",
                     posterPath: String? = "/1",
                     overview: String = "overview1",
                     releaseDate: Date? = Date.now) -> Self {
        Movie(id: id,
              title: title,
              posterPath: posterPath,
              overview: overview,
              releaseDate: releaseDate)
    }
}
