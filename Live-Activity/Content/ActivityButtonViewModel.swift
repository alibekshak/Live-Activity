//
//  ActivityButtonViewModel.swift
//  Live-Activity
//
//  Created by Alibek Shakirov on 13.07.2026.
//

import ActivityKit
import Observation
import SwiftUI

@MainActor
@Observable
final class ActivityButtonViewModel {
    private(set) var currentActivity: Activity<PhoneActivityAttributes>?
    private(set) var errorMessage: String?
    private(set) var isLoading = false
    
    var hasActiveActivity: Bool {
        currentActivity?.activityState == .active
    }
    var activeActivity: Activity<PhoneActivityAttributes>? {
        Activity<PhoneActivityAttributes>.activities.first {
            $0.activityState == .active
        }
    }
    
    // MARK: - Tasks
    
    @ObservationIgnored
    private var activityStateTask: Task<Void, Never>?
    @ObservationIgnored
    private var errorDismissTask: Task<Void, Never>?
    
    // MARK: - Lifecycle
    
    init() {
        restoreActivity()
    }
    
    deinit {
        activityStateTask?.cancel()
        errorDismissTask?.cancel()
    }

    func startActivity() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            errorMessage = "Live Activities disabled"
            return
        }
        
        if let existingActivity = Activity<PhoneActivityAttributes>.activities.first {
            currentActivity = existingActivity
            errorMessage = "Live Activity already exists"
            return
        }
        
        let expirationDate = Date().addingTimeInterval(120)
        
        let attributes = PhoneActivityAttributes(
            phone: "+77771234567"
        )
        
        let state = PhoneActivityState(
            phase: .searching,
            displayCode: nil,
            until: expirationDate
        )
        
        let content = ActivityContent(
            state: state,
            staleDate: expirationDate
        )
        
        do {
            currentActivity = try Activity<PhoneActivityAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil
            )
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func updateActivity(to phase: Phase) async {
        guard isLoading == false else { return }
        
        guard let currentActivity else {
            errorMessage = "No active Live Activity"
            return
        }
        
        isLoading = true
        clearError()
        
        defer { isLoading = false }
        
        let expirationDate: Date? = phase.supportsTimer
        ? Date().addingTimeInterval(120)
        : nil
        
        let state = PhoneActivityState(
            phase: phase,
            displayCode: phase == .ready ? "1234" : nil,
            until: expirationDate
        )
        
        let content = ActivityContent(
            state: state,
            staleDate: expirationDate
        )
        
        await currentActivity.update(content)
    }
    
    func endActivity() async {
        guard let currentActivity else { return }
        
        let finalState = PhoneActivityState(
            phase: .completed,
            displayCode: nil,
            until: nil
        )
        
        let finalContent = ActivityContent(
            state: finalState,
            staleDate: nil
        )
        
        await currentActivity.end(
            finalContent,
            dismissalPolicy: .after(Date().addingTimeInterval(5))
        )
        
        activityStateTask?.cancel()
        activityStateTask = nil
        isLoading = false
        self.currentActivity = nil
    }
    
    func clearError() {
        errorDismissTask?.cancel()
        errorDismissTask = nil
        errorMessage = nil
    }
    
    func restoreActivity() {
        guard let activity = activeActivity else {
            currentActivity = nil
            return
        }
        
        setCurrentActivity(activity)
    }
    
    func setCurrentActivity(
        _ activity: Activity<PhoneActivityAttributes>
    ) {
        currentActivity = activity
        observeState(of: activity)
    }
    
    func observeState(
        of activity: Activity<PhoneActivityAttributes>
    ) {
        activityStateTask?.cancel()
        
        activityStateTask = Task { [weak self] in
            for await state in activity.activityStateUpdates {
                guard Task.isCancelled == false else {
                    return
                }
                
                switch state {
                case .active:
                    break
                    
                case .stale:
                    break
                    
                case .ended, .dismissed:
                    guard self?.currentActivity?.id == activity.id else {
                        return
                    }
                    
                    self?.currentActivity = nil
                    return
                    
                case .pending:
                    break
                    
                @unknown default:
                    self?.currentActivity = nil
                    return
                }
            }
        }
    }
}
