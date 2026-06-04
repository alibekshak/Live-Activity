//
//  AuthActivityStyleEnum.swift
//  Live-Activity
//
//  Created by Alibek Shakirov on 04.06.2026.
//

import SwiftUI

enum LiveActivityStyleEnum {
    static func effectivePhase(
        for state: PhoneActivityState,
        isStale: Bool = false,
    ) -> Phase {
        if state.phase == .searching || state.phase == .ready {
            if isStale { return .expired }
            if let until = state.until, until <= Date() { return .expired }
        }
        return state.phase
    }
    
    static func iconName(
        for phase: Phase,
    ) -> String {
        switch phase {
        case .searching: "dot.radiowaves.left.and.right"
        case .ready: "phone.arrow.up.right.fill"
        case .expired: "clock.badge.exclamationmark.fill"
        case .banned: "exclamationmark.triangle.fill"
        case .completed: "checkmark.circle.fill"
        }
    }
    
    static func tint(for phase: Phase) -> Color {
        switch phase {
        case .searching: .blue
        case .ready: .green
        case .expired: .orange
        case .banned: .red
        case .completed: .green
        }
    }
    
    static func title(
        for phase: Phase
    ) -> String {
        switch phase {
        case .searching: "Ищем абонента"
        case .ready: "Абонент найден"
        case .expired: "Время истекло"
        case .banned: "Слишком много попыток"
        case .completed: "Готово"
        }
    }
    
    static func subtitle(
        for state: PhoneActivityState,
        isStale: Bool = false,
    ) -> String? {
        let phase = effectivePhase(for: state, isStale: isStale)
        switch phase {
        case .searching: return "Это может занять время"
        case .ready: return "Откройте приложение"
        case .expired: return "Откройте, чтобы повторить"
        case .banned: return "Подробности в приложении"
        case .completed: return nil
        }
    }
}
