//
//  DataController.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import CoreData

enum SortType: String {
    case startDate
    case endDate
}

enum Status {
    case all, today
}

class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer

    @Published var selectedFilter: Filter? = Filter.recent
    @Published var selectedUsage: Usage?

    @Published var filterText = ""
    @Published var filterTokens = [Category]()

    @Published var filterEnabled = false
    @Published var filterPriority = -1
    @Published var filterStatus = Status.all
    @Published var sortType = SortType.startDate
    @Published var sortNewestFirst = true

    private var saveTask: Task<Void, Error>?

    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        dataController.createSampleData()
        return dataController
    }()

    static let model: NSManagedObjectModel = {
        guard let url = Bundle.main.url(forResource: "Model", withExtension: "momd") else {
            fatalError("Failed to locate model file.")
        }

        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Failed to load model file.")
        }

        return managedObjectModel
    }()

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Model", managedObjectModel: Self.model)

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(filePath: "/dev/null")
        }

        let groupID = "group.com.samhui.usagetracker"

        if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) {
            container.persistentStoreDescriptions.first?.url =
            url.appending(path: "Model.sqlite")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump

        container.persistentStoreDescriptions.first?.setOption(
            true as NSNumber,
            forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey
        )

        NotificationCenter.default.addObserver(
            forName: .NSPersistentStoreRemoteChange,
            object: container.persistentStoreCoordinator,
            queue: .main,
            using: remoteStoreChanged
        )

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }

    func remoteStoreChanged(_ notification: Notification) {
        objectWillChange.send()
    }

    func createSampleData() {
        let viewContext = container.viewContext

        for categoryCount in 1...5 {
            let category = UsageCategory(context: viewContext)
            category.id = UUID()
            category.name = "Category \(categoryCount)"
            category.creationDate = .now
            category.averageAmount = 0.0
            category.averagePrice = 0.0

            for _ in 1...10 {
                let usage = Usage(context: viewContext)
                usage.startDate = .now
                usage.endDate = .now
                usage.amount = 100.0
                usage.price = 1000.0
                category.addToUsages(usage)
            }
        }
        try? viewContext.save()
    }

    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    func queueSave() {
        saveTask?.cancel()

        saveTask = Task { @MainActor in
            try await Task.sleep(for: .seconds(3))
            save()
        }
    }

    func delete(_ object: NSManagedObject) {
        objectWillChange.send()
        container.viewContext.delete(object)
        save()
    }

    private func delete(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        batchDeleteRequest.resultType = .resultTypeObjectIDs

        if let delete = try? container.viewContext.execute(batchDeleteRequest) as? NSBatchDeleteResult {
            let changes = [NSDeletedObjectsKey: delete.result as? [NSManagedObjectID] ?? []]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes, into: [container.viewContext])
        }
    }

    func deleteAll() {
        let request1: NSFetchRequest<NSFetchRequestResult> = UsageCategory.fetchRequest()
        delete(request1)

        let request2: NSFetchRequest<NSFetchRequestResult> = Usage.fetchRequest()
        delete(request2)

        save()
    }

    func usageForSelectedFilter() -> [Usage] {
        let filter = selectedFilter ?? .recent
        var predicates = [NSPredicate]()

        if let category = filter.category {
            let categoryPredicate = NSPredicate(format: "category CONTAINS %@", category)
            predicates.append(categoryPredicate)
        }

        let trimmedFilterText = filterText.trimmingCharacters(in: .whitespaces)

        if trimmedFilterText.isEmpty == false {
            let titlePredicate = NSPredicate(format: "category.name CONTAINS[c] %@", trimmedFilterText)
            predicates.append(titlePredicate)
        }

        let request = Usage.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: sortType.rawValue, ascending: sortNewestFirst)]

        let allLineItems = (try? container.viewContext.fetch(request)) ?? []
        return allLineItems
    }

    func newCategory() {
        let category = UsageCategory(context: container.viewContext)
        category.id = UUID()
        category.name = NSLocalizedString("New Category", comment: "New Category")
        category.creationDate = .now
        category.averageAmount = 0.0
        category.averagePrice = 0.0
        save()
    }

    func newUsage() {
        let usage = Usage(context: container.viewContext)
        usage.startDate = .now
        usage.endDate = .now
        usage.amount = 0.0
        usage.creationDate = .now
        usage.price = 0.0

        if let category = selectedFilter?.category {
            usage.addToCategory(category)
        }

        save()

        selectedUsage = usage
    }

    func averageAmount(category: UsageCategory) {
        let usages = category.categoryUsages.map { $0.amount }

        let sum = Int(usages.reduce(0, +))
        let count = usages.count
        category.averageAmount = Double(sum / count)

        save()
    }

    func averagePrice(category: UsageCategory) {
        let usages = category.categoryUsages.map { $0.price }

        let sum = Int(usages.reduce(0, +))
        let count = usages.count
        category.averagePrice = Double(sum / count)

        save()
    }

    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
            (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
}
