//
//  LoginView.swift
//  PersonalApp
//
//  Created by Hailey Stewart on 4/25/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    enum Field {
        case email, password
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var buttonDisabled = true
    @State private var presentSheet = false
    @State private var cocktailSheet = false
    
    @FocusState private var focusField: Field?
    
    var body: some View {
        VStack{
            Text("Cocktails!")
                .bold()
                .font(Font.custom("Sans Serif", size: 48))
                .foregroundColor(Color("Oj"))
            Spacer()
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding()
            
            Spacer()
            
            Group{
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .submitLabel(.next)
                    .focused($focusField, equals: .email)
                    .onSubmit {
                        focusField = .password
                    }
                    .onChange(of: email) { _ in
                        enableButton()
                    }
                
                SecureField("Password", text: $password)
                    .textInputAutocapitalization(.never)
                    .submitLabel(.done)
                    .focused($focusField, equals: .password)
                    .onSubmit {
                        focusField = .email
                    }
                    .onChange(of: password) { _ in
                        enableButton()
                    }
            }
            
            .textFieldStyle(.roundedBorder)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(.gray.opacity(0.5), lineWidth: 2)
            }
            .padding(.horizontal)
            
            HStack{
                Button {
                    register()
                } label: {
                    Text("Sign Up")
                }
                .padding(.trailing)
                Button {
                    login()
                } label: {
                    Text("Log In")
                }
                .padding(.leading)
            }
            .disabled(buttonDisabled)
            .buttonStyle(.borderedProminent)
            .tint(Color("Pink"))
            .font(.title2)
            .padding(.top)
            
        }
        .alert(alertMessage, isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .onAppear{
            if Auth.auth().currentUser != nil {
                print("🪵 Login successful!")
                cocktailSheet = true
            }
        }
        .fullScreenCover(isPresented: $cocktailSheet) {
            PopularCocktailListView()
        }
        .fullScreenCover(isPresented: $presentSheet) {
            AgeView()
        }
    }
    
    func enableButton (){
        let emailIsGood = email.count >= 6 && email.contains("@")
        let passwordIsGood = password.count >= 6
        buttonDisabled = !(emailIsGood && passwordIsGood)
    }
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error{
                print("😡 SIGN-UP ERROR: \(error.localizedDescription)")
                alertMessage = "SIGN-UP ERROR: \(error.localizedDescription)"
                showingAlert = true
            }
            else {
                print("😎 Registration success!")
                presentSheet = true
            }
        }
    }
    
    func login(){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                print("😡 LOGIN ERROR: \(error.localizedDescription)")
                alertMessage = "LOGIN ERROR: \(error.localizedDescription)"
                showingAlert = true
            }
            else {
                print("🪵 Login successful!")
                presentSheet = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
