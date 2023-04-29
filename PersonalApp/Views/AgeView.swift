//
//  AgeView.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/27/23.
//

import SwiftUI

struct AgeView: View {
    @State private var enteredAge = ""
    @State private var path = NavigationPath()
    @State private var cocktailSheetIsPresented = false
    @State private var underageSheetIsPresented = false
    
    var body: some View {
        
        NavigationStack (path: $path) {
            VStack(spacing: 0) {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(0.7)
                    .foregroundColor(.red)
                Text("Alert!")
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .font(Font.system(size: 48))
                
                Spacer()
                Text("Minimum Age Required: 21")
                    .font(.title)
                Spacer()
                TextField("Enter age here", text: $enteredAge)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.5))
                    }
                    .padding(.horizontal, 6)
                Spacer()
            }
            .toolbar{
                ToolbarItem (placement: .status){
                    Button{
                        displayAge()
                    } label: {
                        Text("Enter")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    .disabled(enteredAge.isEmpty)
                }
            }
            .fullScreenCover(isPresented: $cocktailSheetIsPresented) {
                PersonalCocktailListView()
            }
            .fullScreenCover(isPresented: $underageSheetIsPresented) {
                UnderageView()
            }
            .padding()
        }
    }
    func displayAge() {
        let ageIsGood = enteredAge.count > 0
        if ageIsGood {
            var age = Int(enteredAge)!
            if age >= 21 {
                cocktailSheetIsPresented = true
            } else {
                underageSheetIsPresented = true
            }
        }
    }
}

struct AgeView_Previews: PreviewProvider {
    static var previews: some View {
        AgeView()
    }
}
