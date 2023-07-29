//
//  UsageTrackerTests.swift
//  UsageTrackerTests
//
//  Created by Sam Hui on 2023/07/17.
//

import CoreData
import XCTest
@testable import UsageTracker

class BaseTestCase: XCTestCase {
    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func setUpWithError() throws {
        dataController = DataController(inMemory: true)
        managedObjectContext = dataController.container.viewContext
    }
}
