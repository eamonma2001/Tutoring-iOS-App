//
//  CalendarEventDetailView.swift
//  CCLearn
//
//  Created by Eamon Ma on 11/27/23.
//

import SwiftUI

struct CalendarEventDetailView: View {
    var event: CalendarEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Title: \(event.title)")
                .font(.title)
            
            Text("Starts at: \(event.start_at)").font(.title3)
            Text("Ends at: \(event.end_at)").font(.title3)
            Text("Location Name: \(event.location_name ?? "Default Location")").font(.title3)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .cornerRadius(10)
        .padding(20)
    }
}

struct CalendarEventView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleEvent = CalendarEvent(id: "1", title: "Sample Event", start_at: "2023-01-01 10:00 AM", end_at: "2023-01-01 12:00 PM")
        return CalendarEventDetailView(event: sampleEvent)
            .previewLayout(.sizeThatFits)
    }
}
