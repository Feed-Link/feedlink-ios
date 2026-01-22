//
//  AsyncCallToActionButton.swift
//  FeedLink
//
//  Created by roshan lamichhane on 1/22/26.
//

import SwiftUI

struct AsyncCallToActionButton: View {
    
    var isLoading: Bool = false
    var title: String = "Save"
    var action: () -> Void
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .tint(.white)
            } else {
                Text(title)
            }
        }
        .callToActionButton()
        .anyButton(.press) {
            action()
        }
    }
}

private struct PreviewView: View {
    
    @State private var isLoading: Bool = false
    
    var body: some View {
        AsyncCallToActionButton(
            isLoading: isLoading,
            title: "Finish") {
                isLoading = true
                
                Task {
                    try? await Task.sleep(for: .seconds(3))
                    isLoading = false
                }
            }
    }
}

#Preview {
    PreviewView()
        .padding()
}
