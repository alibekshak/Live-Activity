//
//  PhoneLiveActivity.swift
//  Live-Activity
//
//  Created by Alibek Shakirov on 02.06.2026.
//

import ActivityKit
import SwiftUI
import WidgetKit

public struct PhoneLiveActivity: Widget {
    public init() { }
    
    public var body: some WidgetConfiguration {
        ActivityConfiguration(for: PhoneActivityAttributes.self) { context in
            lockScreenView(context)
        } dynamicIsland: { context in
            dynamicIslandView(context)
        }
    }
    
    @ViewBuilder
    private func lockScreenView(
        _ context: ActivityViewContext<PhoneActivityAttributes>
    ) -> some View {
        let phase = phase(for: context)
        
        HStack(spacing: 12) {
            Image("activityIcon")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundStyle(LiveActivityStyleEnum.tint(for: phase))
                .frame(width: 32, height: 32)
            
            VStack(alignment: .leading, spacing: 4) {
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
                        .lineLimit(2)
                }
            }
            
            Spacer()
            
            timer(for: context.state)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
        }
        .padding()
    }
    
    private func dynamicIslandView(
        _ context: ActivityViewContext<PhoneActivityAttributes>
    ) -> DynamicIsland {
        let phase = phase(for: context)
        
        return DynamicIsland {
            DynamicIslandExpandedRegion(.leading) {
                expandedIcon(for: phase)
            }
            
            DynamicIslandExpandedRegion(.trailing) {
                expandedTimer(for: context.state)
            }
            
            DynamicIslandExpandedRegion(.bottom) {
                expandedBottom(context, phase: phase)
            }
        } compactLeading: {
            compactIcon()
        } compactTrailing: {
            compactTimer(for: context.state)
        } minimal: {
            compactIcon()
        }
    }
    
    private func expandedIcon(for phase: Phase) -> some View {
        Image(systemName: LiveActivityStyleEnum.iconName(for: phase))
            .font(.title3)
            .foregroundStyle(LiveActivityStyleEnum.tint(for: phase))
            .padding(.leading, 4)
    }
    
    private func expandedTimer(for state: PhoneActivityAttributes.ContentState) -> some View {
        timer(for: state)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(.primary)
            .lineLimit(1)
            .padding(.trailing, 4)
    }
    
    private func expandedBottom(
        _ context: ActivityViewContext<PhoneActivityAttributes>,
        phase: Phase
    ) -> some View {
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
    
    private func compactIcon() -> some View {
        Image("activityIcon")
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .foregroundStyle(Color(.systemGray2))
            .padding(2)
    }
    
    private func compactTimer(for state: PhoneActivityAttributes.ContentState) -> some View {
        timer(for: state)
            .monospacedDigit()
            .font(.caption)
            .foregroundStyle(.primary)
            .frame(maxWidth: 40)
    }
    
    @ViewBuilder
    private func timer(for state: PhoneActivityAttributes.ContentState) -> some View {
        if let until = state.until,
           (state.phase == .searching || state.phase == .ready),
           until > Date() {
            Text(timerInterval: Date()...until, countsDown: true)
        } else {
            EmptyView()
        }
    }
    
    private func phase(
        for context: ActivityViewContext<PhoneActivityAttributes>
    ) -> Phase {
        LiveActivityStyleEnum.effectivePhase(
            for: context.state,
            isStale: context.isStale
        )
    }
}
