//
//  ReminderRow.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/10/31.
//

import Foundation
import SwiftUI

struct ReminderRow: View {

    var reminder: ReminderEvent

    // Computed property to format the date
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let date = dateFormatter.date(from: reminder.end_at) {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MM-dd"
            return newDateFormatter.string(from: date)
        } else {
            return "Invalid date format"
        }
    }
    
    var isToday: Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return Calendar.current.isDate(dateFormatter.date(from: reminder.end_at) ?? Date(), inSameDayAs: Date())
    }
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(reminder.title)
                    .font(.headline)
                Text(reminder.context_name ?? "")
                    .font(.subheadline)
                    .lineLimit(nil) // Allow unlimited lines
                    .truncationMode(.tail)
            }
            Spacer()
            Text(formattedDate)
        }
    }
}
