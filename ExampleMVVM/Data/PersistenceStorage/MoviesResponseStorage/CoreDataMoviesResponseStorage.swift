//
//  CoreDataMoviesResponseStorage.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/10/24.
//

import Foundation
import CoreData

final class CoreDataMoviesResponseStorage {

    private let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }

    // MARK: - Private
    private func fetchRequest(
        for requestDto: MoviesRequestDTO
    ) -> NSFetchRequest<MoviesRequestEntity> {
        let request: NSFetchRequest = MoviesRequestEntity.fetchRequest()
        request.predicate = NSPredicate(format: "%K = %@ AND %K = %d",
                                        #keyPath(MoviesRequestEntity.query), requestDto.query,
                                        #keyPath(MoviesRequestEntity.page), requestDto.page)
        
        request.fetchLimit = 1
        
        return request
    }
    
    private func deleteResponse(
        for requestDto: MoviesRequestDTO,
        in context: NSManagedObjectContext
    ) {
        let request = fetchRequest(for: requestDto)

        do {
            if let result = try context.fetch(request).first {
                context.delete(result)
            }
        } catch {
            print(error)
        }
    }
}

extension CoreDataMoviesResponseStorage: MoviesResponseStorage {
    func getResponse(for requestDto: MoviesRequestDTO) async throws -> MoviesResponseDTO? {
        try await coreDataStorage.performBackgroundTask { context in
            let fetchRequest = self.fetchRequest(for: requestDto)
            return try context.fetch(fetchRequest).first?.response?.toDTO()
        }
    }
    
    func save(response responseDto: MoviesResponseDTO, for requestDto: MoviesRequestDTO) async throws {
        try await coreDataStorage.performBackgroundTask { context in
            self.deleteResponse(for: requestDto, in: context)
            
            let requestEntity = requestDto.toEntity(in: context)
            requestEntity.response = responseDto.toEntity(in: context)
            try context.save()
        }
    }
}
