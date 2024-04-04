//
//  CalendarView.swift
//  CCLearn
//
//  Created by Eamon Ma on 11/27/23.
//

import Foundation
import SwiftUI
import UIKit
import FSCalendar

struct WavyShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 0))

        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        
        let amplitude: CGFloat = 20
        let midHeight = rect.height - amplitude
        
        path.addCurve(to: CGPoint(x: 0, y: midHeight),
                      control1: CGPoint(x: rect.width * 3/4, y: rect.height + amplitude),
                      control2: CGPoint(x: rect.width / 4, y: rect.height - amplitude * 3))
        
        path.addLine(to: CGPoint(x: 0, y: rect.height))
        
        path.closeSubpath()
        
        return path
    }
}


struct CalendarView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedDate = Date()
    @State var ifFiltered: Bool = false
    @State var ifFuture: Bool = false
    @State private var isAddEventSheetPresented = false
    
    var filteredEvents: [CalendarEvent] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

        if !ifFiltered{
            return dataModel.calendarEvents
        } else {
            return dataModel.calendarEvents.filter { event in
                return dateFormatter.date(from: event.start_at)?.isSameDay(as: selectedDate) ?? false
            }
        }
    }
    
    private func getAfterColon(str: String) -> String{
        let titleComponents = str.components(separatedBy: ":")

        var contentAfterColon = ""
        if titleComponents.count > 1 {
            contentAfterColon = titleComponents[1...].joined(separator: ":").trimmingCharacters(in: .whitespaces)
        }else{
            contentAfterColon = str
        }
        
        return contentAfterColon
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
            .ignoresSafeArea(.all)
            .clipShape(WavyShape())
            
            VStack{
                HStack{
                    Text("Your Events")
                        .font(.headline)
                        .foregroundStyle(Color.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom)
                        .padding(EdgeInsets(top: 20,
                                            leading: 20, bottom: 0, trailing: 0))
                    
                    Button("Add Event") {
                        isAddEventSheetPresented.toggle()
                    }
                    .padding()
                    .foregroundColor(.primary)
                    .sheet(isPresented: $isAddEventSheetPresented) {
                        AddEventView()
                    }
                    
                                
                }
                Divider()
                
                List{
                    ForEach(filteredEvents.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 7) {
                            
                            Text(getAfterColon(str: filteredEvents[index].title))
                                .foregroundColor(.primary)
                                .font(.headline)
                            HStack {
                                Text(filteredEvents[index].start_at)
                                    .foregroundStyle(.primary)
                                    .font(.caption)
                                Text("to")
                                    .foregroundStyle(.primary)
                                    .font(.caption)
                                Text(filteredEvents[index].end_at)
                                    .foregroundStyle(.primary)
                                    .font(.caption)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                
            }
            .overlay(
                WavyShape()
                    .fill(LinearGradient(colors: [.white, .yellow.opacity(0.4)], startPoint: .top, endPoint: .bottom))
                    .frame(height: 10)
                    .offset(y: 10),
                alignment: .top
            )
            .onAppear {
                dataModel.fetchCalendarEvents()
            }
        }
    }
}



struct CalendarViewRepresentable: UIViewRepresentable {
    typealias UIViewType = FSCalendar

    var calendar = FSCalendar()
    @Binding var selectedDate: Date
    @Binding var ifFiltered: Bool
    @Binding var ifFuture: Bool
    @Binding var calendarEvents: [CalendarEvent]
    @EnvironmentObject var dataModel: DataModel

    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator

        // Added the below code to change calendar appearance
        calendar.appearance.todayColor = UIColor(displayP3Red: 0,
                                                  green: 0,
                                                  blue: 0, alpha: 0)
        calendar.appearance.selectionColor = .orange
        calendar.appearance.titleTodayColor = .blue
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 24)
        calendar.appearance.titleWeekendColor = .systemOrange
        calendar.appearance.headerMinimumDissolvedAlpha = 0.12
        calendar.appearance.headerTitleFont = .systemFont(
                                                ofSize: 30,
                                                weight: .black)
        calendar.appearance.headerTitleColor = .darkGray
        calendar.appearance.headerDateFormat = "MMMM"
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        calendar.clipsToBounds = false

        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject,
          FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarViewRepresentable

        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }

        func calendar(_ calendar: FSCalendar,
                      didSelect date: Date,
                      at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
            parent.ifFiltered = true
        }
        
        func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
            if parent.ifFuture {
                return isFutureDate(date: date)
            }
            return true
        }

        private func isFutureDate(date: Date) -> Bool {
            return date > Date()
        }
        
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
            // gray out past dates
            if parent.ifFuture && date < Date() {
                return .darkGray
            }
            return nil
        }

        func calendar(_ calendar: FSCalendar,
                  imageFor date: Date) -> UIImage? {
            if isWeekend(date: date) {
                let image = UIImage(systemName: "sparkles")?.withRenderingMode(.alwaysTemplate)
                return image?.withTintColor(UIColor(red: 1.00, green: 0.95, blue: 0.97, alpha: 1.00), renderingMode: .alwaysOriginal)
            }
            if isEvent(date: date) {
                let image = UIImage(systemName: "pin.circle.fill")
                return image?.withTintColor(UIColor(red: 0.83, green: 0.77, blue: 0.98, alpha: 1.00), renderingMode: .alwaysOriginal)
            }
            return nil
        }

        func calendar(_ calendar: FSCalendar,
                      numberOfEventsFor date: Date) -> Int  {
            var eventDates: [Date] = []
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            parent.calendarEvents.forEach{ event in
                eventDates.append(dateFormatter.date(from: event.start_at) ?? Date())
            }
            var eventCount = 0
            eventDates.forEach { eventDate in
                if eventDate.formatted(
                    date: .complete, time: .omitted) == date.formatted(
                    date: .complete, time: .omitted){
                    eventCount += 1;
                }
            }
            return eventCount
        }

        func isEvent(date: Date) -> Bool {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            
            if parent.calendarEvents.contains(where: { event in
                return dateFormatter.date(from: event.start_at)?.isSameDay(as: date) ?? false
            }) {
                return true
            }
            
            return false
        }

        func maximumDate(for calendar: FSCalendar) -> Date {
            Date.now.addingTimeInterval(86400 * 60)
        }

        func minimumDate(for calendar: FSCalendar) -> Date {
            Date.now.addingTimeInterval(-86400 * 60)
        }
    }
    
}

func isWeekend(date: Date) -> Bool {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE"
    let day: String = dateFormatter.string(from: date)
    if day == "Saturday" || day == "Sunday" {
        return true
    }
    return false
}

extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        let components1 = calendar.dateComponents([.year, .month, .day], from: self)
        let components2 = calendar.dateComponents([.year, .month, .day], from: otherDate)
        return components1 == components2
    }
}

