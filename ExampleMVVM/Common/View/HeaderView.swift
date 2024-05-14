//
//  HeaderView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/14/24.
//

import SwiftUI

struct HeaderView: View {
    var title: String?
    var buttonAction: DismissAction? = nil
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text(title ?? "")
                    .bold()
                    .foregroundColor(ColorTheme.headerText)
                Spacer()
            }
        }
        .overlay(alignment: .leading) {
            if let action = buttonAction {
                Button(action: {
                    action()
                }) {
                    Image(systemName: "chevron.left")
                }
                .padding()
            }
        }
        .padding(.bottom)
        .background(ColorTheme.headerBackground)
        .bold()
    }
}

#Preview {
    HeaderView(title: "Movies")
}
