//
//  WrapChips.swift
//  Game Catalog
//
//  Created by mac on 05.11.2025.
//

import SwiftUI

struct WrapChips: View {
    let items: [String]

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(items, id: \.self) {
                Text($0)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial, in: Capsule())
            }
        }
        .padding(.top, 4)
    }
}
