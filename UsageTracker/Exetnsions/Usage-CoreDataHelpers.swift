//
//  Usage-CoreDataHelpers.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import Foundation

extension Usage {
    enum SortOrder {
        case startDate, endDate, dayDifference
    }

    var usageStartDate: Date {
        get { startDate ?? Date() }
        set { startDate = newValue }
    }

    var usageEndDate: Date {
        get { endDate ?? Date() }
        set { endDate = newValue }
    }

    var usageCreationDate: Date {
        creationDate ?? .now
    }

    var usageAmount: Double {
        get { amount }
        set { amount = newValue }
    }

    var usagePrice: Double {
        get { price }
        set { price = newValue }
    }

    var usagesCategory: [UsageCategory] {
        let result = category?.allObjects as? [UsageCategory] ?? []
        return result.sorted()
    }

    var usageDateRange: String {
        return "\(usageStartDate.formatted(date: .numeric, time: .omitted)) ~ "
        +  "\(usageEndDate.formatted(date: .numeric, time: .omitted))"
    }

    var usageDateRangeLabel: String {
        return "From \(usageStartDate.formatted(date: .abbreviated, time: .omitted)) to"
        +  "\(usageEndDate.formatted(date: .abbreviated, time: .omitted))"
    }

    var usageCategoryList: String {
        guard let category else { return "No Category"}

        if category.count == 0 {
            return "No Category"
        } else {
            return usagesCategory.map(\.categoryName).formatted()
        }
    }

    static var example: Usage {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let usage = Usage(context: viewContext)
        usage.startDate = Date()
        usage.endDate = Date()
        usage.amount = 100.0
        usage.creationDate = .now
        usage.price = 1000.0

        return usage
    }
}

extension Usage: Comparable {
    public static func <(lhs: Usage, rhs: Usage) -> Bool {
        let left = lhs.usageStartDate
        let right = rhs.usageStartDate

        if left == right {
            return lhs.usageEndDate < rhs.usageEndDate
        } else {
            return left < right
        }
    }
}
