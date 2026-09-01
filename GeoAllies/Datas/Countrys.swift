//
//  Countrys.swift
//  GeoAllies
//
//  Created by Lucas Ibiapina on 31/08/26.
//

import SwiftUI
import SwiftData

@Model
class Country {
    var economia : Int = 0
    var militarismo : Int = 0
    var tecnologia : Int = 0

    

    init(economia: Int, militarismo: Int, tecnologia: Int){
        self.economia = economia
        self.militarismo = militarismo
        self.tecnologia = tecnologia
    }
}

//var yourCountry = Country(economia: 0, militarismo: 0, tecnologia: 0)

//var agnólia = Country(economia: 10, militarismo: 3, tecnologia: 1)
//
//var castria = Country(economia: 4, militarismo: 10, tecnologia: 5)
//
//var mourash = Country(economia: 5, militarismo: 7, tecnologia: 10)

