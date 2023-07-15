//
//  ContentViewToolbar.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import SwiftUI
import Charts

struct ContentViewToolbar: View {
    @EnvironmentObject var dataController: DataController
    @State private var showingChart = false

    var body: some View {
        Menu {
            Button(dataController.filterEnabled ? "Turn Filter Off" : "Turn Filter On") {
                dataController.filterEnabled.toggle()
            }

            Divider()

            Menu("Sort By") {
                Picker("Sort By", selection: $dataController.sortType) {
                    Text("Start Date").tag(SortType.startDate)
                    Text("End Date").tag(SortType.endDate)
                }

                Divider()

                Picker("Sort Order", selection: $dataController.sortNewestFirst) {
                    Text("Newest to Oldest").tag(true)
                    Text("Oldest to Newest").tag(false)
                }
            }
        } label: {
            Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                .symbolVariant(dataController.filterEnabled ? .fill : .none)
        }

        if dataController.selectedFilter != .recent {
            Button(action: dataController.newUsage) {
                Label("New Usage", systemImage: "square.and.pencil")
            }

            Button {
                showingChart.toggle()
            } label: {
                Label("Chart", systemImage: "chart.xyaxis.line")
            }
            .sheet(isPresented: $showingChart) {
                GroupBox("Usage Amount") {
                    Chart {
                        ForEach(getUsageData()) {
                            LineMark(
                                x: .value("Week Day", $0.weekday, unit: .month),
                                y: .value("Amount", $0.amount)
                            )
                            .foregroundStyle(by: .value("Value", "Amount"))
                        }
                        .lineStyle(StrokeStyle(lineWidth: 2.0))
                        .interpolationMethod(.cardinal)
                    }
                    .chartForegroundStyleScale([
                        "Amount": .teal
                    ])
                }

                GroupBox("Usage Price") {
                    Chart {
                        ForEach(getUsageData()) {
                            LineMark(
                                x: .value("Week Day", $0.weekday, unit: .month),
                                y: .value("Price", $0.price)
                            )
                            .foregroundStyle(by: .value("Value", "Price"))
                        }
                        .lineStyle(StrokeStyle(lineWidth: 2.0))
                        .interpolationMethod(.cardinal)
                    }
                    .chartForegroundStyleScale([
                        "Price": .orange
                    ])
                }
            }
        }
    }

    func getUsageData() -> [LineChartDataPoint] {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return dataController.usageForSelectedFilter().map {
            let data = LineChartDataPoint(
                day: formatter.string(from: $0.usageStartDate),
                amount: $0.usageAmount,
                price: $0.usagePrice
            )
            return data
        }
    }
}

struct ContentViewToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ContentViewToolbar()
    }
}
