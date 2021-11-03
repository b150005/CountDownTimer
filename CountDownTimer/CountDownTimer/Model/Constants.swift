//
//  Constants.swift
//  CountDownTimer
//
//  Created by 伊藤直輝 on 2021/11/02.
//

import Foundation
import KeyboardShortcuts

/// https://github.com/sindresorhus/KeyboardShortcuts
extension KeyboardShortcuts.Name {
  static let toggleUnicornMode = Self("toggleUnicornMode", default: .init(.r, modifiers: [.command]))
}
