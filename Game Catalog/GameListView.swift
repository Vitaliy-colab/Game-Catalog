import SwiftUI

struct GameListView: View {
    @StateObject private var vm = GameListViewModel()
    @EnvironmentObject var favorites: FavoritesStore
    @State private var showFilters = false
    @State private var useGrid = true  // ✅ режим показу: Grid або List

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [.black, .indigo.opacity(0.25)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 10) {
                    SearchBar(debounced: vm.search)
                        .padding(.horizontal)

                    if useGrid {
                        GameGridView(vm: vm)
                    } else {
                        List {
                            ForEach(vm.games, id: \.id) { game in
                                NavigationLink(value: game.id) {
                                    GameRowView(game: game)
                                }
                                .task {
                                    await vm.loadMoreIfNeeded(current: game)
                                }
                            }
                            if vm.isLoading {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                    Spacer()
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Game Catalog")
            .navigationDestination(for: Int.self) {
                GameDetailsView(gameID: $0)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        useGrid.toggle()
                    } label: {
                        Image(
                            systemName: useGrid
                                ? "list.bullet" : "square.grid.2x2"
                        )
                    }
                    Button {
                        showFilters = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showFilters) { FilterSheet(vm: vm) }
            .task { await vm.refresh() }
            // 🔁 коли фільтри змінюються — робимо перезапит
            .onChange(of: vm.ordering) { _ in Task { await vm.refresh() } }
            .onChange(of: vm.yearRange) { _ in Task { await vm.refresh() } }
            .onChange(of: vm.metacriticRange) { _ in Task { await vm.refresh() }
            }
            .onChange(of: vm.selectedGenreIDs) { _ in
                Task { await vm.refresh() }
            }
            .onChange(of: vm.selectedPlatformIDs) { _ in
                Task { await vm.refresh() }
            }
        }
    }
}
