//
//  Category-CoreDataHelpers.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import Foundation

extension Category {
    var categoryID: UUID {
        id ?? UUID()
    }

    var categoryName: String {
        get { name ?? "" }
        set { name = newValue }
    }

    var categoryCreationDate: Date {
        creationDate ?? .now
    }

    var categoryAverageAmount: Double {
        get { averageAmount }
        set { averageAmount = newValue }
    }

    var categoryAveragePrice: Double {
        get { averagePrice }
        set { averagePrice = newValue }
    }

    var categoryUnit: String {
        get { unit ?? "" }
        set { unit = newValue }
    }

    var categoryUsages: [Usage] {
        let array = usages?.allObjects as? [Usage] ?? []
        return array.sorted()
    }

    static var example: Category {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext

        let category = Category(context: viewContext)
        category.id = UUID()
        category.name = "Example Category"
        category.creationDate = .now
        category.averageAmount = 0.0
        category.averagePrice = 0.0

        return category
    }
}

extension Category: Comparable {
    public static func <(lhs: Category, rhs: Category) -> Bool {
        let left = lhs.categoryCreationDate
        let right = rhs.categoryCreationDate

        if left == right {
            return lhs.categoryID.uuidString < rhs.categoryID.uuidString
        } else {
            return left < right
        }
    }
}
