//
//  MovieResponseDTO.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

struct MoviesResponseDTO: Decodable {
    /*
     {
        "page": Int,
        "results": [MovieDTO],
        "total_pages": Int
     }
     */
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
}

extension MoviesResponseDTO {
    /*
     {
        "id": Int,
        "title": String?,
        "poster_path": String?,
        "overview": String?,
        "release_date": String?
     }
     */
    struct MovieDTO: Decodable {
        private enum CodingKeys: String, CodingKey {
            case id
            case title
            case posterPath = "poster_path"
            case overview
            case releaseDate = "release_date"
        }
        let id: Int
        let title: String?
        let posterPath: String?
        let overview: String?
        let releaseDate: String?
    }
}


// MARK: - Mappings to Domain
extension MoviesResponseDTO {
    func toDomain() -> MoviesPage {
        return .init(page: page,
                     totalPages: totalPages,
                     movies: movies.map { $0.toDomain() })
    }
}

extension MoviesResponseDTO.MovieDTO {
    func toDomain() -> Movie {
        return .init(id: Movie.Identifier(id),
                     title: title,
                     posterPath: posterPath,
                     overview: overview,
                     releaseDate: releaseDate?.toDate())
    }
}
