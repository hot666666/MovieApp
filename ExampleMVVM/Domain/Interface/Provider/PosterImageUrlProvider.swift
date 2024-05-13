//
//  PosterImageUrlProvider.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/13/24.
//

import Foundation

protocol PosterImageUrlProvider {
    func getURL(posterURL: String, width: Int) throws -> URL
}
