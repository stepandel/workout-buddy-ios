//
//  LoginView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-09-28.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userData: UserData
    
    @State private var email = ""
    @State private var password = ""
    @State private var rePassword = ""
    @State private var isSignup = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Text("Sylach")
                .font(.largeTitle)
                .foregroundColor(.black)
                .padding([.top, .bottom], 40)
            
            VStack {
                TextField("Email", text: self.$email)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(20.0)
                
                SecureField("Password", text: self.$password)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(20.0)
                
                if isSignup {
                    SecureField("Re-Password", text: self.$rePassword)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(20.0)
                }
                
            }.padding([.leading, .trailing], 28)
            
            Button(action: {
                
                if (self.isSignup) {
                    
                    // TODO: - email & password validation
                    
                    userData.saveNewUser(email: self.email, pass: self.password)
                    
                    // Dismiss login screen
                    
                } else {
                    print("Signing in...")
                    
                    userData.checkUser(email: self.email, pass: self.password)
                }
                
                
            }) {
                
                if isSignup {
                    Text("Sign up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.gray)
                        .cornerRadius(12.0)
                    
                } else {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.gray)
                        .cornerRadius(12.0)
                }
            }.padding(.top, 40.0)
            
            Button(action: {self.isSignup.toggle()}) {
                if isSignup {
                    Text("Already have an account? Log in")
                } else {
                    Text("Don't have account? Sign up")
                }
                
            }.padding([.top, .bottom], 40)
            
            Spacer()
        }.background(Color(#colorLiteral(red: 0.8980392157, green: 0.9333333333, blue: 1, alpha: 1)).edgesIgnoringSafeArea(.all))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserData())
    }
}
