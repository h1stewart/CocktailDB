//
//  PhotoView.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/27/23.
//

import SwiftUI
import Firebase

struct PhotoView: View {
    @EnvironmentObject var personalVM: PersonalCocktailViewModel
    @State private var photo = Photo()
    var uiImage: UIImage
    var personalCocktail: PersonalCocktail
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack{
                Spacer()
                
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                
                Spacer()
                
                Text("by: \(photo.reviewer) on: \(photo.postedOn.formatted(date: .numeric, time: .omitted))")
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding()
            .toolbar{
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Button("Save") {
                        Task{
                            let success = await personalVM.saveImage(personalCocktail: personalCocktail, photo: photo, image: uiImage)
                            if success{
                                dismiss()
                            }
                        }
                    }
                }
                
            }
        }
    }
}

struct PhotoView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoView(uiImage: UIImage(named: "cocktail") ?? UIImage(), personalCocktail: PersonalCocktail())
            .environmentObject(PersonalCocktailViewModel())
    }
}
