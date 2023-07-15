//
//  NoUsageView.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import SwiftUI

struct NoUsageView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        Text("No record selected")
            .font(.title)
            .foregroundStyle(.secondary)

        Button("New Usage", action: dataController.newUsage)
    }
}

struct NoUsageView_Previews: PreviewProvider {
    static var previews: some View {
        NoUsageView()
    }
}
