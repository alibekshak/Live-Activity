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
            buttonStartActivity
            contentForCurentActivity
            showErrorText
        }
        .padding()
        .animation(
            .default,
            value: viewModel.hasActiveActivity
        )
    }
    
    
    private var buttonStartActivity: some View {
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
    }
    
    private var contentForCurentActivity: some View {
        Group {
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
                .disabled(viewModel.isLoading)
                
                Button("Set Expired") {
                    Task {
                        await viewModel.updateActivity(to: .expired)
                    }
                }
                .disabled(viewModel.isLoading)
                
                Button("Complete", role: .destructive) {
                    Task {
                        await viewModel.endActivity()
                    }
                }
                .disabled(viewModel.isLoading)
            }
        }
    }
    
    private var showErrorText: some View {
        Group {
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
    }
}

#Preview {
    TestLiveActivityButton()
}
