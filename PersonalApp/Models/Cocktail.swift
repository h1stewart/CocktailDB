//
//  Cocktail.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/26/23.
//

import Foundation

struct Cocktail: Codable, Identifiable, Hashable {
    let id = UUID().uuidString
    var strDrink = ""
    var strGlass = ""
    var strInstructions = ""
    var strDrinkThumb = ""
    var strIngredient1 = ""
    var strIngredient2 = ""
    
    
    enum CodingKeys: String, CodingKey {
        case strDrink, strGlass, strInstructions, strDrinkThumb, strIngredient1, strIngredient2
    }
}
