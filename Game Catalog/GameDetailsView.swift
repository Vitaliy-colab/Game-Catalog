//
//  GameDetailsView.swift
//  Game Catalog
//
//  Created by mac on 05.11.2025.
//

import SwiftUI

struct GameDetailsView: View {
    let gameID: Int
    @StateObject private var vm = GameDetailsViewModel()
    @EnvironmentObject var favorites: FavoritesStore

    @State private var saveError: String? = nil
    @State private var showSavedAlert = false

    var body: some View {
        ScrollView {
            if let g = vm.details {
                VStack(spacing: 0) {
                    // 📌 Верхнє зображення (не виходить за екран)
                    if let url = g.background_image {
                        RemoteImage(url: url)
                            .scaledToFill()
                            .frame(height: 260)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .overlay(
                                LinearGradient(
                                    colors: [.clear, .black.opacity(0.8)],
                                    startPoint: .center,
                                    endPoint: .bottom
                                )
                            )
                            .ignoresSafeArea(edges: .top)
                    }

                    // 📌 Текстовий контент
                    VStack(alignment: .leading, spacing: 16) {
                        Text(g.name)
                            .font(.title).bold()

                        HStack(spacing: 12) {
                            if let rating = g.rating {
                                Label(
                                    String(format: "%.1f", rating),
                                    systemImage: "star.fill"
                                )
                                .foregroundColor(.yellow)
                            }
                            if let mc = g.metacritic {
                                Text("MC \(mc)")
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Color.green.opacity(0.8),
                                        in: Capsule()
                                    )
                            }
                            if let date = g.released {
                                Text(date).foregroundStyle(.secondary)
                            }
                        }

                        if !g.description_raw.isEmpty {
                            Text(g.description_raw)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }

                        // ⭐ Кнопка додати в улюблені
                        Button {
                            favorites.toggle(g.id)
                        } label: {
                            Label(
                                favorites.isFavorite(g.id)
                                    ? "У вибраному" : "Додати в улюблені",
                                systemImage: favorites.isFavorite(g.id)
                                    ? "star.fill" : "star"
                            )
                        }
                        .buttonStyle(.borderedProminent)

                        // 🎮 Платформи (через WrapChips)
                        if let platforms = g.platforms?.map({ $0.platform.name }
                        ), !platforms.isEmpty {
                            WrapChips(items: platforms)
                        }

                        // 💾 Кнопка зберегти постер
                        if let url = g.background_image {
                            Button {
                                Task { await saveImage(url) }
                            } label: {
                                Label(
                                    "Зберегти постер у Фото",
                                    systemImage: "square.and.arrow.down"
                                )
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            } else if vm.isLoading {
                ProgressView().padding()
            } else if let err = vm.errorText {
                Text(err).foregroundStyle(.red).padding()
            }
        }
        .background(Color.black)
        .navigationTitle("Деталі гри")
        .task { await vm.load(id: gameID) }
        .alert(
            "Помилка збереження",
            isPresented: Binding(
                get: { saveError != nil },
                set: { _ in saveError = nil }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(saveError ?? "")
        }
        .alert("Збережено!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) {}
        }
    }

    // ✅ Збереження постера у Фото
    private func saveImage(_ url: URL) async {
        do {
            try await ImageSaver.ensureAuthorization()
            try await ImageSaver.saveImage(from: url)
            showSavedAlert = true
        } catch {
            saveError = error.localizedDescription
        }
    }
}
