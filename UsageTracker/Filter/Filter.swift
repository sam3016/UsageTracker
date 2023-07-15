//
//  Filter.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import Foundation

struct Filter: Identifiable, Hashable {
    var id: UUID
    var name: String
    var icon: String
    var minModificationDate = Date.distantPast
    var category: Category?
    var averageAmount: Int
    var averagePrice: Int
    var unit: String

    static var recent = Filter(
        id: UUID(),
        name: NSLocalizedString("Recent Usages", comment: "Recent Usages"),
        icon: "clock",
        minModificationDate: .now.addingTimeInterval(86400 * -7),
        averageAmount: 0,
        averagePrice: 0,
        unit: "NA"
    )

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func ==(lhs: Filter, rhs: Filter) -> Bool {
        lhs.id == rhs.id
    }
}
