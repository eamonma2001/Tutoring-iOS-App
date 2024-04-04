//
//  AddEventView.swift
//  CCLearn
//
//  Created by Eamon Ma on 11/27/23.
//

import Foundation
import SwiftUI

struct AddEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataModel: DataModel
    
    // Add state properties for the additional fields
    @State var eventTitle: String = ""
    @State var startTime: Date = Date()
    @State var endTime: Date = Date()
    @State var locationName: String = ""
    @State var locationAddress: String = ""
    
    var taskIndex: Int = -1
    var adding: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Text("Event Title: ")
                        .foregroundColor(.brown) // Set label color
                        .fontWeight(.bold)
                        .padding(.trailing, 10)
                    TextField("", text: $eventTitle)
                    
                    HStack {
                        Text("Start Time: ")
                            .foregroundColor(.brown)
                            .fontWeight(.bold)
                            .padding(.trailing, 10)
                        
                        DatePicker("", selection: $startTime, displayedComponents: [.date, .hourAndMinute])
                            .labelsHidden()
                    }
                    .padding()
                    
                    HStack {
                        Text("End Time: ")
                            .foregroundColor(.brown)
                            .fontWeight(.bold)
                            .padding(.trailing, 10)
                        
                        DatePicker("", selection: $endTime, displayedComponents:  [.date, .hourAndMinute])
                            .labelsHidden()
                    }
                    .padding()
                
                    
                    Text("Location Name: ")
                        .foregroundColor(.brown)
                        .fontWeight(.bold)
                        .padding(.trailing, 10)
                    TextField("", text: $locationName)
                    
                    Text("Location Address: ")
                        .foregroundColor(.brown)
                        .fontWeight(.bold)
                        .padding(.trailing, 10)
                    TextField("", text: $locationAddress)
                }
                Spacer()
                
            }
            .navigationTitle("Create Event")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sssZ"
                    print(locationName)
                    let newEvent = CalendarEvent(id: UUID().uuidString, title: dataModel.currUser.name + ": " + eventTitle, start_at: dateFormatter.string(from:startTime), end_at: dateFormatter.string(from:endTime), location_name: locationName + ": " + locationAddress)
                    dataModel.saveCalendarEvent(newEvent)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView()
            .environmentObject(DataModel()) // Provide a sample DataModel
    }
}

