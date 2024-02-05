//
//  ProfileImageSize.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/05.
//

import Foundation

enum ProfileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    
    var dimension: CGFloat {
        switch self {
        case .xxSmall:
            return 28
        case .xSmall:
            return 32
        case .small:
            return 40
        case .medium:
            return 48
        case .large:
            return 60
        case .xLarge:
            return 88
        }
    }
}
