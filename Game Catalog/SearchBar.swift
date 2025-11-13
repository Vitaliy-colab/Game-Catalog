//
//  SearchBar.swift
//  Game Catalog
//
//  Created by mac on 05.11.2025.
//

import SwiftUI

struct SearchBar: View {
    @ObservedObject var debounced: DebouncedText

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Пошук ігор (як у Steam)", text: $debounced.text)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            if !debounced.text.isEmpty {
                Button(action: { debounced.text = "" }) {
                    Image(systemName: "xmark.circle.fill").foregroundStyle(
                        .secondary
                    )
                }
            }
        }
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .shadow(radius: 6)
    }
}
