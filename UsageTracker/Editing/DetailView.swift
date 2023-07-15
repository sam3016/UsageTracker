//
//  DetailView.swift
//  UsageTracker
//
//  Created by Sam Hui on 2023/06/25.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var dataController: DataController

    var body: some View {
        VStack {
            if let usage = dataController.selectedUsage {
                UsageView(usage: usage)
            } else {
                NoUsageView()
            }
        }
        .navigationTitle("Details")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
