//
//  NavigationDestination.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/8/24.
//

import Foundation

enum NavigationDestination: Hashable {
    case detail(movie: Movie, url: URL?)
}
