//
//  ScrollViewOffsetPreferenceKey.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import SwiftUI

// PreferenceKey : ScrollViewのオフセット値を管理するために使用されます
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
  // オフセットの初期値 = 0
  static var defaultValue = CGFloat.zero

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value += nextValue()
  }
}
