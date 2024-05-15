//
//  MovieDetailsVIew.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/14/24.
//

import SwiftUI

struct MoviesDetailsView: View {
    @Environment(\.dismiss) var dismiss

    var movie: Movie
    var url: URL?
    
    init(movie: Movie, url: URL?) {
        self.movie = movie
        self.url = url
    }
    
    var body: some View {
        VStack(spacing: 0){
            HeaderView(title: movie.title, buttonAction: dismiss)
            VStack{
                ImageView(url: url)
                    .frame(width: Screen.detailWidth, height: Screen.detailHeight, alignment: .top)
                Text(movie.overview ?? "")
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
    }
 
}

#Preview {
    let movie: Movie = .stub()
    let container: DIContainer = .init()
    let provider = container.posterImageUrlProvider
    let url = try? provider.getURL(posterURL: movie.posterPath!, width: 200)
    
    return NavigationView{
        MoviesDetailsView(movie: movie, url: url)
    }
}