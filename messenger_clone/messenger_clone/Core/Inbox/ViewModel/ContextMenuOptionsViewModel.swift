//
//  ContentMenuOptionsViewModel.swift
//  messenger_clone
//
//  Created by Mizuno Hikaru on 2024/02/06.
//

import Foundation

enum ContextMenuOptionsViewModel: Int, CaseIterable, Identifiable {
    case mute
    case hide
    case delete
    
    var imageName: String {
        switch self {
        case .mute: return "speaker.slash"
        case .hide: return "eye.slash"
        case .delete: return "trash"
        }
    }
    
    var title: String {
        switch self {
        case .mute: return "Mute"
        case .hide: return "Hide"
        case .delete: return "Delete"
        }
    }
    
    var action: Void {
        switch self {
        case .mute:
            print("DEBUG: Mute")
        case .hide:
            print("DEBUG: Hide")
        case .delete:
            print("DEBUG: Delete")
        }
    }
    
    var id: Int { return self.rawValue }
}

