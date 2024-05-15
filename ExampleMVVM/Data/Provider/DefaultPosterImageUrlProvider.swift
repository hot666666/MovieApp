//
//  PosterImagesUrlProvider.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/13/24.
//

import Foundation

protocol PosterImageUrlProvider {
    func getURL(posterURL: String, width: Int) throws -> URL
}

final class DefaultPosterImageUrlProvider {
    private let networkConfigurable: NetworkConfigurable
    
    init(networkConfigurable: NetworkConfigurable) {
        self.networkConfigurable = networkConfigurable
    }
}

extension DefaultPosterImageUrlProvider: PosterImageUrlProvider {
    func getURL(posterURL: String, width: Int) throws -> URL {
        let endpoint = APIEndpoints.getMoviePoster(path: posterURL, width: width)
        return try endpoint.url(with: networkConfigurable)
    }
}
