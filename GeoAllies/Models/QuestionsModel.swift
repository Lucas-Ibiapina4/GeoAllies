//
//  QuestionsModel.swift
//  GeoAllies
//
//  Created by Bianca Moura on 01/09/26.
//
import Foundation
import SwiftUI

struct QuestionsModel: Codable, Hashable {
    var id: UUID = UUID()
    
    let pilar: String
    let question: String
    let options: [String]
    let answer: String
    
    enum CodingKeys: String, CodingKey {
        case pilar
        case question
        case options
        case answer
    }
}

extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Não foi possível encontrar \(file) no projeto.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Não foi possível carregar \(file) do projeto.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Falha ao decodificar \(file). Verifique se o JSON combina com sua Struct.")
        }
        
        return loadedData
    }
}
