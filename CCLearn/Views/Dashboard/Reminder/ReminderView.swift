//
//  ReminderView.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/10/31.
//

import Foundation
import SwiftUI

struct ReminderView: View {
    @EnvironmentObject var dataModel: DataModel
    let rowColors: [Color] = [
        Color(red: 255 / 255, green: 182 / 255, blue: 193 / 255), // Light Pink
        Color(red: 173 / 255, green: 216 / 255, blue: 230 / 255), // Light Blue
        Color(red: 240 / 255, green: 230 / 255, blue: 140 / 255), // Khaki
        Color(red: 240 / 255, green: 128 / 255, blue: 128 / 255), // Light Coral
        Color(red: 216 / 255, green: 191 / 255, blue: 216 / 255)  // Thistle
    ]
    @Binding var searchText: String
    var filteredReminders: [ReminderEvent] {
        if searchText.isEmpty {
            return dataModel.reminderEvents
        } else {
            return dataModel.reminderEvents.filter { reminder in
                (reminder.title + (reminder.context_name ?? "")).lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    var body: some View {
        ForEach(filteredReminders.indices, id: \.self) { index in
            ReminderRow(reminder: filteredReminders[index])
                .listRowBackground(rowColors[index % rowColors.count])
                .padding(.bottom, 5)
        }
    }
}

//struct ReminderView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReminderView()
//            .environmentObject(DataModel())
//            .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
