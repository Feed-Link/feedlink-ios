//
//  FoodCard.swift
//  FeedLink
//
//  Created by roshan lamichhane on 3/26/26.
//

import SwiftUI

struct FoodCard: View {

    private enum DS {
        static let cardRadius: CGFloat = 20
        static let imageRadius: CGFloat = 16
        static let cardPadding: CGFloat = 14
        static let itemSpacing: CGFloat = 10
        static let verticalSpacing: CGFloat = 6

        static let cardBackground = Color(.systemBackground)
        static let cardBorder = Color.black.opacity(0.06)
        static let cardShadow = Color.black.opacity(0.08)

        static let title = Color.primary
        static let subtitle = Color.primary.opacity(0.78)
        static let meta = Color.secondary
        static let description = Color.secondary

        static let vegBg = Color.green.opacity(0.12)
        static let vegFg = Color.green
        static let safetyBg = Color.blue.opacity(0.12)
        static let safetyFg = Color.blue
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: DS.itemSpacing) {
                Image("nepali-khana")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 132, height: 132)
                    .clipShape(RoundedRectangle(cornerRadius: DS.imageRadius, style: .continuous))

                VStack(alignment: .leading, spacing: DS.verticalSpacing) {
                    Text("Daal Bhat Leftovers")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(DS.title)
                        .lineLimit(2)

                    Text("Retro Restaurant")
                        .font(.subheadline)
                        .foregroundStyle(DS.subtitle)

                    Text("1.2 km • 45 min ago")
                        .font(.footnote)
                        .foregroundStyle(DS.meta)

                    Text("Surplus lunch meal, rice, dal, and a few other spices.")
                        .font(.footnote)
                        .foregroundStyle(DS.description)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(spacing: 8) {
                        pill(text: "Veg", background: DS.vegBg, foreground: DS.vegFg)
                        pill(text: "Safe for human", background: DS.safetyBg, foreground: DS.safetyFg)
                    }

                    HStack {
                        Text("Claim")
                            .callToActionButton()
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 2)
                }
            }
            .padding(DS.cardPadding)
        }
        .background(
            RoundedRectangle(cornerRadius: DS.cardRadius, style: .continuous)
                .fill(DS.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: DS.cardRadius, style: .continuous)
                .stroke(DS.cardBorder, lineWidth: 1)
        )
        .shadow(color: DS.cardShadow, radius: 10, x: 0, y: 4)
    }

    @ViewBuilder
    private func pill(text: String, background: Color, foreground: Color) -> some View {
        Text(text)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundStyle(foreground)
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
            .background(background)
            .clipShape(Capsule())
    }
}

#Preview {
    FoodCard()
        .padding()
        .background(Color(.systemGroupedBackground))
}
