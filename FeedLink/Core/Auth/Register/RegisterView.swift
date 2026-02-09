//
//  RegisterView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/6/26.
//

import SwiftUI

struct RegisterView: View {
    @State var viewModel: RegisterViewModel
    @FocusState private var focusField: Field?
    
    enum Field: Hashable {
        case name, email, contact, password, role
    }
    
    var path: Binding<[AuthPathOption]>

    init(viewModel: RegisterViewModel, path: Binding<[AuthPathOption]>) {
        _viewModel = State(initialValue: viewModel)
        self.path = path
    }
    
    var body: some View {
        ScrollView() {
            VStack(spacing: 24) {
                FormField(
                    label: "Name",
                    placeholder: "Your name",
                    text: $viewModel.name,
                    validator: RequiredValidator(fieldName: "Name"),
                    autocapitalization: .words,
                    onSubmit: { focusField = .email }
                )
                
                FormField(
                    label: "Email",
                    placeholder: "Your email",
                    text: $viewModel.email,
                    validator: CompositeValidator(
                        validators: [
                            RequiredValidator(fieldName: "Email"),
                            EmailValidator(),
                            
                        ]
                    ),
                    keyboardType: .emailAddress,
                    autocapitalization: .never,
                    submitLabel: .next,
                    onSubmit: { focusField = .contact
                    }
                )
                
                FormField(
                    label: "Contact",
                    placeholder: "Your contact",
                    text: $viewModel.contact,
                    validator: RequiredValidator(fieldName: "Contact"),
                    keyboardType: .phonePad,
                    submitLabel: .next,
                    onSubmit: { focusField = .password }
                )
                
                FormField(
                    label: "Password",
                    placeholder: "Your password",
                    text: $viewModel.password,
                    validator: CompositeValidator(
                        validators: [
                            RequiredValidator(fieldName: "Password"),
                            MinLengthValidator(minLength: 6, fieldName: "Password"),
                        ]
                    ),
                    isSecure: true,
                    submitLabel: .next,
                    onSubmit: { focusField = .role
                    }
                )
                
                FormPicker(
                    label: "Role",
                    options: UserRole.allCases,
                    selection: $viewModel.role,
                    validator: SelectionRequiredValidator(fieldName: "Role"),
                    placeholder: "Select a role"
                )
                
                AsyncCallToActionButton(isLoading: viewModel.isLoading, title: "Sign Up") {
                    viewModel.register(path: path)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .scrollBounceBehavior(.basedOnSize)
        .showCustomAlert(type: .alert, alert: $viewModel.showAlert)
    }
}

#Preview {
    let container = DevPreview.shared.container
    let builder = CoreBuilder(interactor: CoreInteractor(container: container))
    builder.registerView(path: .constant([]))
        .previewEnvironment()
}
