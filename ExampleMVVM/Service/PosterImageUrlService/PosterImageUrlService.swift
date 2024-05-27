//
//  PosterImageUrlService.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/27/24.
//

import Foundation

protocol PosterImageUrlService {
    func getFullURL(posterUrl: String?, width: Int) -> URL?
}
