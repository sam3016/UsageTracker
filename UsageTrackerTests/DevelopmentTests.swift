//
//  DevelopmentTests.swift
//  UsageTrackerTests
//
//  Created by Sam Hui on 2023/07/22.
//

import CoreData
import XCTest
@testable import UsageTracker

final class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() {
        dataController.createSampleData()

        XCTAssertEqual(dataController.count(
            for: UsageCategory.fetchRequest()),
            5,
            "There should be 5 sample categories."
        )
        XCTAssertEqual(dataController.count(for: Usage.fetchRequest()), 50, "There should be 50 sample usages.")
    }

    func testDeleteAllClearsEverything() {
        dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(
            for: UsageCategory.fetchRequest()),
            0,
            "deleteAll() should leave 0 sample categories."
        )
        XCTAssertEqual(dataController.count(for: Usage.fetchRequest()), 0, "deleteAll() should leave 0 sample usages.")
    }

    func testExampleCategoryHasNoUsage() {
        let category = UsageCategory.example
        XCTAssertEqual(category.categoryUsages.count, 0, "The exmaple category should have 0 usages.")
    }

    func testExampleCategoryHasZeroAverageAmount() {
        let category = UsageCategory.example
        XCTAssertEqual(category.averageAmount, 0, "The example category has 0 average amount.")
    }

    func testExampleCategoryHasZeroAveragePrice() {
        let category = UsageCategory.example
        XCTAssertEqual(category.averagePrice, 0, "The example category has 0 average price.")
    }

    func testExampleUsageHasHundredAverageAmount() {
        let usage = Usage.example
        XCTAssertEqual(usage.usageAmount, 100, "The example usage has 100 average amount.")
    }

    func testExampleUsageHasThousandAveragePrice() {
        let usage = Usage.example
        XCTAssertEqual(usage.usagePrice, 1000, "The example usage has 1000 average price.")
    }
}
