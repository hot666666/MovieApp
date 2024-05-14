//
//  ImageView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/14/24.
//

import SwiftUI

struct ImageView: View {
    var url: URL?
    var alignment: Alignment = .center
    
    var body: some View {
        VStack{
            AsyncImage(url: url) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            }
        }
    }
}

#Preview {
    ImageView()
}
