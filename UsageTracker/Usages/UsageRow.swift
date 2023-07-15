//
//  UsageRow.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import SwiftUI

struct UsageRow: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var usage: Usage

    var body: some View {
        NavigationLink(value: usage) {
            VStack(alignment: .leading) {
                if dataController.selectedFilter == .recent {
                    Text(usage.usagesCategory.first?.categoryName ?? "Unknown")
                }

                HStack(alignment: .top) {
                    Text(usage.usageDateRange)
                }

                HStack(spacing: 0) {
                    Text("Amount: \(Int(usage.usageAmount))")
                    Text(usage.usagesCategory.first?.categoryUnit ?? "Unknown")
                }
                .font(.caption2)
                .foregroundColor(.secondary)

                Text("Price: \(usage.usagePrice.formatted(.currency(code: "JPY")))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .navigationTitle(
                dataController.selectedFilter == .recent
                ? NSLocalizedString("Recent Usages", comment: "Recent Usages")
                : usage.usageCategoryList)
        }
        .accessibilityElement()
        .accessibilityLabel(usage.usagesCategory.first?.categoryName ?? "Unknown")
        .accessibilityHint(usage.usageDateRangeLabel)
        .accessibilityInputLabels([usage.usagesCategory.first?.categoryName ?? "Unknown", usage.usageDateRangeLabel])
    }
}

struct UsageRow_Previews: PreviewProvider {
    static var previews: some View {
        UsageRow(usage: .example)
    }
}
