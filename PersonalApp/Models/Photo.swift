//
//  Photo.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/27/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Photo: Identifiable, Codable {
    @DocumentID var id: String?
    var imageURLString = ""
    var reviewer = Auth.auth().currentUser?.email ?? ""
    var postedOn = Date()
    
    var dictionary: [String:Any]{
        return ["imageURLString": imageURLString, "reviewer": reviewer, "postedOn": Timestamp(date: Date())]
    }
}

