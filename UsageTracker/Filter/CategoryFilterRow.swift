//
//  UsageFIlterRow.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import SwiftUI

struct CategoryFilterRow: View {
    let filter: Filter
    var rename: (Filter) -> Void
    var unitSelection: (Filter) -> Void

    var body: some View {
        NavigationLink(value: filter) {
            HStack {
                Image(systemName: "chart.pie.fill")
                    .imageScale(.large)
                    .foregroundColor(.blue)

                VStack(alignment: .leading) {
                    Text(filter.name)
                        .contextMenu {
                            Button {
                                rename(filter)
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }

                            Button {
                                unitSelection(filter)
                            } label: {
                                Label("Unit Selection", systemImage: "filemenu.and.selection")
                            }
                        }

                    Text("Average Amount: \(filter.averageAmount) \(filter.unit)")
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    Text("Average Price: \(filter.averagePrice.formatted(.currency(code: "JPY")))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .accessibilityElement()
        .accessibilityLabel(filter.name)
//        .accessibilityHint("Next is" + filter.estimateDate.formatted(date: .abbreviated, time: .omitted)
//        )
//        .accessibilityInputLabels([filter.name, filter.estimateDate.formatted(date: .abbreviated, time: .omitted)])
    }
}

struct CategoryFilterRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryFilterRow(filter: .recent, rename: {_ in }, unitSelection: {_ in })
    }
}
