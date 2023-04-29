//
//  PersonalCocktailListView.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/25/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct PersonalCocktailListView: View {
    @FirestoreQuery(collectionPath: "cocktails") var cocktails: [PersonalCocktail]
    @State private var sheetIsPresented = false
    @Environment(\.dismiss) private var dismiss
    @StateObject var personalVM = PersonalCocktailViewModel()
    @State private var path = NavigationPath()
    @State private var popularSheetIsPresented = false
    @State private var loginView = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(cocktails) { cocktail in
                    NavigationLink {
                        PersonalDetailView(personalCocktail: cocktail)
                    } label: {
                        Text(cocktail.name)
                    }
                }
                .onDelete { indexSet in
                    guard let index = indexSet.first else {return}
                    Task {
                        await personalVM.deleteData(cocktail: cocktails[index])
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("My Personal Recipes:")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button{
                        sheetIsPresented.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
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
                ToolbarItem(placement: .bottomBar) {
                    Button("Go to Popular Recipes") {
                        popularSheetIsPresented.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("Pink"))
                }
            }
            
        }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $popularSheetIsPresented) {
            PopularCocktailListView()
        }
        .sheet(isPresented: $sheetIsPresented) {
            NavigationStack{
                PersonalDetailView(personalCocktail: PersonalCocktail())
            }
        }
        .fullScreenCover(isPresented: $loginView) {
            LoginView()
        }
    }
}

struct PersonalCocktailListView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalCocktailListView()
    }
}

//TODO: fix the link to go to popular cocktail list

