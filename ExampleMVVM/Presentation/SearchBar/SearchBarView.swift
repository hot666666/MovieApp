//
//  SearchBarView.swift
//  ExampleMVVM
//
//  Created by 최하식 on 5/13/24.
//

import SwiftUI
import UIKit

struct SearchBarView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFocused: Bool
    var onSearchButtonClicked: (String) -> Void

    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.barStyle = .black
        searchBar.tintColor = .white
        searchBar.placeholder = "Search"
        searchBar.delegate = context.coordinator
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, isFocused: $isFocused, onSearchButtonClicked: onSearchButtonClicked)
    }

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
        @Binding var isFocused: Bool
        var onSearchButtonClicked: (String) -> Void

        init(text: Binding<String>, isFocused: Binding<Bool>, onSearchButtonClicked: @escaping (String) -> Void) {
            _text = text
            _isFocused = isFocused
            self.onSearchButtonClicked = onSearchButtonClicked
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.isEmpty {  /// x 버튼 터치 시 수행
                isFocused = true
            }
            text = searchText
        }

        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            if !text.isEmpty{
                onSearchButtonClicked(text)
            }
            searchBar.resignFirstResponder()
            isFocused = false
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
            isFocused = false
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
            isFocused = true
        }
    }
}

#Preview {
    @State var text: String = ""
    @State var isFocused: Bool = false
    return SearchBarView(text: $text, isFocused: $isFocused, onSearchButtonClicked: { _ in })
}
