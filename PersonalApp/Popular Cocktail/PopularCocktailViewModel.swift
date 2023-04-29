//
//  PopularCocktailViewModel.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/25/23.
//

import Foundation
@MainActor

class PopularCocktailViewModel: ObservableObject{
    
    private struct Returned: Codable {
        var drinks: [Cocktail]
    }
    
    @Published var cocktailArray: [Cocktail] = []
    var urlString = ""
    var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    var count = 0
    
    func getData(letter: String) async { //dont cause the rest of the app to freeze or wait
        var letter = letter
        let urlString = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=\(letter)"
        print("🕸️We are accessing the url \(urlString)")
        //convert urlString to a special URL type
        guard let url = URL(string: urlString) else {
            print("😡ERROR: Could not create a URL from \(urlString)")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url) //try to decode json data into our own data structures
            guard let returned = try? JSONDecoder().decode(Returned.self, from: data) else{
                print("😡JSON ERROR: Could not decode returned JSON data")
                return
            }
            print("😎Json returned! \(returned.drinks)")
            self.cocktailArray += returned.drinks
            
        } catch {
            print("😡ERROR: Could not use a URL at \(urlString) to get data and response")
        }
    }
    func loadNextLetter() async {
        for part in alphabet {
            await getData(letter: part)
        }
    }
}


