
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
    
    let onImprove: () -> Void
    
    
    // Calcula quanto da barra será preenchido
    private var progress: CGFloat {
        
        CGFloat(value) / CGFloat(maximumValue)
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
                .system(
                    size: 17,
                    weight: .bold,
                    design: .rounded
                )
            )
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                type.color
            )
            .clipShape(Capsule())
            
            
            // MARK: - Barra + botão
            
            HStack(spacing: 14) {
                
                VStack(
                    alignment: .trailing,
                    spacing: 4
                ) {
                    
                    GeometryReader { geometry in
                        
                        ZStack(alignment: .leading) {
                            
                            // Fundo da barra
                            Capsule()
                                .fill(
                                    Color.gray.opacity(0.12)
                                )
                            
                            
                            // Progresso
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
                    
                    
                    // MARK: Valor
                    
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
                
                
                // MARK: - Botão +
                
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
