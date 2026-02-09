//
//  FormField.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/7/26.
//

import SwiftUI

protocol FieldValidator {
    func validate(_ value: String) -> String?
}

struct EmailValidator: FieldValidator {
    func validate(_ value: String) -> String? {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: value) ? nil : "Please enter a valid email address"
    }
}

struct RequiredValidator: FieldValidator {
    let fieldName: String
    
    func validate(_ value: String) -> String? {
        value.trimmingCharacters(in: .whitespaces).isEmpty ? "\(fieldName) is required" : nil
    }
}

struct MinLengthValidator: FieldValidator {
    let minLength: Int
    let fieldName: String
    
    func validate(_ value: String) -> String? {
        value.count < minLength ? "\(fieldName) must be at least \(minLength) characters long" : nil
    }
}

struct OTPValidator: FieldValidator {
    func validate(_ value: String) -> String? {
        value.count == 6 ? nil : "Please enter a valid code"
    }
}

struct CompositeValidator: FieldValidator {
    let validators: [FieldValidator]
    
    func validate(_ value: String) -> String? {
        for validator in validators {
            if let error = validator.validate(value) {
                return error
            }
        }
        return nil
    }
}

struct FormField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    var validator: FieldValidator?
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences
    var submitLabel: SubmitLabel = .next
    var onSubmit: (() -> Void)?
    
    @State private var errorMessage: String?
    @State private var hasBeenEdited: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(.primary)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(placeholder, text: $text)
                        .focused($isFocused)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autocapitalization)
                }
            }
            .submitLabel(submitLabel)
            .onSubmit {
                onSubmit?()
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .onChange(of: text) { _, _ in
                if hasBeenEdited {
                    validateField()
                }
            }
            .onChange(of: isFocused) { _, newValue in
                if !newValue && !hasBeenEdited {
                    hasBeenEdited = true
                    validateField()
                }
            }
            
            if let errorMessage = errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.circle.fill")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: errorMessage)
    }
    
    private var borderColor: Color {
        if let _ = errorMessage {
            return .red
        } else if isFocused {
            return .blue
        } else {
            return .clear
        }
    }
    
    private func validateField() {
        errorMessage = validator?.validate(text)
    }
    
    /// Public method to trigger validation (useful for form submission)
    func validate() -> Bool {
        validateField()
        return errorMessage == nil
    }
}

extension FormField {
    init(
        label: String,
        placeholder: String = "",
        text: Binding<String>,
        validator: FieldValidator? = nil,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences,
        submitLabel: SubmitLabel = .next,
        onSubmit: (() -> Void)? = nil
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.validator = validator
        self.isSecure = false
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
        self.submitLabel = submitLabel
        self.onSubmit = onSubmit
    }
    
    static func secure(
        label: String,
        placeholder: String = "",
        text: Binding<String>,
        validator: FieldValidator? = nil,
        submitLabel: SubmitLabel = .next,
        onSubmit: (() -> Void)? = nil
    ) -> FormField {
        var field = FormField(
            label: label,
            placeholder: placeholder,
            text: text,
            validator: validator,
            submitLabel: submitLabel,
            onSubmit: onSubmit
        )
        field.isSecure = true
        return field
    }
}

#Preview {
    @Previewable @State var email: String = ""
    
    FormField(
        label: "Email",
        placeholder: "Enter your email...",
        text: $email,
        validator: EmailValidator(),
        isSecure: false,
        keyboardType: .emailAddress,
        autocapitalization: .never,
    )
    .padding()
}
