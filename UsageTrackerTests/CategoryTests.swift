//
//  CategoryTests.swift
//  UsageTrackerTests
//
//  Created by Sam Hui on 2023/07/17.
//

import CoreData
import XCTest
@testable import UsageTracker

final class CategoryTests: BaseTestCase {
    func testCreatingCategoryAndUsages() {
        let count = 10

        for _ in 0..<count {
            let category = UsageCategory(context: managedObjectContext)

            for _ in 0..<count {
                let usage = Usage(context: managedObjectContext)
                category.addToUsages(usage)
            }
        }

        XCTAssertEqual(dataController.count(
            for: UsageCategory.fetchRequest()),
            count,
            "Expected \(count) categories."
        )
        XCTAssertEqual(dataController.count(
            for: Usage.fetchRequest()),
            count * count,
            "Expected \(count * count) usages."
        )
    }

    func testDeletingCategoryDeleteUsage() throws {
        dataController.createSampleData()

        let request = NSFetchRequest<UsageCategory>(entityName: "UsageCategory")
        let categories = try managedObjectContext.fetch(request)

        dataController.delete(categories[0])

        XCTAssertEqual(dataController.count(
            for: UsageCategory.fetchRequest()),
            4,
            "There should be 4 categories after deleting 1 from our sample data."
        )
        XCTAssertEqual(dataController.count(
            for: Usage.fetchRequest()),
            40,
            "There should still be 40 usages after deleting a tag from our sample data."
        )
    }
}
