//
//  File.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/27/24.
//

import Foundation

final class DefaultPosterImageUrlService {
    private let networkConfigurable: NetworkConfigurable
    
    init(networkConfigurable: NetworkConfigurable) {
        self.networkConfigurable = networkConfigurable
    }
}

extension DefaultPosterImageUrlService: PosterImageUrlService {
    func getFullURL(posterUrl: String?, width: Int) -> URL? {
        guard let posterURL = posterUrl else { return nil }
        let endpoint = APIEndpoints.getMoviePosterFullUrl(path: posterURL, width: width)
        return try? endpoint.url(with: networkConfigurable)
    }
}
