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
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "xmark")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Some text")
                }
            } compactLeading: {
                // TODO: - Need to created a content
            } compactTrailing: {
                // TODO: - Need to created a content
            } minimal: {
                // TODO: - Need to created a content
            }
        }
    }
    
}
