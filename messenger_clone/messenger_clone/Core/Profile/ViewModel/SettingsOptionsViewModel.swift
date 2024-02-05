//
//  SettingsOptionsViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/01/22.
//

import SwiftUI

// CaseIterable : enumの値の総数を取得
enum SettingsOptionsViewModel: Int, CaseIterable, Identifiable {
    case darkMode
    case activeStatus
    case accessibility
    case privacy
    case notifications
    
    var title: String {
        switch self {
        case .darkMode: return "Dark mode"
        case .activeStatus: return "Active status"
        case .accessibility: return "Accessibility"
        case .privacy: return "Privacy and Safety"
        case .notifications: return "Notifications"
        }
    }
    
    var imageName: String {
        switch self {
        case .darkMode: return "moon.circle.fill"
        case .activeStatus: return "message.badge.circle.fill"
        case .accessibility: return "person.circle.fill"
        case .privacy: return "lock.circle.fill"
        case .notifications: return "bell.circle.fill"
        }
    }
    
    var imageBackgroundColor: Color {
        switch self {
        case .darkMode: return Color.theme.primaryText
        case .activeStatus: return Color(.systemGreen)
        case .accessibility: return Color.theme.primaryText
        case .privacy: return Color(.systemBlue)
        case .notifications: return Color(.systemPurple)
        }
    }
    
    var action: Void {
        switch self {
        case .darkMode:
        let isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
        UserDefaults.standard.set(!isDarkMode, forKey: "isDarkMode")
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = isDarkMode ? .light : .dark
        }
        case .activeStatus:
            print("DEBUG: \(self)")
        case .accessibility:
            print("DEBUG: \(self)")
        case .privacy:
            print("DEBUG: \(self)")
        case .notifications:
            print("DEBUG: \(self)")
        }
    }
    
    var id: Int { return self.rawValue }
}
