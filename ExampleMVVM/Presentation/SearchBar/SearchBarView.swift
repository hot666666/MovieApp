//
//  SearchBarView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/13/24.
//

import SwiftUI


struct SearchBarView: View {
    @ObservedObject var moviesListVM: MoviesHomeViewModel
    var defocus: () -> Void
    
    var body: some View {
        HStack{
            TextField("", text: $moviesListVM.text)
                .padding(10)
                .background(Color.black.opacity(0.9))
                .cornerRadius(5)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .overlay(alignment: .leading) {
                    if moviesListVM.text.isEmpty {
                        Text("Search Movies")
                            .offset(x: 10)
                            .allowsHitTesting(false)
                    }
                }
                .overlay(alignment: .trailing) {
                    if moviesListVM.isFocusedSearchBar && !moviesListVM.text.isEmpty {
                        Button {
                            moviesListVM.text = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .offset(x: -5)
                    }
                }
            
            if moviesListVM.isFocusedSearchBar{
                Button(action: {
                    withAnimation{
                        moviesListVM.isFocusedSearchBar = false
                    }
                    defocus()
                }, label: {
                    Text("Cancel")
                })
                .foregroundColor(.blue)
            }
        }
        .padding(10)
        .foregroundColor(Color.white.opacity(0.6))
        .background(Color.black.opacity(0.7))
    }
}



