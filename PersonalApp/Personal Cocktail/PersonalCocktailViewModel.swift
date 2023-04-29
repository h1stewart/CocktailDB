//
//  PersonalCocktailViewModel.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/25/23.
//


import Foundation
import FirebaseFirestore
import UIKit
import FirebaseStorage

@MainActor

class PersonalCocktailViewModel: ObservableObject{
    @Published var cocktail = PersonalCocktail()
    
    
    func saveCocktail(cocktail: PersonalCocktail) async -> Bool {
        let db = Firestore.firestore()
        
        if let id = cocktail.id { // spot must already exist
            do{
                try await db.collection("cocktails").document(id).setData(cocktail.dictionary)
                print("😎Data updated successfully!")
                return true
            } catch{
                print("😡ERROR: Could not update data in 'cocktails' \(error.localizedDescription)")
                return false
            }
        } else { // no id? this must be a new spot to add
            do{
                let documentRef = try await db.collection("cocktails").addDocument(data: cocktail.dictionary)
                self.cocktail = cocktail // constant
                self.cocktail.id = documentRef.documentID
                print("🐣Data added sucessfully!")
                return true
            } catch {
                print("😡ERROR: Could not create a new cocktail in 'cocktails' \(error.localizedDescription)")
                return false
            }
        }
    }
    func saveImage(personalCocktail: PersonalCocktail, photo: Photo, image: UIImage) async -> Bool {
        guard let cocktailID = personalCocktail.id else{
            print("😡ERROR: personalCocktail.id == nil")
            return false
        }
        var photoName = UUID().uuidString
        if photo.id != nil {
            photoName = photo.id!// update the existing photos description and uses the new info by overwriting it
        }
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(cocktailID)/\(photoName).jpeg")
        
        guard let resizedImage = image.jpegData(compressionQuality: 0.2) else {
            print("😡ERROR: Could not resize image")
            return false
        }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        var imageURLString = ""
        do{
            let _ = try await storageRef.putDataAsync(resizedImage, metadata: metadata)
            print("📸Image Saved!")
            do {
                let imageURL = try await storageRef.downloadURL()
                imageURLString = "\(imageURL)"
            } catch {
                print("😡ERROR: could not get imageIRL after saving image \(error.localizedDescription)")
            }
        } catch {
            print("😡ERROR: Uplading image to FirebaseStorage")
            return false
        }
        
        let db = Firestore.firestore()
        let collectionString = "cocktails/\(cocktailID)/photos"
        
        do{
            var newPhoto = photo
            newPhoto.imageURLString = imageURLString
            try await db.collection(collectionString).document(photoName).setData(newPhoto.dictionary)
            print("😎 Data updated succesfully")
            return true
        } catch {
            print("😡ERROR: Could not update data in 'photos' for cocktailID \(cocktailID)")
            return false
        }
    }
    
    func deleteData (cocktail: PersonalCocktail) async {
        let db = Firestore.firestore()
        
        guard let id = cocktail.id else {
            print("😡 ERROR: id was nil. This should not have happened.")
            return
        }
        
        do {
            try await db.collection("cocktails").document(id).delete()
            print("🗑️ Data successfully removed")
            return
        } catch {
            print("😡 ERROR: Removing document \(error.localizedDescription).")
            return
        }
    }
}

