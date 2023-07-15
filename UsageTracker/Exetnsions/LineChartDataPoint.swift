//
//  LineChartView.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/07/06.
//

import SwiftUI
import Charts

struct LineChartDataPoint: Identifiable {
    let id = UUID()
    let weekday: Date
    let amount: Double
    let price: Double

    init(day: String, amount: Double, price: Double) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        self.weekday = formatter.date(from: day) ?? Date.distantPast
        self.amount = amount
        self.price = price
    }
}
