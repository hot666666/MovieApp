//
//  MovieQueriesListView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import SwiftUI

struct MoviesQueryListView: View {
    @StateObject var vm: MoviesQueryListViewModel
    var action: (String) -> Void
    
    var body: some View {
        VStack{
            List(vm.queries, id:\.self){ item in
                HStack{
                    Button(action: {
                        action(item.query)
                    }, label: {
                        Text(item.query)
                            .foregroundColor(.primary)
                    })

                    Spacer()
                    
                    Button(action: {
                        Task {
                            await vm.remove(query: item)
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    })
                    .buttonStyle(PlainButtonStyle())  /// List의 요소로 터치정책 무효화
                }
            }
            .overlay {
                if vm.isLoading {
                    LoadingView()
                }
            }
        }
        .task{
            await vm.fetch()
        }
    }
}

#Preview {
    let container: DIContainer = .stub
    
    return MoviesQueryListView(vm: .init(container: container), action: { _ in } )
}
