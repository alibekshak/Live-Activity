//
//  ActivityStates.swift
//  Live-Activity
//
//  Created by Alibek Shakirov on 02.06.2026.
//

import Foundation
struct PhoneActivityState: Codable, Hashable {
    var phase: Phase
    var displayCode: String?
    var until: Date?
    
    init(
        phase: Phase,
        displayCode: String? = nil,
        until: Date? = nil
    ) {
        self.phase = phase
        self.displayCode = displayCode
        self.until = until
    }
}

enum Phase: String, Codable, Hashable, Sendable {
    case searching
    case ready
    case expired
    case banned
    case completed
    
    var supportsTimer: Bool {
        self == .searching || self == .ready
    }
}
