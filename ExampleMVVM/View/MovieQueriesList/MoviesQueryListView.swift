//
//  MovieQueriesListView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import SwiftUI

struct MoviesQueryListView: View {
    @ObservedObject var movieQueriesVM: MoviesQueryListViewModel
    @ObservedObject var movieListVM: MoviesHomeViewModel
    var defocus: () -> Void
    
    var body: some View {
        VStack{
            List(movieQueriesVM.queries, id:\.self){ item in
                Button(action: {
                    Task{
                        await movieListVM.search(selectedQuery: item.query)
                        defocus()
                    }
                }, label: {
                    Text(item.query)
                })
                
            }
            .overlay {
                if movieQueriesVM.isLoading {
                    LoadingView()
                }
            }
        }
        .task{
            await movieQueriesVM.fetch()
        }
    }
}

#Preview {
    let container: DIContainer = .stub
    
    return MoviesQueryListView(movieQueriesVM: .init(container: container),
                               movieListVM: .init(container: container),
                               defocus: { })
}
