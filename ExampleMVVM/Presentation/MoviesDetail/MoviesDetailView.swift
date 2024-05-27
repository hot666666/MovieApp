//
//  MovieDetailView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/14/24.
//

import SwiftUI

struct MoviesDetailView: View {
    @EnvironmentObject var container: DIContainer

    var movie: Movie
    
    var body: some View {
        VStack(spacing: 0){
            HeaderView(title: movie.title ?? "", buttonAction: container.navigationRouter.pop)
            
            VStack{
                ImageView(url: getFullUrl(for: movie.posterPath))
                    .frame(width: Screen.detailWidth, height: Screen.detailHeight, alignment: .top)
                Text(movie.overview ?? "")
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(.horizontal, 10)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func getFullUrl(for posterUrl: String?) -> URL? {
        container.posterImageUrlService.getFullURL(posterUrl: movie.posterPath, width: Int(Screen.detailWidth))
    }
}

#Preview {
    let movie: Movie = .stub()
    let container: DIContainer = .init()
    
    return NavigationView{
        MoviesDetailView(movie: movie)
            .environmentObject(container)
    }
}
