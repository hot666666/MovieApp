//
//  ContentView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/8/24.
//

import SwiftUI

struct MoviesHomeView: View {
    @EnvironmentObject private var container: DIContainer
    @StateObject var vm: MoviesHomeViewModel
    
    var body: some View {
        NavigationStack(path: $container.navigationRouter.destinations) {
            VStack(spacing: 0){
                HeaderView(title: "Movies")
                
                SearchBarView(text: $vm.searchText, isFocused: $vm.isSearchBarFocused, onSearchButtonClicked: vm.onSearchButtonClicked)
                
                if vm.isSearchBarFocused {
                    MoviesQueryListView(vm: .init(container: container), action: vm.onRecentQueryItemClicked)
                } else {
                    MoviesHomeListView(vm: vm)
                }
            }
            .navigationDestination(for: NavigationDestination.self){ dest in
                switch dest {
                case let .detail(movie):
                    MoviesDetailView(movie: movie)
                }
            }
        }
    }
}

#Preview("MoviesHomeView") {
    let container: DIContainer = .init()
    
    return MoviesHomeView(vm: .init(container: container))
        .environmentObject(container)
}
