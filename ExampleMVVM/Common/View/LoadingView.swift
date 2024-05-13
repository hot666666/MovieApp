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
            Color.white.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
        }
    }
}
 

#Preview {
    LoadingView()
}
