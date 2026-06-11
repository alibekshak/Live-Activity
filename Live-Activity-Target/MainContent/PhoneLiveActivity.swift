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
            let phase = LiveActivityStyleEnum.effectivePhase(
                for: context.state,
                isStale: context.isStale
            )

            VStack(alignment: .leading) {
                Text(LiveActivityStyleEnum.title(for: phase))

                if let subtitle = LiveActivityStyleEnum.subtitle(
                    for: context.state,
                    isStale: context.isStale
                ) {
                    Text(subtitle)
                }
            }
            .padding()
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
                    timer(for: context.state)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .padding(.trailing, 4)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LiveActivityStyleEnum.title(for: phase))
                            .font(.headline)
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        if let subtitle = LiveActivityStyleEnum.subtitle(
                            for: context.state,
                            isStale: context.isStale
                        ) {
                            Text(subtitle)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)
                    .padding(.top, 2)
                }
            } compactLeading: {
                Image("activityIcon")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color(.systemGray2))
                    .padding(2)
            } compactTrailing: {
                timer(for: context.state)
                    .monospacedDigit()
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: 40)
            } minimal: {
                Image("activityIcon")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color(.systemGray2))
                    .padding(2)
            }
        }
    }
    
    @ViewBuilder
    private func timer(for state: PhoneActivityAttributes.ContentState) -> some View {
        if let until = state.until,
           state.phase == .searching || state.phase == .ready,
           until > Date() {
            Text(timerInterval: Date()...until, countsDown: true)
        } else {
            EmptyView()
        }
    }
}
