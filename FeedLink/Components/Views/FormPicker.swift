//
//  FormPicker.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/8/26.
//

import SwiftUI

protocol Selectable: Hashable, CustomStringConvertible {
    var displayName: String { get }
}

enum UserRole: String, Selectable, CaseIterable {
    case donor = "donor"
    case recipient = "recipient"
    
    var displayName: String {
        switch self {
        case .donor:
            "Donor"
        case .recipient:
            "Recipient"
        }
    }
    
    var description: String {
        displayName
    }
    
    var icon: String {
        switch self {
        case .donor:
            "heart.fill"
        case .recipient:
            "person.fill"
        }
    }
    
    var subtitle: String {
        switch self {
        case .donor:
            "I want to donate food"
        case .recipient:
            "I want to distribute food"
        }
    }
}

struct SelectionRequiredValidator: FieldValidator {
    let fieldName: String
    
    func validate(_ value: String) -> String? {
        value.isEmpty ? "\(fieldName) is required" : nil
    }
}

struct FormPicker<T: Selectable>: View {
    let label: String
    let options: [T]
    @Binding var selection: T?
    var validator: FieldValidator?
    var placeholder: String = "Select an option"
    
    @State private var errorMessage: String?
    @State private var hasBeenEdited: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectOption(option)
                    }) {
                        HStack {
                            Text(option.displayName)
                            if selection == option {
                                Spacer()
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selection?.displayName ?? placeholder)
                        .foregroundStyle(selection == nil ? .secondary : .primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.secondary)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor, lineWidth: 1.5)
                )
            }
            .buttonStyle(.plain)
            
            if let errorMessage = errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
        .onChange(of: selection) { _, _ in
            if hasBeenEdited {
                validateField()
            }
        }
    }
    
    private var borderColor: Color {
        if let _ = errorMessage {
            return .red
        } else {
            return .clear
        }
    }
    
    private func selectOption(_ option: T) {
        selection = option
        if !hasBeenEdited {
            hasBeenEdited = true
        }
        validateField()
    }
    
    private func validateField() {
        if let validator = validator {
            errorMessage = validator.validate(selection?.displayName ?? "")
        }
    }
    
    /// Public method to trigger validation
    func validate() -> Bool {
        validateField()
        return errorMessage == nil
    }
}

#Preview {
    FormPicker(
        label: "Role",
        options: UserRole.allCases,
        selection: .constant(.donor)
    )
}
