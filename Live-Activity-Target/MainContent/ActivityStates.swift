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
}

enum Phase: String, Codable, Hashable {
    case searching
    case ready
    case expired
    case banned
    case completed
}
