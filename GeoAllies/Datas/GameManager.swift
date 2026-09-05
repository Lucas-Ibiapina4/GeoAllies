//
//  GameManager.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import Observation
import SwiftUI

//avisa quando os dados mudam
@Observable
//game manager que permite controlar melhor os fluxos do jogo alternando entre os estados de aliança e dados específicos dos países
class GameManager {
    var yourCountry: Country
    var agnolia: Country
    var cuastria: Country
    var lucacia: Country
    var aliados : Array<Country> = []
    
    //setamento dos valores do pilares de cada país
    init() {
        self.yourCountry = Country(economia: 0, militarismo: 0, tecnologia: 0)
        self.agnolia = Country(economia: 5, militarismo: 1, tecnologia: 1)
        self.cuastria = Country(economia: 1, militarismo: 5, tecnologia: 1)
        self.lucacia = Country(economia: 1, militarismo: 1, tecnologia: 5)
    }
    
    func aliar(_ country: Country) {

        if !aliados.contains(where: { $0.id == country.id }) {
            aliados.append(country)
        }
    }
}
