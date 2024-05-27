//
//  DefaultMoviesRepository.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation

final class DefaultMoviesRepository {

    private let dataTransferService: DataTransferService
    private let cache: MoviesResponseStorage

    init(
        dataTransferService: DataTransferService,
        cache: MoviesResponseStorage
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
    }
}

extension DefaultMoviesRepository: MoviesRepository {
    func fetchMoviesList(query: MovieQuery, page: Int) async throws -> MoviesPage {
        let requestDTO = MoviesRequestDTO(query: query.query, page: page)
        
        do {
            if let responseDTO = try await cache.getResponse(for: requestDTO){
                return responseDTO.toDomain()
            }
            
            let endpoint = APIEndpoints.getMovies(with: requestDTO)
            
            let responseDTO = try await dataTransferService.request(with: endpoint)
            try await cache.save(response: responseDTO, for: requestDTO)
            return responseDTO.toDomain()
        } catch {
            throw error
        }
    }
}
