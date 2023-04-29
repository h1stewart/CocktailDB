//
//  PersonalDetailView.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/25/23.
//

import SwiftUI
import FirebaseFirestoreSwift
import PhotosUI

struct PersonalDetailView: View {
    enum Field {
        case name, ingredients, instructions
    }
    @FirestoreQuery(collectionPath: "cocktails") var photos: [Photo]
    @State var personalCocktail: PersonalCocktail
    @State var buttonDisabled = true
    @EnvironmentObject var personalVM: PersonalCocktailViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var uiImageSelected = UIImage()
    @State private var showPhotoViewSheet = false
    
    @FocusState private var focusField: Field?
    
    var body: some View {
        NavigationStack{
            HStack{
                Text("🍸")
                Spacer()
                Text("Add your Personal Cocktail Recipe!")
                    .multilineTextAlignment(.center)
                Spacer()
                Text("🍸")
            }
            .padding()
            .font(.largeTitle)
            .foregroundColor(.white)
            .background(Color("Pink"))
            
            VStack (alignment: .leading){
                
                Text("Enter the name of your drink:")
                    .bold()
                TextField("Name", text: $personalCocktail.name)
                    .font(.title2)
                    .focused($focusField, equals: .name)
                    .onSubmit {
                        focusField = .ingredients
                    }
                
                Text("Enter the Ingredients required:")
                    .bold()
                TextField("Ingredients", text: $personalCocktail.ingredients)
                    .font(.title2)
                    .focused($focusField, equals: .ingredients)
                    .onSubmit {
                        focusField = .instructions
                    }
                
                Text("Enter the instructions:")
                    .bold()
                TextField("Instructions", text: $personalCocktail.instructions)
                    .font(.title2) //Use Text view instead and limit from ntoes and ToDo List apps
                    .focused($focusField, equals: .instructions)
                    .onSubmit {
                        focusField = nil
                    }
                PhotoScrollView(personalCocktail: personalCocktail, photos: photos)
                
                HStack{
                    Text("Add an Image?")
                    Spacer()
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Image(systemName: "photo")
                        Text("Photo")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("Pink"))
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data){
                                        uiImageSelected = uiImage
                                        print("📸 Successfully saved image!")
                                        showPhotoViewSheet = true
                                    }
                                }
                            }  catch {
                                print("😡ERROR: selecting image failed \(error.localizedDescription)")
                            }
                        }
                    }

                }
            }
            .onAppear {
                $photos.path = "cocktails/\(personalCocktail.id ?? "")/photos"
                print("photos.path = \($photos.path)")
            }
            .padding()
            Spacer()
                
        }
        
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button("Cancel"){
                    dismiss()
                }
                .tint(Color("Pink"))
                .buttonStyle(.bordered)
            }
            ToolbarItem(placement: .bottomBar) {
                Button("Save") {
                    Task {
                        let success = await personalVM.saveCocktail(cocktail: personalCocktail)
                        if success{
                            dismiss()
                        } else {
                            print("😡 DANG! Error saving!")
                        }
                    }
                    dismiss()
                }
                .tint(Color("Pink"))
                .buttonStyle(.bordered)
            }
        }
        .sheet(isPresented: $showPhotoViewSheet) {
            PhotoView(uiImage: uiImageSelected, personalCocktail: personalCocktail)
        }
    }
}

//TODO: Fix back button to go back to personal cocktail list
//TODO: add place where there are saved images



struct PersonalDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            PersonalDetailView(personalCocktail: PersonalCocktail())
                .environmentObject(PersonalCocktailViewModel())
        }
    }
}
