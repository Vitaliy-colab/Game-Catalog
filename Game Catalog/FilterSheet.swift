//
//  FilterSheet.swift
//  Game Catalog
//
//  Created by mac on 05.11.2025.
//

import SwiftUI

struct FilterSheet: View {
    @ObservedObject var vm: GameListViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var localOrdering: String? = nil
    @State private var localYears: ClosedRange<Int>? = nil
    @State private var localMC: ClosedRange<Int>? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Сортування") {
                    Picker(
                        "Порядок",
                        selection: Binding(
                            get: { localOrdering ?? vm.ordering },
                            set: { localOrdering = $0 }
                        )
                    ) {
                        Text("Метакритик ↓").tag(Optional("-metacritic"))
                        Text("Рейтинг ↓").tag(Optional("-rating"))
                        Text("Нові").tag(Optional("-released"))
                        Text("Назва A→Z").tag(Optional("name"))
                    }
                }

                Section("Роки випуску") {
                    Toggle(
                        "2020–2025",
                        isOn: Binding(
                            get: {
                                (localYears ?? vm.yearRange) == (2020...2025)
                            },
                            set: {
                                $0
                                    ? (localYears = 2020...2025)
                                    : (localYears = nil)
                            }
                        )
                    )
                    Toggle(
                        "2010–2015",
                        isOn: Binding(
                            get: {
                                (localYears ?? vm.yearRange) == (2010...2015)
                            },
                            set: {
                                $0
                                    ? (localYears = 2010...2015)
                                    : (localYears = nil)
                            }
                        )
                    )
                    Toggle(
                        "Очистити",
                        isOn: Binding(
                            get: { (localYears ?? vm.yearRange) == nil },
                            set: { _ in localYears = nil }
                        )
                    )
                }

                Section("Metacritic") {
                    Toggle(
                        "70–100",
                        isOn: Binding(
                            get: { (localMC ?? vm.metacriticRange) != nil },
                            set: { $0 ? (localMC = 70...100) : (localMC = nil) }
                        )
                    )
                }
            }
            .navigationTitle("Фільтри")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Скасувати") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Застосувати") {
                        vm.ordering = localOrdering ?? vm.ordering
                        vm.yearRange = localYears
                        vm.metacriticRange = localMC
                        Task { await vm.refresh() }
                        dismiss()
                    }
                }
            }
            .onAppear {
                localOrdering = vm.ordering
                localYears = vm.yearRange
                localMC = vm.metacriticRange
            }
        }
    }
}
