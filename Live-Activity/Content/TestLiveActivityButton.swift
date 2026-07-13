//
//  TestLiveActivityButton.swift
//  Live-Activity
//
//  Created by Alibek Shakirov on 05.06.2026.
//

import ActivityKit
import SwiftUI

struct TestLiveActivityButton: View {
    @State private var viewModel: ActivityButtonViewModel

    init() {
        _viewModel = State(initialValue: ActivityButtonViewModel())
    }
    var body: some View {
        VStack(spacing: 16) {
            Button("Start Activity") {
                Task {
                    // TODO: - Create method for starting activity
                }
            }
            .disabled(viewModel.currentActivity != nil)

            if let activity = viewModel.currentActivity {
                Text("Activity ID: \(activity.id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
    }
}

#Preview {
    TestLiveActivityButton()
}
