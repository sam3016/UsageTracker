//
//  ContentView.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        List(selection: $dataController.selectedUsage) {
            ForEach(dataController.usageForSelectedFilter()) { usage in
                UsageRow(usage: usage)
            }
            .onDelete(perform: delete)
        }
        .navigationTitle((dataController.selectedFilter == .recent
                          ? NSLocalizedString("Recent Usages", comment: "Recent Usages")
                          : dataController.selectedUsage?.usageCategoryList)
                         ?? NSLocalizedString("Recent Usages", comment: "Recent Usages")
        )
        .searchable(text: $dataController.filterText, prompt: "Filter Usages")
        .toolbar {
            ContentViewToolbar()
        }
    }

    func delete(_ offsets: IndexSet) {
        let usages = dataController.usageForSelectedFilter()

        for offset in offsets {
            let item = usages[offset]
            dataController.delete(item)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
