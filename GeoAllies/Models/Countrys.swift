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

