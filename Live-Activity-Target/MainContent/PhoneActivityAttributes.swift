//
//  PhoneActivityAttributes.swift
//  Live-Activity
//
//  Created by Alibek Shakirov on 02.06.2026.
//

import Foundation
import ActivityKit

struct PhoneActivityAttributes: ActivityAttributes, Sendable {
    typealias ContentState = PhoneActivityState
    
    public var phone: String

    public init(phone: String) {
        self.phone = phone
    }
}
