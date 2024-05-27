//
//  MovieRequestDTO+Mapping.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

struct MoviesRequestDTO: Encodable {
    let query: String
    let page: Int
}
