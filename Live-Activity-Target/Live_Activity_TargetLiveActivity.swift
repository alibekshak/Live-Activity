//
//  Live_Activity_TargetLiveActivity.swift
//  Live-Activity-Target
//
//  Created by Alibek Shakirov on 05.06.2026.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct Live_Activity_TargetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct Live_Activity_TargetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Live_Activity_TargetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension Live_Activity_TargetAttributes {
    fileprivate static var preview: Live_Activity_TargetAttributes {
        Live_Activity_TargetAttributes(name: "World")
    }
}

extension Live_Activity_TargetAttributes.ContentState {
    fileprivate static var smiley: Live_Activity_TargetAttributes.ContentState {
        Live_Activity_TargetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: Live_Activity_TargetAttributes.ContentState {
         Live_Activity_TargetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: Live_Activity_TargetAttributes.preview) {
   Live_Activity_TargetLiveActivity()
} contentStates: {
    Live_Activity_TargetAttributes.ContentState.smiley
    Live_Activity_TargetAttributes.ContentState.starEyes
}
