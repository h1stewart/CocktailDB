//
//  ContentView.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/23/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct PopularCocktailListView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var popularVM = PopularCocktailViewModel()
    @State private var personalSheetIsPresented = false
    @State private var path = NavigationPath()
    @State private var loginView = false
    @State private var letter = ""
    
    var body: some View {
        NavigationStack {
            HStack {
                Text("Search for cocktails by letter:")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
                TextField("Search by letter", text: $letter)
                    .padding()
                    .autocapitalization(.none)
                    .onSubmit {
                        Task {
                            await popularVM.getData(letter: letter)
                        }
                    }
            }
            .padding()
            List(popularVM.cocktailArray) { cocktail in
                LazyVStack{
                    NavigationLink {
                        PopularDetailView(popularCocktail: cocktail)
                    } label: {
                        Text(cocktail.strDrink)
                    }
                }
            }
            .navigationTitle("Popular Cocktails")
            .listStyle(.plain)
            .font(.title2)
            
            .navigationBarTitleDisplayMode(.automatic)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out"){
                        do{
                            try Auth.auth().signOut()
                            print("🪵Log out successful!")
                            dismiss()
                            loginView = true
                        } catch{
                            print("😡ERROR: Could not sign out")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("To Personal Cocktails") {
                        personalSheetIsPresented.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("Pink"))
                }
                ToolbarItem(placement: .status) {
                    Text("\(popularVM.cocktailArray.count) Cocktails")
                }
//                ToolbarItem(placement: .bottomBar) {
//                    Button {
//                        Task{
//                            await popularVM.loadAll()
//                        }
//                    } label: {
//                        Text("Load All")
//                    }
//                }
            }
        }
        .padding()

        .fullScreenCover(isPresented: $personalSheetIsPresented) {
            PersonalCocktailListView()
        }
        .fullScreenCover(isPresented: $loginView) {
            LoginView()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PopularCocktailListView()
    }
}

//TODO: add a way to save a cocktail to your personal recipes
