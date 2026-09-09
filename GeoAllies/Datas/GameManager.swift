//
//  GameManager.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import Observation
import SwiftUI

@Observable
class GameManager {
    var yourCountry: Country
    
    var agnolia: Country
    var cuastria: Country
    var lucacia: Country
    
    var aliados: [Country] = []
    
    var answeredQuestions: Set<String> = []
    
    var venceuJogo: Bool {
        
        aliados.contains(where: {
            $0.id == agnolia.id
        })
        &&
        aliados.contains(where: {
            $0.id == cuastria.id
        })
        &&
        aliados.contains(where: {
            $0.id == lucacia.id
        })
    }
    
    init() {
        
        self.yourCountry = Country(
            economia: 0,
            militarismo: 0,
            tecnologia: 0
        )
        
        self.agnolia = Country(
            economia: 6,
            militarismo: 3,
            tecnologia: 5
        )
        
        self.cuastria = Country(
            economia: 5,
            militarismo: 8,
            tecnologia: 3
        )
        
        self.lucacia = Country(
            economia: 4,
            militarismo: 3,
            tecnologia: 9
        )
    }
    
    
    func aliar(_ country: Country) {
        
        if !aliados.contains(where: {
            $0.id == country.id
        }) {
            
            aliados.append(country)
            
            print("País aliado!")
            print("Total de aliados: \(aliados.count)")
        }
    }
}
