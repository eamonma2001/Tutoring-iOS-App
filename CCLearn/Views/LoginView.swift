//
//  LoginView.swift
//  CCLearn
//
//  Created by Eamon Ma on 11/27/23.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @EnvironmentObject var dataModel: DataModel
    @ObservedObject var loginManager: LoginManager
    
    @State private var isActionSheetPresented = false
    @State private var isStudentOptionPresented = false
    @State private var isTaOptionPresented = false
    
    // Function to simulate login
    func simulateLogin(with token: String) {
        dataModel.userToken = token
        dataModel.getAllInfo()
        loginManager.login()
    }
    
    var body: some View {
        ZStack { // Wrap VStack with ZStack
            Image("login_screen")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
                .opacity(0.5)
            
            VStack {
                Image("calendar") // Replace "AppIcon" with the actual name of your app icon asset
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                
                Text("CCLearn")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.95, blue: 0.6),
                                     Color(red: 1.0, green: 0.85, blue: 0.5),
                                     Color(red: 1.0, green: 0.7, blue: 0.3),
                                     Color(red: 1.0, green: 0.55, blue: 0.2)
                                    ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .shadow(color: .gray, radius: 3, x: 1, y: 1)
                    .padding(.top, 60)
                
                Text("Canvas based Meeting Management App")
                    .padding(.top, 1)
                    .padding(.bottom, 100)
                
                Button(action: {
                    isTaOptionPresented = false
                    isStudentOptionPresented = true
                    isActionSheetPresented = true
                }) {
                    Text("Login as Student")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.orange)
                        .cornerRadius(20)
                }
                .padding(.bottom, 20)
                
                Button(action: {
                    isStudentOptionPresented = false
                    isTaOptionPresented = true
                    isActionSheetPresented = true
                }) {
                    Text("Login as TA")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 200)
                        .background(Color.yellow)
                        .cornerRadius(20)
                }
            }
        }
        .actionSheet(isPresented: $isActionSheetPresented) {
            if isStudentOptionPresented {
                return ActionSheet(title: Text("Student Options"), buttons: [
                    .default(Text("Login as Student")) {
                        dataModel.isCurrUserStudent = true
                        simulateLogin(with: studentAccessToken)
                    },
                    .cancel()
                ])
            } else {
                return ActionSheet(title: Text("TA Options"), buttons: [
                    .default(Text("Login as TA 1")) {
                        dataModel.isCurrUserStudent = false
                        simulateLogin(with: ta1AccessToken)
                        print(dataModel.currUser)
                    },
                    .default(Text("Login as TA 2")) {
                        dataModel.isCurrUserStudent = false
                        simulateLogin(with: ta2AccessToken)
                        print(dataModel.currUser)
                    },
                    .cancel()
                ])
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataModel())
}


class LoginManager : ObservableObject {
    @Published var isLoggedIn = false
    
    func login() {
        self.isLoggedIn = true
    }
    func logOut() {
        self.isLoggedIn = false
    }
}
