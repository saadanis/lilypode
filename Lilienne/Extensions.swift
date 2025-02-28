//
//  Extensions.swift
//  Lilienne
//
//  Created by Saad Anis on 22/02/2025.
//

import SwiftUI

struct NavigationWithAccent: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.accent.opacity(0.2), for: .navigationBar)
            .toolbarBackground(.accent.opacity(0.2), for: .bottomBar)
            .scrollContentBackground(.hidden)
            .background(.accent.opacity(0.2))
    }
}

struct RoundedFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .fontDesign(.rounded)
    }
}

extension View {
    func navigationWithAccent() -> some View {
        modifier(NavigationWithAccent())
    }
    
    func roundedFont() -> some View {
        modifier(RoundedFont())
    }
}

enum AppIconProvider {
    static func appIcon(in bundle: Bundle = .main) -> String {
        guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let iconFileName = iconFiles.last else {
            fatalError("Could not find icons in bundle")
        }
        
        print(icons)
        print(primaryIcon)
        print(iconFiles)
        print(iconFileName)

        return iconFileName
    }
    
    static func allAppIcons(in bundle: Bundle = .main) -> [String] {
        guard let icons = bundle.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any] else {
            fatalError("Could not find icons in bundle.")
        }
        for icon in icons {
            print(icon.value)
        }
        return ["dupsum"]
    }
}

enum AppVersionProvider {
    static func appVersion(in bundle: Bundle = .main) -> String {
        guard let version = bundle.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else {
            fatalError("CFBundleShortVersionString should not be missing from info dictionary")
        }
        return version
    }
}
