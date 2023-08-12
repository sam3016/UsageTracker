//
//  ExtensionTests.swift
//  UsageTrackerTests
//
//  Created by Sam Hui on 2023/08/08.
//

import CoreData
import XCTest
@testable import UsageTracker

final class ExtensionTests: BaseTestCase {
    // Usage
    func testUsageStartDateUnwrap() {
        let usage = Usage(context: managedObjectContext)
        let testDate = Date.now

        usage.startDate = testDate
        XCTAssertEqual(usage.usageStartDate, testDate, "Changing startDate should also change usageStartDate.")

        usage.usageStartDate = testDate.addingTimeInterval(100)
        XCTAssertEqual(
            usage.startDate,
            testDate.addingTimeInterval(100),
            "Changing usageStartDate should also change startDate."
        )
    }

    func testUsageEndDateUnwrap() {
        let usage = Usage(context: managedObjectContext)
        let testDate = Date.now

        usage.endDate = testDate
        XCTAssertEqual(usage.usageEndDate, testDate, "Changing endDate should also change usageEndDate.")

        usage.usageEndDate = testDate.addingTimeInterval(100)
        XCTAssertEqual(
            usage.endDate,
            testDate.addingTimeInterval(100),
            "Changing usageEndDate should also change endDate."
        )
    }

    func testUsageCreationDateUnwrap() {
        // Given
        let usage = Usage(context: managedObjectContext)
        let testDate = Date.now

        // When
        usage.creationDate = testDate

        // Then
        XCTAssertEqual(usage.usageCreationDate, testDate, "Changing creationDate should also change usageCreationDate.")
    }

    func testUsageAmountUnwrap() {
        let usage = Usage(context: managedObjectContext)

        usage.amount = 30.0
        XCTAssertEqual(usage.usageAmount, 30.0, "Changing amount should also change usageAmount.")

        usage.usageAmount = 40.0
        XCTAssertEqual(
            usage.amount,
            40.0,
            "Changing usageAmount should also change amount."
        )
    }

    func testUsagePriceUnwrap() {
        let usage = Usage(context: managedObjectContext)

        usage.price = 30.0
        XCTAssertEqual(usage.usagePrice, 30.0, "Changing price should also change usagePrice.")

        usage.usagePrice = 40.0
        XCTAssertEqual(
            usage.price,
            40.0,
            "Changing usagePrice should also change price."
        )
    }

    func testUsageCategoriesUnwrap() {
        let category = UsageCategory(context: managedObjectContext)
        let usage = Usage(context: managedObjectContext)

        XCTAssertEqual(usage.usagesCategory.count, 0, "A new usage should have no category.")

        usage.addToCategory(category)
        XCTAssertEqual(
            usage.usagesCategory.count,
            1,
            "Adding 1 category to an usage should result in usageCategories having count 1."
        )
    }

    func testUsageCategoryList() {
        let category = UsageCategory(context: managedObjectContext)
        let usage = Usage(context: managedObjectContext)

        category.name = "My Category"
        usage.addToCategory(category)

        XCTAssertEqual(
            usage.usageCategoryList,
            "My Category",
            "Adding 1 category to a usage should make usageCategoryList be My Category."
        )
    }

    func testUsageSortingIsStable() {
        let testDate = Date.now

        let usage1 = Usage(context: managedObjectContext)
        usage1.startDate = testDate
        usage1.endDate = testDate

        let usage2 = Usage(context: managedObjectContext)
        usage2.startDate = testDate
        usage2.endDate = testDate.addingTimeInterval(100)

        let usage3 = Usage(context: managedObjectContext)
        usage3.startDate = testDate.addingTimeInterval(1000)
        usage3.endDate = testDate

        let allUsages = [usage3, usage2, usage1]
        let sorted = allUsages.sorted()

        XCTAssertEqual([usage1, usage2, usage3], sorted, "Sorting usage arrays should use startDate then endDate.")
    }

    // UsageCategory
    func testUsageCategoryIDUnwrap() {
        let category = UsageCategory(context: managedObjectContext)

        category.id = UUID()
        XCTAssertEqual(category.categoryID, category.id, "Changing id should also change categoryID.")
    }

    func testUsageCategoryNameUnwrap() {
        let category = UsageCategory(context: managedObjectContext)

        category.name = "Example Category"
        XCTAssertEqual(category.categoryName, "Example Category", "Changing name should also change categoryName.")
    }

    func testUsageCategoryCreationDateUnwrap() {
        // Given
        let category = UsageCategory(context: managedObjectContext)
        let testDate = Date.now

        // When
        category.creationDate = testDate

        // Then
        XCTAssertEqual(
            category.categoryCreationDate,
            testDate,
            "Changing creationDate should also change categoryCreationDate."
        )
    }

    func testUsageCategoryAverageAmountUnwrap() {
        let category = UsageCategory(context: managedObjectContext)

        category.averageAmount = 30.0
        XCTAssertEqual(
            category.categoryAverageAmount,
            30.0,
            "Changing averageAmount should also change categoryAverageAmount."
        )
    }

    func testUsageCategoryAveragePriceUnwrap() {
        let category = UsageCategory(context: managedObjectContext)

        category.averagePrice = 30.0
        XCTAssertEqual(
            category.categoryAveragePrice,
            30.0,
            "Changing averagePrice should also change categoryAveragePrice."
        )
    }

    func testUsageCategoryUnitUnwrap() {
        let category = UsageCategory(context: managedObjectContext)

        category.unit = "Example Unit"
        XCTAssertEqual(
            category.categoryUnit,
            "Example Unit",
            "Changing unit should also change categoryUnit."
        )
    }

    func testCategoryUsagesUnwrap() {
        let category = UsageCategory(context: managedObjectContext)
        let usage = Usage(context: managedObjectContext)

        XCTAssertEqual(category.categoryUsages.count, 0, "A new category should have no usage.")

        usage.addToCategory(category)
        XCTAssertEqual(
            category.categoryUsages.count,
            1,
            "Adding 1 category to an usage should result in categoryUsages having count 1."
        )
    }

    func testUsageCategorySortingIsStable() {
        let testDate = Date.now
        let category1 = UsageCategory(context: managedObjectContext)
        category1.creationDate = testDate
        category1.id = UUID()

        let category2 = UsageCategory(context: managedObjectContext)
        category2.creationDate = testDate
        category2.id = UUID(uuidString: "FFFFFFFF-E68F-4655-90AB-4160411BBAF1")

        let category3 = UsageCategory(context: managedObjectContext)
        category3.creationDate = testDate.addingTimeInterval(-10)
        category3.id = UUID()

        let allCategories = [category1, category2, category3]
        let sortedCategories = allCategories.sorted()

        XCTAssertEqual(
            [category3, category1, category2],
            sortedCategories,
            "Sorting category arrays should use name then uuid."
        )
    }
}
