//
//  PhoneLiveActivity.swift
//  Live-Activity
//
//  Created by Alibek Shakirov on 02.06.2026.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct PhoneLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PhoneActivityAttributes.self) { context in
            
        } dynamicIsland: { context in
            let phase = LiveActivityStyleEnum.effectivePhase(
                for: context.state,
                isStale: context.isStale
            )
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: LiveActivityStyleEnum.iconName(for: phase))
                        .font(.title3)
                        .foregroundStyle(LiveActivityStyleEnum.tint(for: phase))
                        .padding(.leading, 4)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Some text")
                }
            } compactLeading: {
                // TODO: Create content
            } compactTrailing: {
                // TODO: Create content
            } minimal: {
                // TODO: Create content
            }
        }
    }
    
}
