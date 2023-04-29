//
//  UnderageView.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/27/23.
//

import SwiftUI
import AVFAudio
import Firebase
import FirebaseFirestoreSwift

struct UnderageView: View {
    @State private var audioPlayer: AVAudioPlayer!
    @State private var soundName = "underage"
    @Environment(\.dismiss) private var dismiss
    @State private var sheetIsPresented = false
    
    var body: some View {

        NavigationStack {
            VStack{
                Image("unicorn")
                    .resizable()
                    .scaledToFit()
                    .onAppear() {
                        playSound(soundName: soundName)
                    }
                HStack{
                    Image(systemName: "sparkles")
                        .foregroundColor(Color("Purple"))
                    Text("Uh Oh! You're Underage! Sign out.")
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("Pink"))
                    Image(systemName: "sparkles")
                        .foregroundColor(Color("Purple"))
                }
                .font(.title)
                .fontWeight(.heavy)
                
            }
            .toolbar{
                ToolbarItem(placement: .status) {
                    Button("Sign Out"){
                        do{
                            try Auth.auth().signOut()
                            print("🪵Log out successful!")
                            sheetIsPresented = true
                        } catch{
                            print("😡ERROR: Could not sign out")
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("Pink"))
                }
            }
        }
        .fullScreenCover(isPresented: $sheetIsPresented) {
            LoginView()
        }
    }
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else{
            print("😡 Could not read file name \(soundName)")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
}

struct UnderageView_Previews: PreviewProvider {
    static var previews: some View {
        UnderageView()
    }
}
