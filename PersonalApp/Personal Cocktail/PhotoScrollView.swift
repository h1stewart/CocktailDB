//
//  PhotoScrollView.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/27/23.
//

import SwiftUI

struct PhotoScrollView: View {

    @State var personalCocktail: PersonalCocktail
    @State private var showPhotoViewerView = false
    @State private var uiImage = UIImage()
    @State private var selectedPhoto = Photo()
    var photos: [Photo]


    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack (spacing: 4){
                ForEach(photos) { photo in
                    let imageURL = URL(string: photo.imageURLString) ?? URL(string: "")

                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 80, height: 80)
                            .clipped()
                            .onTapGesture {
                                let renderer = ImageRenderer(content: image)
                                selectedPhoto = photo
                                uiImage = renderer.uiImage ?? UIImage()
                                showPhotoViewerView.toggle()
                            }

                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }

                }
            }
        }
        .frame(height: 80)
        .padding(.horizontal, 4)
        .sheet(isPresented: $showPhotoViewerView) {
            PhotoView(uiImage: uiImage, personalCocktail: personalCocktail)
        }
    }
}

struct SpotDetailPhotoScrollView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoScrollView(personalCocktail: PersonalCocktail(), photos: [Photo(imageURLString: "https://firebasestorage.googleapis.com:443/v0/b/cocktailproject-65543.appspot.com/o/erOVPchVmz71SCethLon%2F80583E1F-ACA3-43B7-A0EF-56640AA27F79.jpeg?alt=media&token=8e70dcf4-d1ec-4c2a-af40-c71fe504515e")])
    }
}
