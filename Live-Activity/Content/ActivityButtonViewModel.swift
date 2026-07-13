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
    
}
