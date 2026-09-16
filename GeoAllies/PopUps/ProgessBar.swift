//
//  ProgessBar.swift
//  GeoAllies
//
//  Created by Agnes Pontes Ristau on 02/09/26.
//

import SwiftUI

enum ProgressBarType {

    case economia
    case militarismo
    case tecnologia

    var color: Color {

        switch self {

        case .economia:
            return Color(
                red: 65 / 255,
                green: 67 / 255,
                blue: 170 / 255
            )

        case .militarismo:
            return Color(
                red: 30 / 255,
                green: 67 / 255,
                blue: 67 / 255
            )

        case .tecnologia:
            return Color(
                red: 237 / 255,
                green: 157 / 255,
                blue: 60 / 255
            )
        }
    }
}

// MARK: - Estilo do botão

struct EstiloBotaoMais3D: ButtonStyle {

    @Environment(\.accessibilityReduceMotion)
    private var reduceMotion

    func makeBody(
        configuration: Configuration
    ) -> some View {

        ZStack {

            Circle()
                .fill(
                    Color(
                        red: 100 / 255,
                        green: 140 / 255,
                        blue: 80 / 255
                    )
                )
                .frame(
                    width: 40,
                    height: 40
                )
                .offset(y: 4)
                .accessibilityHidden(true)

            ZStack {

                Circle()
                    .fill(
                        Color(
                            red: 140 / 255,
                            green: 180 / 255,
                            blue: 115 / 255
                        )
                    )
                    .frame(
                        width: 40,
                        height: 40
                    )
                    .accessibilityHidden(true)

                configuration.label
            }
            .offset(
                y: configuration.isPressed
                    ? 4
                    : 0
            )
        }
        .animation(
            reduceMotion
                ? nil
                : .spring(
                    response: 0.3,
                    dampingFraction: 0.6
                ),
            value: configuration.isPressed
        )
    }
}

// MARK: - ProgressBar

struct ProgressBar: View {

    let name: String
    let icon: String
    let value: Int
    let maximumValue: Int
    let type: ProgressBarType

    var showImproveButton: Bool = true

    let onImprove: () -> Void

    private var progress: CGFloat {

        guard maximumValue > 0 else {
            return 0
        }

        return min(
            CGFloat(value) /
            CGFloat(maximumValue),
            1
        )
    }

    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            // MARK: - Nome

            Label(
                name,
                systemImage: icon
            )
            .font(
                .custom(
                    "Fredoka-Bold",
                    size: 18
                )
            )
            .foregroundStyle(.white)
            .padding(
                .horizontal,
                12
            )
            .padding(
                .vertical,
                5
            )
            .background(type.color)
            .clipShape(Capsule())
            .accessibilityHidden(true)

            HStack(spacing: 14) {

                // MARK: - Indicador

                VStack(
                    alignment: .trailing,
                    spacing: 4
                ) {

                    GeometryReader { geometry in

                        ZStack(
                            alignment: .leading
                        ) {

                            Capsule()
                                .fill(
                                    Color.gray
                                        .opacity(0.12)
                                )

                            Capsule()
                                .fill(type.color)
                                .frame(
                                    width:
                                        geometry
                                            .size
                                            .width
                                        * progress
                                )
                        }
                        .accessibilityHidden(true)
                    }
                    .frame(height: 24)

                    Text(
                        "\(value)/\(maximumValue)"
                    )
                    .font(
                        .custom(
                            "Fredoka-Bold",
                            size: 17
                        )
                    )
                    .foregroundStyle(.black)
                    .accessibilityHidden(true)
                }
                .accessibilityElement(
                    children: .ignore
                )
                .accessibilityLabel(name)
                .accessibilityValue(
                    "\(value) de \(maximumValue) pontos"
                )

                // MARK: - Melhorar

                if showImproveButton &&
                    value < maximumValue {

                    Button {

                        onImprove()

                    } label: {

                        Image(
                            systemName: "plus"
                        )
                        .font(
                            .custom(
                                "Fredoka-Bold",
                                size: 17
                            )
                        )
                        .foregroundStyle(.white)
                        .accessibilityHidden(true)
                    }
                    .buttonStyle(
                        EstiloBotaoMais3D()
                    )
                    .accessibilityElement(
                        children: .ignore
                    )
                    .accessibilityLabel(
                        "Melhorar \(name)"
                    )
                    .accessibilityHint(
                        "Toque duas vezes para responder um quiz e melhorar \(name)"
                    )
                }
            }
        }
    }
}
