//
//  ExampleMVVMApp.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/8/24.
//

import SwiftUI

@main
struct ExampleMVVMApp: App {
    @StateObject var container: DIContainer = .init()
    
    var body: some Scene {
        WindowGroup {
            MoviesListView(container: container)
        }
        .environmentObject(container)
    }
}
