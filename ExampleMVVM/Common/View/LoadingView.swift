//
//  LoadingView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/12/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack{
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .scaleEffect(2.0)
        }
    }
}
 
#Preview {
    LoadingView()
}
