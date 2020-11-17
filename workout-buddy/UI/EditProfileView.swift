//
//  EditProfileView.swift
//  workout-buddy
//
//  Created by Stepan Arsentjev on 2020-10-03.
//  Copyright © 2020 Stepan Arsentjev. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var bio = ""
    @State private var city = ""
    @State private var state = ""
    @State private var sport = ""
    @State private var weight = ""
    @State private var birthDate = Date()
    @State private var checkDate = Date().addingTimeInterval(-31536000) // Birthdate has to be least 1 year old?
    @State private var sex = ""
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingActionSheet = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            
            HStack {
                
                Text("Cancel")
                    .padding()
                    .onTapGesture(perform: {
                        self.presentationMode.wrappedValue.dismiss()
                    })
                
                Spacer()
                
                Text("Save")
                    .padding()
                    .onTapGesture(perform: {
                        
                        print("\n \n Birth Date: \(self.birthDate)")
                        print("Check Date: \(self.checkDate) \n \n")
                        
                        // Save UserData
                        appState.saveUserData(
                            firstName: self.firstName != "" ? self.firstName : nil,
                            lastName: self.lastName != "" ? self.lastName : nil,
                            bio: self.bio != "" ? self.bio : nil,
                            city: self.city != "" ? self.city : nil,
                            state: self.state != "" ? self.state : nil,
                            sport: self.sport != "" ? self.sport : nil,
                            weight: self.weight != "" ? self.weight : nil,
                            birthDate: self.birthDate < self.checkDate ? self.birthDate : nil,
                            sex: self.sex != "" ? self.sex : nil
                        )
                        
                        
                        self.presentationMode.wrappedValue.dismiss()
                    })
                
                
            }.padding([.leading,.trailing])
            
            Form {
                HStack {
                    ProfileImage().environmentObject(appState)
                        .padding()
                        .onTapGesture(perform: {
                            self.showingActionSheet.toggle()
                        })
                    
                    Spacer()
                    
                    VStack {
                        List {
                            TextField("First Name", text: $firstName)
                            TextField("Last Name", text: $lastName)
                        }
                    }
                }
                
                Section {
                    List {
                        HStack {
                            Text("Bio: ")
                            TextField("Bio", text: $bio)
                        }
                        HStack {
                            Text("City: ")
                            TextField("City", text: $city)
                        }
                        HStack {
                            Text("State: ")
                            TextField("State", text: $state)
                        }
                        HStack {
                            Text("Primary Sport: ")
                            TextField("Primary Sport", text: $sport)
                        }
                    }
                }
                
                Section {
                    List {
                        HStack {
                            Text("Weight (kg): ")
                            TextField("Wight", text: $weight)
                        }
                        DatePicker(selection: $birthDate, in: ...Date(), displayedComponents: .date) {
                            Text("Birth Date")
                        }
                        if #available(iOS 14.0, *) {
                            HStack {
                                Text("Sex")
                                
                                Spacer()
                                
                                Menu {
                                    Button(action: { self.sex = "Male" }) {
                                        Text("Male")
                                    }
                                    Button(action: { self.sex = "Female" }) {
                                        Text("Female")
                                    }
                                } label: {
                                    if (self.sex != "") {
                                        Text("\(self.sex)")
                                    } else {
                                        Text("Sex")
                                    }
                                }
                            }
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
            }
        }.onAppear {
            self.firstName = self.appState.userData.user.firstName ?? ""
            self.lastName = self.appState.userData.user.lastName ?? ""
            self.bio = self.appState.userData.user.bio ?? ""
            self.city = self.appState.userData.user.city ?? ""
            self.state = self.appState.userData.user.state ?? ""
            self.sport = self.appState.userData.user.sport ?? ""
            self.weight = self.appState.userData.user.weight != nil ? String(describing: self.appState.userData.user.weight!) : ""
            self.birthDate = self.appState.userData.user.birthDate ?? Date()
            self.sex = self.appState.userData.user.sex ?? ""
        }.sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(sourceType: self.pickerSourceType, image: self.$inputImage)
        }.actionSheet(isPresented: $showingActionSheet, content: {
            
            
            ActionSheet(title: Text("Update Profile Image"), buttons: [
                .default(Text("Take Picture")) {
                    self.pickerSourceType = .camera
                    self.showingImagePicker = true
                },
                .default(Text("Select From Library")) {
                    self.pickerSourceType = .photoLibrary
                    self.showingImagePicker = true
                },
                .cancel()
            ])
        })
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        self.appState.userData.user.profileImage = inputImage
        
        self.appState.updateUserImage()
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView().environmentObject(AppState())
    }
}
