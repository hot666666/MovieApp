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
            MoviesHomeView(moviesHomeVM: .init(container: container), movieQueriesListVM: .init(container: container))
        }
        .environmentObject(container)
    }
}
