//
//  ButtonViewModifiers.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/22/26.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay {
                configuration.isPressed ? Color.accent.opacity(0.5) : Color.accent.opacity(0)
            }
            .animation(.smooth, value: configuration.isPressed)
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.smooth, value: configuration.isPressed)
    }
}

enum ButtonStyleOption {
    case highlight, press, plain
}

extension View {
    
    @ViewBuilder
    func anyButton(_ option: ButtonStyleOption = .plain, action: @escaping () -> Void) -> some View {
        switch option {
        case .highlight:
            self.highlightButton(action: action)
        case .press:
            self.pressableButton(action: action)
        case .plain:
            self.plainButton(action: action)
        }
    }
    
    private func plainButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PlainButtonStyle())

    }
    
    private func highlightButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(HighlightButtonStyle())

    }
    
    private func pressableButton(action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
        .buttonStyle(PressableButtonStyle())

    }
}

#Preview {
    Text("Sample Button")
        .padding()
        .anyButton(.highlight) {
            
        }
    
    Text("Pressable Button")
        .callToActionButton()
        .padding()
        .anyButton(.press) {
            
        }
    
    Text("Plain Button")
        .callToActionButton()
        .padding()
        .anyButton {}
}
