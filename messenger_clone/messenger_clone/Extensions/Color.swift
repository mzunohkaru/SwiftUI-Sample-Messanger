//
//  Color.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import SwiftUI

extension Color {
    static var theme = Theme()
}

struct Theme {
    let primaryText = Color("PrimaryTextColor")
    let background = Color("BackgroundColor")
    let secondaryBackground = Color(.systemGray5)
}
