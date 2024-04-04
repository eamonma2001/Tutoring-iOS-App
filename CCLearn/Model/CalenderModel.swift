//
//  CalenderModel.swift
//  CCLearn
//
//  Created by Eamon Ma on 10/28/23.
//

import Foundation

struct CalendarEventResponse: Codable {
    let calendarEvents: [CalendarEvent]
    
    enum CodingKeys: String, CodingKey {
        case calendarEvents = "calendar_events"
    }
}

struct CalendarEvent: Codable, Hashable, Identifiable {
    let id: Int
    var title: String
    var start_at: String
    var end_at: String
    /*let description: String
    
    let location_name: String
    let location_address: String
    let context_code: String
    let effective_context_code: String?
    let context_name: String
    let all_context_codes: String
    let workflow_state: String
    let hidden: Bool
    let parent_event_id: String?
    let child_events_count: Int
    let child_events: [CalendarEvent]?
    let url: String
    let html_url: String
    let all_day_date: String
    let all_day: Bool
    let created_at: String
    let updated_at: String
    let appointment_group_id: String?
    let appointment_group_url: String?
    let own_reservation: Bool
    let reserve_url: String?
    let reserved: Bool
    let participant_type: String
    let participants_per_appointment: Int?
    let available_slots: Int?
    let user: User? // Assuming there's a User struct
    let group: Group? // Assuming there's a Group struct
    let important_dates: Bool
    let series_uuid: String?
    let rrule: String?
    let series_head: Bool?
    let series_natural_language: String?
    let blackout_date: Bool*/
}

struct AssignmentEvent: Codable {
    let id: String
    let title: String
    let start_at: String
    let end_at: String
    let description: String
    let context_code: String
    let workflow_state: String
    let url: String
    let html_url: String
    let all_day_date: String
    let all_day: Bool
    let created_at: String
    let updated_at: String
    let assignment: Assignment? // Assuming there's an Assignment struct
    let assignment_overrides: [AssignmentOverride]? // Assuming there's an AssignmentOverride struct
    let important_dates: Bool
    let rrule: String?
    let series_head: Bool?
    let series_natural_language: String?
}

struct User: Codable {
    // Define properties for User
}

struct Group: Codable {
    // Define properties for Group
}

struct Assignment: Codable {
    // Define properties for Assignment
}

struct AssignmentOverride: Codable {
    // Define properties for AssignmentOverride
}

@MainActor
class CalenderModel: ObservableObject {
    private var database: [CalendarEvent] = []
    
    @Published var events: [CalendarEvent]
    
    @Published var selectedDate: Date

    @Published var selectedDayEvents: [CalendarEvent]
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    private let ArchiveURL = DocumentsDirectory.appendingPathComponent(jsonFileName)
    
    init(date: Date) {
       self.events = []
       self.selectedDate = date
       self.selectedDayEvents = []
       /*Task {
           await load()
       }*/
   }
    
    func load() -> Bool {
        let decoder = JSONDecoder()
        var databaseInit: [CalendarEvent] = []
        let jsonData: Data
        
        do {
            jsonData = try Data(contentsOf: ArchiveURL)
        } catch {
            return false
        }
            
        if let decodedEvents = try? decoder.decode([CalendarEvent].self, from: jsonData){
            for event in decodedEvents {
                events.append(event)
            }
            self.database = databaseInit
        } else {
            return false
        }
        
        return true
    }
    
    func save() -> Bool {
        var outputData = Data()
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(database){
            outputData = data
            do {
                try outputData.write(to: ArchiveURL)
            } catch {
                return false
            }
            return true
        }
        else {
            return false
        }
    }
}
