//
//  VerificationView.swift
//  FeedLink
//
//  Created by roshan lamichhane on 2/9/26.
//

import SwiftUI

struct VerificationView: View {
    @State var viewModel: VerificationViewModel

    var email: String
    var path: Binding<[AuthPathOption]>

    private let shakeTrigger: Int = 2

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text("Verify your email")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text("We sent a 6-digit code to \(email)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 16)

                VStack(spacing: 12) {
                    FormField(
                        label: "Verification code",
                        placeholder: "Enter OTP code you got on email",
                        text: $viewModel.verificationCode,
                        validator: CompositeValidator(
                            validators: [
                                RequiredValidator(fieldName: "Verification code"),
                                OTPValidator()
                            ]
                        ),
                        keyboardType: .numberPad,
                        submitLabel: .done
                    )
                    .accessibilityElement(children: .contain)
                    .accessibilityLabel("Verification code entry")
                    .modifier(ShakeEffect(animatableData: CGFloat(shakeTrigger)))
                }

                AsyncCallToActionButton(isLoading: viewModel.isLoading, title: "Verify") {
                    viewModel.verify(email: email, path: path)
                }

                Button(action: {
                    viewModel.resendCode(email: email)
                }) {
                    Text(resendTitle)
                        .font(.footnote)
                }
                .disabled(!viewModel.canResend)
                .foregroundStyle(viewModel.canResend ? .accent : .secondary)

                Spacer(minLength: 12)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .scrollBounceBehavior(.basedOnSize)
        .onAppear {
            if viewModel.canResend {
                viewModel.startResendTimer()
            }
        }
        .showCustomAlert(alert: $viewModel.showAlert)
    }

    private var resendTitle: String {
        if viewModel.canResend {
            return "Resend Code"
        }
        let seconds = viewModel.resendRemaining
        return String(format: "Resend in %02d:%02d", seconds / 60, seconds % 60)
    }
}

private struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let translation = 8 * sin(animatableData * .pi * 2)
        return ProjectionTransform(CGAffineTransform(translationX: translation, y: 0))
    }
}

#Preview {
    let interactor = CoreInteractor(container: DevPreview.shared.container)
    let builder = CoreBuilder(interactor: interactor)
    builder.verificationView(path: .constant([]), email: "ds.roshanlamichhane@gmail.com")
        .previewEnvironment()
}
