//
//  MeetingView.swift
//  CCLearn
//
//  Created by Eamon Ma on 11/27/23.
//

import Foundation
import SwiftUI
import Amplify

struct MeetingView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedDate = Date()
    @State var ifFiltered: Bool = false
    @State var ifFuture: Bool = true
    @State var selection: TimeSlot?
    @State var selections: [TimeSlot] = []
    
    var availability: [TimeSlot] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        var calendar = Calendar.current
        calendar.timeZone = .current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        var currentStart = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: startOfDay)!
        let endOfWork = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: startOfDay)!

        var slots = [TimeSlot]()

        while currentStart < endOfWork {
            let currentEnd = calendar.date(byAdding: .hour, value: 1, to: currentStart)!
            let slot = TimeSlot(id: UUID().uuidString, start: Temporal.DateTime(currentStart), end: Temporal.DateTime(currentEnd), userId: dataModel.currUser.id)

            let isSlotAvailable = !dataModel.calendarEvents.contains { event -> Bool in
                guard let eventStart = dateFormatter.date(from: event.start_at),
                      let eventEnd = dateFormatter.date(from: event.end_at) else {
                    return false
                }
                return eventStart < slot.end.foundationDate && eventEnd > slot.start.foundationDate
            }

            if isSlotAvailable {
                slots.append(slot)
            }

            currentStart = currentEnd
        }
        return slots
    }
    
    var body: some View {
        
        VStack(spacing: -20) {
            CalendarViewRepresentable(selectedDate: $selectedDate,ifFiltered: $ifFiltered, ifFuture: $ifFuture, calendarEvents: $dataModel.calendarEvents)
            .padding(.bottom)
            .padding(EdgeInsets(top: 50,
                                leading: 0, bottom: 0, trailing: 0))
            .background{
                LinearGradient(colors: [.pink.opacity(0.4),
                                        .yellow.opacity(0.4)],
                               startPoint: .top,
                               endPoint: .bottom)
            }
            .ignoresSafeArea(.all, edges: .top)
            .clipShape(WavyShape())
            
            if availability.isEmpty {
                VStack{
                    Text("No available slots today")
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                        .padding(EdgeInsets(top: 20,
                                            leading: 20, bottom: 100, trailing: 0))
                }
                .overlay(
                    WavyShape()
                        .fill(LinearGradient(colors: [.white, .yellow.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                        .frame(height: 10)
                        .offset(y: 10),
                    alignment: .top
                )
            } else {
                VStack{
                    Text("Select your availability")
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                        .padding(EdgeInsets(top: 20,
                                            leading: 20, bottom: 0, trailing: 0))
                    Divider()
                    Grid(alignment: .center, horizontalSpacing: 30, verticalSpacing: 30) {
                        GridRow {
                            ForEach(availability[..<lowerLimit], id: \.self) { slot in
                                SlotView(slot: slot, selection: $selection, selections: $selections)
                            }
                        }
                        GridRow {
                            ForEach(availability[lowerLimit...], id: \.self) { slot in
                                SlotView(slot: slot, selection: $selection, selections: $selections)
                            }
                        }
                    }
                    Spacer()
                    if !availability.isEmpty {
                        Button(action: {
                            dataModel.saveAvailability(slots: selections)
                        }) {
                            Text("Confirm Availability for " + timeString(from: selectedDate))
                        }
                    }
                    Spacer()
                }
                .overlay(
                    WavyShape()
                        .fill(LinearGradient(colors: [.white, .yellow.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                        .frame(height: 10)
                        .offset(y: 10),
                    alignment: .top
                )
            }
            
        }
    }
    
    var lowerLimit: Int {
        (availability.count) / 2
    }
    
    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd"

        return formatter.string(from: date)
    }
    
}
