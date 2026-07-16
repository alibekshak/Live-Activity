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
            Button {
                Task {
                    await viewModel.startActivity()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Start Activity")
                }
            }
            .buttonStyle(.bordered)
            .disabled(viewModel.hasActiveActivity || viewModel.isLoading)
            
            if let activity = viewModel.currentActivity {
                Text("Activity ID: \(activity.id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                
                Button("Set Ready") {
                    Task {
                        await viewModel.updateActivity(to: .ready)
                    }
                }
                
                Button("Set Expired") {
                    Task {
                        await viewModel.updateActivity(to: .expired)
                    }
                }
                
                Button("Complete") {
                    Task {
                        await viewModel.endActivity()
                    }
                }
                .foregroundStyle(Color.red)
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
                    .onAppear {
                        Task {
                            try await Task.sleep(for: .seconds(4))
                            viewModel.clearError()
                        }
                    }
            }
        }
        .padding()
    }
}

#Preview {
    TestLiveActivityButton()
}
