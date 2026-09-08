//
//  Country.swift
//  GeoAllies
//
//  Created by Bianca Moura on 05/09/26.
//

import SwiftUI
import SwiftData

@Model
class Country {
    var id: UUID = UUID()
    var economia: Int = 0
    var militarismo: Int = 0
    var tecnologia: Int = 0
    
    // Novas variáveis para salvar o estado das alianças
    var aliouAgnolia: Bool = false
    var aliouCaustria: Bool = false
    var aliouLucacia: Bool = false
    
    init(economia: Int, militarismo: Int, tecnologia: Int) {
        self.economia = economia
        self.militarismo = militarismo
        self.tecnologia = tecnologia
    }
}
