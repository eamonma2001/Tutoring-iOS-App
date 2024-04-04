//
//  ContentView.swift
//  CCLearn
//
//  Created by Brandon C. on 2023/10/27.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataModel: DataModel
    @StateObject var loginManager = LoginManager()
    
    var body: some View {
        if loginManager.isLoggedIn {
            TabView() {
                DashboardView(loginManager: loginManager)
                    .environmentObject(dataModel)
                    .tabItem {
                        Label("Dashboard", systemImage: "house")
                    }
                    .tag(0)
                
                if dataModel.isCurrUserStudent {
                    StudentMeetingView()
                        .environmentObject(dataModel)
                        .tabItem {
                            Label("Meetings", systemImage: "calendar.badge.clock")
                        }
                        .tag(1)
                }
                else {
                    MeetingView()
                        .environmentObject(dataModel)
                        .tabItem {
                            Label("Meetings", systemImage: "calendar.badge.clock")
                        }
                        .tag(1)
                }
                
                CalendarView()
                    .environmentObject(dataModel)
                    .tabItem {
                        Label("Calendar", systemImage: "calendar")
                    }
                    .tag(2)
                ProfileView(loginManager: loginManager)
                    .environmentObject(dataModel)
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                    .tag(3)
            }
        } else {
            LoginView(loginManager: loginManager)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.move(edge: .leading))
        }
    }
}
