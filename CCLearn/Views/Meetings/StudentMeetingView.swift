//
//  StudentMeetingView.swift
//  CCLearn
//
//  Created by Eamon Ma on 11/27/23.
//

import Foundation
import SwiftUI

struct StudentMeetingView: View {
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        NavigationView {
            List(dataModel.tutors) { tutor in
                NavigationLink(destination: TutorDetail(tutor: tutor)) {
                    Text(tutor.name)
                }
            }
            .navigationTitle("Tutor List")
        }
        .onAppear {
            dataModel.fetchTimeSlotsAndUsers()
        }
    }
}

#Preview {
    StudentMeetingView()
        .environmentObject(DataModel())
}
