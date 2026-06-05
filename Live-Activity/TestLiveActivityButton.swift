//
//  TestLiveActivityButton.swift
//  Live-Activity
//
//  Created by Alibek Shakirov on 05.06.2026.
//

import ActivityKit
import SwiftUI

struct TestLiveActivityButton: View {
    var body: some View {
        Button("Start Activity") {
            Task {
                guard ActivityAuthorizationInfo().areActivitiesEnabled else {
                    print("Live Activities disabled")
                    return
                }
                
                let attributes = PhoneActivityAttributes(
                    phone: "+77771234567"
                )
                
                let state = PhoneActivityState(
                    phase: .searching,
                    displayCode: nil,
                    until: Date().addingTimeInterval(120)
                )
                
                do {
                    let activity = try Activity<PhoneActivityAttributes>.request(
                        attributes: attributes,
                        content: .init(
                            state: state,
                            staleDate: nil
                        )
                    )
                    
                    print("Activity started:", activity.id)
                } catch {
                    print("Activity error:", error)
                }
            }
        }
    }
}

#Preview {
    TestLiveActivityButton()
}
