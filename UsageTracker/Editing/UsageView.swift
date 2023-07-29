//
//  UsageView.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import SwiftUI

struct UsageView: View {
    @EnvironmentObject var dataController: DataController
    @ObservedObject var usage: Usage

    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var categories: FetchedResults<UsageCategory>

    @FocusState private var amountIsFocused: Bool
    @FocusState private var priceIsFocused: Bool

    var body: some View {
        Form {
            Section(header: Text("Name")) {
                ForEach(usage.usagesCategory) { category in
                    Text(category.categoryName)
                }
            }

            Section(header: Text("Start Date")) {
                DatePicker(selection: $usage.usageStartDate, in: ...Date(), displayedComponents: .date) {
                    Text("Select a Start Date")
                }
            }

            Section(header: Text("End Date")) {
                DatePicker(
                    selection: $usage.usageEndDate,
                    in: usage.usageStartDate...,
                    displayedComponents: .date
                ) {
                    Text("Select an End Date")
                }
            }

            Section(header: Text("Amount")) {
                TextField("Amount", value: $usage.usageAmount, format: .number)
                    .keyboardType(.decimalPad)
                    .focused($amountIsFocused)
                    .onAppear { UITextField.appearance().clearButtonMode = .whileEditing }
            }

            Section(header: Text("Price")) {
                TextField("Price",
                          value: $usage.usagePrice,
                          format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                    .keyboardType(.decimalPad)
                    .focused($priceIsFocused)
                    .onAppear { UITextField.appearance().clearButtonMode = .whileEditing }
            }
        }
        .disabled(usage.isDeleted)
        .onReceive(usage.objectWillChange) { _ in
            dataController.queueSave()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button("Done") {
                    amountIsFocused = false
                    priceIsFocused = false
                }
            }
        }
        .onDisappear {
            dataController.averageAmount(category: usage.usagesCategory[0])
            dataController.averagePrice(category: usage.usagesCategory[0])
        }
    }
}

struct UsageView_Previews: PreviewProvider {
    static var previews: some View {
        UsageView(usage: .example)
    }
}
