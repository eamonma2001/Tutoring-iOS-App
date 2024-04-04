//
//  CCLearnApp.swift
//  CCLearn
//
//  Created by Brandon C. on 2023/10/27.
//

import SwiftUI
import Amplify
import AmplifyPlugins

@main
struct CCLearnApp: App {
    @StateObject private var dataModel = DataModel()
    
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
        }
    }
    
    
}
