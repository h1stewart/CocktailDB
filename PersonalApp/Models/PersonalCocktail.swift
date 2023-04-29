//
//  PersonalCocktail.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/25/23.
//

import Foundation
import FirebaseFirestoreSwift

struct PersonalCocktail: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var name = ""
    var ingredients = ""
    var instructions = ""
    
    var dictionary: [String: Any] {
        return ["name": name, "ingredients": ingredients, "instructions": instructions]
    }
}
