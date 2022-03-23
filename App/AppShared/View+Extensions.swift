//
//  Fonts.swift
//  NFTWallet (iOS)
//
//  Created by Ukrit Wattanakulchart on 14/3/2565 BE.
//

import SwiftUI

enum FontWeight {
    case bold, regular, thin
}

extension Text {
    func font(with size: CGFloat = 16, weight: FontWeight) -> Text {
        switch weight {
        case .bold:
            return font(.system(size: size, weight: .bold, design: .monospaced))
        case .regular:
            return font(.system(size: size, weight: .regular, design: .monospaced))
        case .thin:
            return font(.system(size: size, weight: .thin, design: .monospaced))
        }
    }
}

extension View {
    func roundedClip() -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    func font(with size: CGFloat = 16, weight: FontWeight) -> some View {
        switch weight {
        case .bold:
            return self.font(.system(size: size, weight: .bold, design: .monospaced))
        case .regular:
            return self.font(.system(size: size, weight: .regular, design: .monospaced))
        case .thin:
            return self.font(.system(size: size, weight: .thin, design: .monospaced))
        }
    }
}
