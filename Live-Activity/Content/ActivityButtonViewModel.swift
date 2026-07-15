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
    
    init() {
        currentActivity = Activity<PhoneActivityAttributes>.activities.first
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
    
    func clearError() {
        errorMessage = nil
    }
}
