//
//  FinalGameView.swift
//  GeoAllies
//

import SwiftUI
import UIKit

struct FinalGameView: View {

    @Binding var isPresent: Bool

    @State private var animateConfetti = false

    @Environment(\.accessibilityVoiceOverEnabled)
    private var voiceOverEnabled

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    private let confettiCount = 45

    var body: some View {

        GeometryReader { geometry in

            ZStack {

                // MARK: - Fundo

                Color.black
                    .opacity(0.30)
                    .ignoresSafeArea()
                    .accessibilityHidden(true)

                // MARK: - Confetes

                if !reduceMotion {

                    ForEach(
                        0..<confettiCount,
                        id: \.self
                    ) { index in

                        confettiPiece(
                            index: index,
                            size: geometry.size
                        )
                        .accessibilityHidden(true)
                    }
                }

                // MARK: - Popup

                ZStack(
                    alignment: .topTrailing
                ) {

                    RoundedRectangle(
                        cornerRadius: 35
                    )
                    .fill(
                        Color(
                            red: 245 / 255,
                            green: 245 / 255,
                            blue: 245 / 255
                        )
                    )
                    .accessibilityHidden(true)

                    VStack(spacing: 8) {

                        // MARK: - Texto

                        Text(
                            "Parabéns! Você conquistou o mundo!"
                        )
                        .font(
                            .system(
                                size: 30,
                                weight: .heavy,
                                design: .rounded
                            )
                        )
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                        .padding(
                            .horizontal,
                            45
                        )
                        .padding(
                            .top,
                            20
                        )
                        .accessibilityElement(
                            children: .ignore
                        )
                        .accessibilityLabel(
                            "Parabéns! Você conquistou o mundo!"
                        )
                        .accessibilityAddTraits(
                            .isHeader
                        )
                        .accessibilitySortPriority(100)

                        Spacer()

                        // MARK: - Conselheiro

                        Image("counsil")
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: 220,
                                height: 210
                            )
                            .offset(y: 20)
                            .accessibilityHidden(true)
                    }
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .clipped()

                    // MARK: - Fechar

                    Button {

                        isPresent = false

                    } label: {

                        Image(
                            systemName: "xmark"
                        )
                        .font(
                            .system(
                                size: 22,
                                weight: .heavy
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(
                            width: 50,
                            height: 50
                        )
                        .background(.red)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                        .accessibilityHidden(true)
                    }
                    .buttonStyle(.plain)
                    .offset(
                        x: 15,
                        y: -15
                    )
                    .accessibilityElement(
                        children: .ignore
                    )
                    .accessibilityLabel(
                        "Fechar"
                    )
                    .accessibilityHint(
                        "Fecha a mensagem de vitória"
                    )
                    .accessibilitySortPriority(90)
                }
                .frame(
                    width:
                        geometry.size.width * 0.72,
                    height:
                        geometry.size.height * 0.72
                )
                .position(
                    x: geometry.size.width / 2,
                    y: geometry.size.height / 2
                )
                .accessibilityAddTraits(
                    .isModal
                )
                .zIndex(10)
            }
            .frame(
                width: geometry.size.width,
                height: geometry.size.height
            )
            .onAppear {

                // MARK: - Confetes

                if !reduceMotion {
                    animateConfetti = true
                }

                // MARK: - VoiceOver

                announceVictory()
            }
        }
    }

    // MARK: - Anunciar vitória

    private func announceVictory() {

        guard voiceOverEnabled else {
            return
        }

        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.5
        ) {

            UIAccessibility.post(
                notification: .announcement,
                argument:
                    """
                    Parabéns! Você conquistou o mundo!
                    Você conseguiu formar uma aliança com todos os países.
                    """
            )
        }
    }

    // MARK: - Confete

    @ViewBuilder
    private func confettiPiece(
        index: Int,
        size: CGSize
    ) -> some View {

        let xPosition =
            CGFloat(
                (index * 73) % 100
            ) / 100

        let delay =
            Double(
                (index * 13) % 20
            ) / 20

        let duration =
            Double(
                2.5 +
                Double(
                    (index * 7) % 10
                ) / 10
            )

        let rotation =
            Double(
                (index * 41) % 360
            )

        let width =
            CGFloat(
                7 + (index % 8)
            )

        let height =
            CGFloat(
                12 + (index % 10)
            )

        Rectangle()
            .fill(
                confettiColor(index)
            )
            .frame(
                width: width,
                height: height
            )
            .rotationEffect(
                .degrees(
                    animateConfetti
                        ? rotation + 360
                        : rotation
                )
            )
            .position(
                x: size.width * xPosition,
                y:
                    animateConfetti
                    ? size.height + 40
                    : -40
            )
            .animation(
                .linear(
                    duration: duration
                )
                .repeatForever(
                    autoreverses: false
                )
                .delay(delay),
                value: animateConfetti
            )
            .zIndex(20)
            .accessibilityHidden(true)
    }

    // MARK: - Cores dos confetes

    private func confettiColor(
        _ index: Int
    ) -> Color {

        switch index % 6 {

        case 0:
            return .red

        case 1:
            return .yellow

        case 2:
            return .blue

        case 3:
            return .green

        case 4:
            return .pink

        default:
            return .orange
        }
    }
}

// MARK: - Preview

#Preview {

    ZStack {

        Color.blueSea
            .ignoresSafeArea()

        FinalGameView(
            isPresent: .constant(true)
        )
    }
}
