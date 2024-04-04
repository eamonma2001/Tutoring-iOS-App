//
//  ProfileView.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/10/27.
//

import Foundation
import SwiftUI
import URLImage
import SQLite
//
//  ProfileView.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/10/27.
//

import Foundation
import SwiftUI
import URLImage
import SQLite

struct ProfileView: SwiftUI.View {
    @EnvironmentObject var dataModel: DataModel
    @State private var id = ""
    @State private var name = ""
    @State private var primary_email = ""
    @State private var avatar_url = ""
    @State private var isReadOnly = true
    @ObservedObject var loginManager: LoginManager
    
    var body: some SwiftUI.View {
        NavigationView{
            VStack {
                ZStack {
                    Image("profile_bg")
                        .rotationEffect(.degrees(180))
                    
                    if let avatarURL = URL(string: dataModel.currUser.avatar_url ?? "") {
                        URLImage(avatarURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 140, height: 140)
                                .clipShape(Circle())
                        }
                    }
                    else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    }
                }
                .frame(height: 180)
                
                Form {
                    Section(header: Text("User Information")) {
                        HStack {
                            Text("ID: ").bold()
                            TextField("\(String(dataModel.currUser.id))", text: $id)
                        }
                        .disabled(isReadOnly)
                        
                        HStack {
                            Text("Name: ").bold()
                            TextField("\(dataModel.currUser.name)", text: $name)
                        }
                        .disabled(isReadOnly)
                        
                        HStack {
                            Text("Primary Email: ").bold()
                            TextField("\(dataModel.currUser.primary_email)", text: $primary_email)
                        }
                        .disabled(isReadOnly)
                    }
                    
                    Section(footer:
                        HStack {
                        if isReadOnly {
                            ZStack {
                                Rectangle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .background(Rectangle().foregroundColor(Color.clear))
                                    .frame(width: 120, height: 45)

                                Button("Edit") {
                                    isReadOnly = false
                                    print("Edit successful")
                                }
                                .font(.title2)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .cornerRadius(10)
                            .offset(x: -10)
                            
                            Spacer()
                            
                            ZStack {
                                Rectangle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .background(Rectangle().foregroundColor(Color.clear))
                                    .frame(width: 120, height: 45)
                                
                                Button("Log Out") {
                                    dataModel.assignmentEvents = []
                                    loginManager.logOut()
                                    print("Log out successful")
                                }
                                .font(.title2)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .cornerRadius(10)
                            .offset(x: 15)
                        }
                        else {
                            ZStack {
                                Rectangle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .background(Rectangle().foregroundColor(Color.clear))
                                    .frame(width: 120, height: 45)
                                
                                Button("Cancel") {
                                    isReadOnly = true
                                    print("Edit successful")
                                }
                                .font(.title2)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .cornerRadius(10)
                            .offset(x: -10)
                            
                            Spacer()
                            
                            ZStack {
                                Rectangle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .background(Rectangle().foregroundColor(Color.clear))
                                    .frame(width: 120, height: 45)
                                
                                Button("Save") {
                                    isReadOnly = true
                                    dataModel.updateUser(name: name, primary_email: primary_email, avatar_url: avatar_url)
                                    print("Edit successful")
                                }
                                .font(.title2)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 2)
                            )
                            .cornerRadius(10)
                            .offset(x: 15)
                        }
                        
                        }
                    ) {
                        EmptyView()
                    }
                }
            }
            .navigationBarItems(leading: HStack {
                Text("User Profile").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                ProfileBadge().frame(width: 30, height: 30)
            })
            .onAppear {
                name = dataModel.currUser.name
                id = String(dataModel.currUser.id)
                primary_email = dataModel.currUser.primary_email
                //dataModel.listUsers()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        let loginManager = LoginManager()
        ProfileView(loginManager: loginManager)
            .environmentObject(DataModel())
    }
}

struct ProfileBadge: SwiftUI.View {
    var body: some SwiftUI.View {
        GeometryReader { geometry in
            let size = min(geometry.size.width, geometry.size.height)

            ZStack {
                RoundedRectangle(cornerRadius: size * 0.5)
                    .fill(Color.blue)
                    .frame(width: size, height: size)

                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size*0.9, height: size*0.9)
                    .foregroundColor(.white)
            }
        }
    }
}
