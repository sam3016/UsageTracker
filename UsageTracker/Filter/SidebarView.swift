//
//  SidebarView.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilter: [Filter] = [.recent]
    let units = ["m³", "kwh"]

    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var categories: FetchedResults<UsageCategory>

    @State private var categoryToRename: UsageCategory?
    @State private var renamingCategory = false
    @State private var categoryName = ""

    @State private var categoryToSelection: UsageCategory?
    @State private var selectUnit = false
    @State private var categoryUnit = ""

    var categoryFilters: [Filter] {
        categories.map { category in
            Filter(
                id: category.categoryID,
                name: category.categoryName,
                icon: "tag",
                category: category,
                averageAmount: Int(category.averageAmount),
                averagePrice: Int(category.averagePrice),
                unit: category.categoryUnit
            )
        }
    }

    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilter) { filter in
                    SmartFilterRow(filter: filter)
                }
            }

            Section("Category") {
                ForEach(categoryFilters) { filter in
                    CategoryFilterRow(
                        filter: filter,
                        rename: rename,
                        unitSelection: unitSelection
                    )
                }
                .onDelete(perform: delete)
            }
        }
        .toolbar {
            Button(action: dataController.newCategory) {
                Label("Add Category", systemImage: "plus")
            }

            #if DEBUG
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("ADD SAMPLES", systemImage: "flame")
            }
            #endif
        }
        .alert("Rename Category", isPresented: $renamingCategory) {
            Button("OK", action: completeRename)
            Button("Cancel", role: .cancel) { }
            TextField("New name", text: $categoryName)
        }
        .alert("Select Unit", isPresented: $selectUnit) {
            Button("Cancel", role: .cancel) { }
            Button("m³") {
                categoryUnit = "m³"
                completeSelection()
            }
            Button("kwh") {
                categoryUnit = "kwh"
                completeSelection()
            }
        }
    }

    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let category = categories[offset]
            dataController.delete(category)
        }
    }

    func rename(_ filter: Filter) {
        categoryToRename = filter.category
        categoryName = filter.name
        renamingCategory = true
    }

    func completeRename() {
        categoryToRename?.name = categoryName
        dataController.save()
    }

    func unitSelection(_ filter: Filter) {
        categoryToSelection = filter.category
        categoryUnit = filter.unit
        selectUnit = true
    }

    func completeSelection() {
        categoryToSelection?.unit = categoryUnit
        dataController.save()
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
