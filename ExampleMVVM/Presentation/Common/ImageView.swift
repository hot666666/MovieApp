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
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } else if phase.error != nil {  /// Indicates an error
                Image(systemName: "photo")
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            }
        }
    }
}

#Preview {
    ImageView()
}
