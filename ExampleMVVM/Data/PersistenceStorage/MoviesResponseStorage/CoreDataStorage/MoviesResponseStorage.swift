//
//  MoviesResponseStorage.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

protocol MoviesResponseStorage {
    func getResponse(for request: MoviesRequestDTO) async throws -> MoviesResponseDTO?
    
    func save(response: MoviesResponseDTO, for requestDto: MoviesRequestDTO) async throws
}
