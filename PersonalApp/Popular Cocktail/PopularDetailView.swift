//
//  PopularDetailView.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/25/23.
//

import SwiftUI

struct PopularDetailView: View {
    @EnvironmentObject var popularVM: PopularCocktailViewModel
    let popularCocktail: Cocktail
    var body: some View {
        NavigationStack{
            VStack (alignment: .center){
                HStack {
                    Text("Name: ")
                        .bold()
                    Spacer()
                    Text(popularCocktail.strDrink)
                }
                .font(.title)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color("Pink"))
                    .padding(.bottom)
                
                HStack{
                    Text("Glass Type: ")
                        .bold()
                    Spacer()
                    Text(popularCocktail.strGlass)
                }
                
                HStack {
                    Text("Instructions: ")
                        .bold()
                    Spacer()
                    Text(popularCocktail.strInstructions)
                        .multilineTextAlignment(.trailing)
                }
                Spacer()
                HStack {
                    Text("Ingredients: ")
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("1. \(popularCocktail.strIngredient1)")
                        Text("2. \(popularCocktail.strIngredient2)")
                    }
                    
                }
                Spacer()
                AsyncImage(url: URL(string: popularCocktail.strDrinkThumb)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 15)
                        .animation(.default, value: image)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                }
                .padding(.horizontal)
                Spacer()
            }
            .padding()
        }
    }
}

struct PopularDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PopularDetailView(popularCocktail: Cocktail(strDrink: "A1", strGlass: "Cocktail glass", strInstructions: "Pour all ingredients into a cocktail shaker, mix and serve over ice into a chilled glass.", strDrinkThumb: "https://www.thecocktaildb.com/images/media/drink/2x8thr1504816928.jpg"))
    }
}
