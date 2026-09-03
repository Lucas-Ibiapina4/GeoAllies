
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


struct ProgressBar: View {

    let name: String
    let icon: String
    let value: Int
    let maximumValue: Int
    let type: ProgressBarType

    // Define se o botão + aparece
    var showImproveButton: Bool = true

    let onImprove: () -> Void


    private var progress: CGFloat {
        guard maximumValue > 0 else {
            return 0
        }

        return min(
            CGFloat(value) / CGFloat(maximumValue),
            1
        )
    }


    var body: some View {

        VStack(
            alignment: .leading,
            spacing: 8
        ) {

            Label(
                name,
                systemImage: icon
            )
            .font(
                .system(
                    size: 17,
                    weight: .bold,
                    design: .rounded
                )
            )
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(type.color)
            .clipShape(Capsule())


            HStack(spacing: 14) {

                VStack(
                    alignment: .trailing,
                    spacing: 4
                ) {

                    GeometryReader { geometry in

                        ZStack(alignment: .leading) {

                            Capsule()
                                .fill(
                                    Color.gray.opacity(0.12)
                                )

                            Capsule()
                                .fill(type.color)
                                .frame(
                                    width:
                                        geometry.size.width
                                        * progress
                                )
                        }
                    }
                    .frame(height: 24)


                    Text(
                        "\(value)/\(maximumValue)"
                    )
                    .font(
                        .system(
                            size: 14,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.black)
                }


                // O botão só aparece no próprio país
                if showImproveButton {

                    Button {
                        onImprove()
                    } label: {

                        Image(systemName: "plus")
                            .font(
                                .system(
                                    size: 21,
                                    weight: .heavy
                                )
                            )
                            .foregroundStyle(.white)
                            .frame(
                                width: 40,
                                height: 40
                            )
                            .background(
                                Color(
                                    red: 137 / 255,
                                    green: 180 / 255,
                                    blue: 112 / 255
                                )
                            )
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}
