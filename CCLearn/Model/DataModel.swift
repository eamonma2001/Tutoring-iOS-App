//
//  DataModel.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/11/2.
//

import Foundation
import SwiftUI
import Amplify
import AmplifyPlugins
import Combine

class DataModel: NSObject, ObservableObject {
    
    @Published var currUser: User = student
    @Published var courses: [Course] = []
    @Published var reminderEvents: [ReminderEvent] = []
    @Published var calendarEvents: [CalendarEvent] = []
    @Published var assignmentEvents: [AssignmentEvent] = []
    @Published var defaultTasks: [Task] = []
    @Published var availability: [TimeSlot] = []
    @Published var isCurrUserStudent: Bool = false
    @Published var meetingRequests: [MeetingRequest] = []
    @Published var timeSlots: [TimeSlot] = []
    @Published var usersInTimeSlots: [User] = []
    @Published var timeSlotsByUserId: [String: [TimeSlot]] = [:]
    @Published var students: [User] = []
    @Published var tutors: [User] = []

    var cancellables = Set<AnyCancellable>()
 
    var currUserType: String = ""
    var userToken: String = ""
    
    override init() {
            super.init()
            self.configureAmplify()
            self.fetchCalendarEvents()
            self.initializeTAs()
            self.initializeStudents()
            self.getTasks()
        }
    
    func configureAmplify() {
        do {
            try Amplify.add(
                plugin: AWSDataStorePlugin(modelRegistration: AmplifyModels())
            )
            try Amplify.add(
                plugin: AWSAPIPlugin(modelRegistration: AmplifyModels())
            )
            try Amplify.configure()
            print("Amplify initialized")

        } catch {
            print("could not initialize Amplify - \(error)")
        }
    }
    
    func initializeTAs() {
        self.getUser(accessToken: ta1AccessToken)
        self.getUser(accessToken: ta2AccessToken)

        for user in self.tutors {
            Amplify.DataStore.query(User.self, where: User.keys.id.eq(user.id)) { result in
                switch result {
                case .success(let foundUsers):
                    if foundUsers.isEmpty {
                        saveUser(user)
                    }
                case .failure(let error):
                    print("Error querying for user: \(error)")
                }
            }
        }
    }
    
    func initializeStudents() {
        self.getStudent(accessToken: studentAccessToken)

        for user in self.students {
            Amplify.DataStore.query(User.self, where: User.keys.id.eq(user.id)) { result in
                switch result {
                case .success(let foundUsers):
                    if foundUsers.isEmpty {
                        saveUser(user)
                    }
                case .failure(let error):
                    print("Error querying for user: \(error)")
                }
            }
        }
    }
    
    func saveUser(_ user: User) {
        Amplify.DataStore.save(user) { result in
            switch result {
            case .success:
                print("User saved successfully.")
            case .failure(let error):
                print("Error saving user: \(error)")
            }
        }
    }
    
    
    func listUsers() {
        Amplify.DataStore.query(User.self) { result in
            switch result {
            case .success(let users):
                DispatchQueue.main.async {
                    self.currUser = users.first ?? student
                }
            case .failure(let error):
                print("Error listing users: \(error)")
            }
        }
    }
    
    func getUserByID(_ userID: String, completion: @escaping (User?) -> Void) {
        Amplify.DataStore.query(User.self, where: User.keys.id.eq(userID)) { result in
            switch result {
            case .success(let users):
                // Assuming the ID is unique, there should be only one user or none
                let user = users.first
                completion(user)
            case .failure(let error):
                print("Error querying for user: \(error)")
                completion(nil)
            }
        }
    }

    
    func updateUser(name: String, primary_email: String, avatar_url: String) {
        var currentUser: User = self.currUser

        currentUser.name = name
        currentUser.primary_email = primary_email.isEmpty ? currentUser.primary_email : primary_email
        currentUser.avatar_url = avatar_url.isEmpty ? currentUser.avatar_url : avatar_url

        // Save the updated user
        Amplify.DataStore.save(currentUser) { result in
            switch result {
            case .success(let savedUser):
                print("User updated: \(savedUser)")
                DispatchQueue.main.async {
                    self.currUser = savedUser // Update the current user
                    self.listUsers()
                }
            case .failure(let error):
                print("Update failed: \(error)")
            }
        }
    }

    func fetchCalendarEvents() {

        let predicate = CalendarEvent.keys.title.contains(self.currUser.name)

        Amplify.DataStore.query(CalendarEvent.self, where: predicate) { result in
            switch result {
            case .success(let events):
                DispatchQueue.main.async {
                    self.calendarEvents = self.calendarEvents + events.filter { $0.title.contains(self.currUser.name) }
                }
            case .failure(let error):
                print("Error fetching calendar events: \(error)")
            }
        }
    }

    func saveCalendarEvent(_ event: CalendarEvent) {
        Amplify.DataStore.save(event) { result in
            switch result {
            case .success(let savedEvent):
                print("Calendar event saved: \(savedEvent)")
            case .failure(let error):
                print("Error saving calendar event: \(error)")
            }
        }
    }
    
    func deleteCalendarEvent(_ event: CalendarEvent) {
        Amplify.DataStore.delete(event) { result in
            switch result {
            case .success:
                print("Calendar event deleted")
            case .failure(let error):
                print("Error deleting calendar event: \(error)")
            }
        }
    }
    
    func observeCalendarEvents() {
        Amplify.DataStore.publisher(for: CalendarEvent.self).sink { completion in
            print("Subscription completed: \(completion)")
        } receiveValue: { change in
            print("Subscription received value: \(change)")
        }.store(in: &cancellables) 
    }
    
    func getAllInfo() {
        self.getUserInfo()
        self.getAllCourses()
        self.getCalendarEvents(allEvents: true, getAssmt: false, courseID: "")
    }

    func getUserInfo() {
        // Set the URL and access token
        let apiUrl = URL(string: "https://canvas.instructure.com/api/v1/users/self/profile")!
        let accessToken = self.userToken

        // Create a URLRequest
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        // Set the Authorization header
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        // Create a URLSession
        let session = URLSession.shared

        // Make the API request
        let task = session.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if there is data
            guard let data = data else {
                print("No data received")
                return
            }

            do {
                print(data)
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.currUser = decoded
                    print(self.currUser)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

        // Start the task
        task.resume()
    }
    
    func getCalendarEvents(allEvents: Bool, getAssmt: Bool, courseID: String) {
        // Define the base URL
        let baseURL = URL(string: "https://canvas.instructure.com/api/v1/calendar_events")!
        let accessToken = self.userToken
        
        // Add query parameters
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)!

        if getAssmt {
            components.queryItems = [
                URLQueryItem(name: "type", value: "assignment"),
                URLQueryItem(name: "context_codes[]", value: "course_" + courseID),
                URLQueryItem(name: "end_date", value: "2023-12-31")
            ]
        } else {
            components.queryItems = [
                URLQueryItem(name: "all_events", value: allEvents.description) // Convert Bool to String
            ]
        }
        
        // Create a URLRequest
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        
        // Add authorization header
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // Set up a URLSession
        let session = URLSession.shared
        
        // Make the API request
        let task = session.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if there is data
            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let decoder = JSONDecoder()
                if getAssmt {
                    let decoded = try decoder.decode([AssignmentEvent].self, from: data)
                    DispatchQueue.main.async {
                        self.assignmentEvents += decoded
                        self.getReminders()
                    }
                } else {
                    let decoded = try decoder.decode([CalendarEvent].self, from: data)
                    DispatchQueue.main.async {
                        self.calendarEvents = decoded
                    }
                }
            } catch {
                print(data)
                print("Error parsing JSON: \(error)")
            }
        }
        
        // Start the data task
        task.resume()
    }
    
    func getAllCourses() {
        // Set the URL and access token
        let apiUrl = URL(string: "https://canvas.instructure.com/api/v1/courses")!
        let accessToken = self.userToken

        // Create a URLRequest
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        // Set the Authorization header
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        // Create a URLSession
        let session = URLSession.shared

        // Make the API request
        let task = session.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if there is data
            guard let data = data else {
                print("No data received")
                return
            }

            // Parse the data (if applicable)
            // In this example, assume the response is JSON
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([Course].self, from: data)
                DispatchQueue.main.async {
                    self.courses = decoded
                    for course in self.courses {
                        self.getCalendarEvents(allEvents: true, getAssmt: true, courseID: course.id)
                    }
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

        // Start the task
        task.resume()
    }

    func getUser(accessToken: String) {
        let apiUrl = URL(string: "https://canvas.instructure.com/api/v1/users/self/profile")!

        // Create a URLRequest
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        // Set the Authorization header
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        // Create a URLSession
        let session = URLSession.shared

        // Make the API request
        let task = session.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if there is data
            guard let data = data else {
                print("No data received")
                return
            }

            // Parse the data (if applicable)
            // In this example, assume the response is JSON
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.tutors.append(decoded)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

        // Start the task
        task.resume()
    }
    
    func getStudent(accessToken: String) {
        let apiUrl = URL(string: "https://canvas.instructure.com/api/v1/users/self/profile")!

        // Create a URLRequest
        var request = URLRequest(url: apiUrl)
        request.httpMethod = "GET"

        // Set the Authorization header
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        // Create a URLSession
        let session = URLSession.shared

        // Make the API request
        let task = session.dataTask(with: request) { data, response, error in
            // Check for errors
            if let error = error {
                print("Error: \(error)")
                return
            }

            // Check if there is data
            guard let data = data else {
                print("No data received")
                return
            }

            // Parse the data (if applicable)
            // In this example, assume the response is JSON
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(User.self, from: data)
                DispatchQueue.main.async {
                    self.students.append(decoded)
                }
            } catch {
                print("Error parsing JSON: \(error)")
            }
        }

        // Start the task
        task.resume()
    }
    
    func getReminders() {
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            return formatter
        }()
        
        // Combine the lists of CalendarEvent and AssignmentEvent into a single list
        let allEvents: [Any] = calendarEvents + assignmentEvents
        let allReminderEvents = allEvents.compactMap { event in
            if let calendarEvent = event as? CalendarEvent {
                return ReminderEvent(id: calendarEvent.id, title: calendarEvent.title, end_at: calendarEvent.end_at, context_name: calendarEvent.location_name)
            } else if let assignmentEvent = event as? AssignmentEvent {
                return ReminderEvent(id: assignmentEvent.id, title: assignmentEvent.title, end_at: assignmentEvent.end_at, context_name: assignmentEvent.context_name)
            } else {
                return nil
            }
        }
        
        // Filter events to include only those occurring after the current date
        let futureReminderEvents = allReminderEvents.filter { event in
            let eventDate = dateFormatter.date(from: event.end_at) ?? Date()
            return Calendar.current.isDate(eventDate, inSameDayAs: Date()) || eventDate >= Date()
        }
        
        let sortedEvents = futureReminderEvents.sorted { (event1, event2) -> Bool in
            // Extract end_at dates and convert them to Date objects
            let date1 = dateFormatter.date(from: event1.end_at) ?? Date()
            let date2 = dateFormatter.date(from: event2.end_at) ?? Date()

            // Compare the dates
            return date1 < date2
        }

        self.reminderEvents = Array(sortedEvents.prefix(min(5, sortedEvents.count)))
    }
    
    func addTasks(tasks: [Task]) {
        for task in tasks {
            Amplify.DataStore.save(task) { result in
                switch result {
                case .success:
                    print("Task added successfully.")
                case .failure(let error):
                    print("Error adding task: \(error)")
                }
            }
        }
        self.getTasks()
    }

    func updateTask(task: Task, taskName: String, taskDescription: String, isCompleted: Bool? = nil) {
        let updatedTask = Task(id: task.id, name: taskName, description: taskDescription, isDone: isCompleted ?? task.isDone)
        
        Amplify.DataStore.save(updatedTask) { result in
            switch result {
            case .success:
                print("Task updated successfully.")
            case .failure(let error):
                print("Error updating task: \(error)")
            }
        }
        self.getTasks()
    }

    
    func getTasks(){
        Amplify.DataStore.query(Task.self) { result in
            switch result {
            case .success(let tasks):
                self.defaultTasks = tasks
            case .failure(let error):
                print("Error fetching tasks: \(error)")
            }
        }
    }
    
    func deleteTask(task: Task) {
        Amplify.DataStore.delete(task) { result in
            switch result {
            case .success:
                print("Task deleted successfully.")
            case .failure(let error):
                print("Error deleting task: \(error)")
            }
        }
        self.getTasks()
    }

    func saveAvailability(slots: [TimeSlot]) {
        for slot in slots {

            Amplify.DataStore.query(TimeSlot.self) { result in
                switch result {
                case .success(let existingSlots):
                    let slotExists = existingSlots.contains { existingSlot in
                        slot == existingSlot
                    }
                    if !slotExists {
                        self.saveTimeSlot(slot)
                    } else {
                        print("Equivalent slot already exists, not saving: \(slot)")
                    }
                case .failure(let error):
                    print("Error querying for slots: \(error)")
                }
            }
        }
    }
    
    private func saveTimeSlot(_ slot: TimeSlot) {
        Amplify.DataStore.save(slot) { result in
            switch result {
            case .success(let savedSlot):
                print("Successfully saved slot: \(savedSlot)")
            case .failure(let error):
                print("Could not save slot: \(error)")
            }
        }
    }
    
    func listAvailability() {
        Amplify.DataStore.query(TimeSlot.self) { result in
            switch result {
            case .success(let slots):
                DispatchQueue.main.async {
                    self.availability = slots
                    //print(self.availability)
                }
            case .failure(let error):
                print("Error fetching time slots: \(error)")
            }
        }
    }
    
    func getRequestByTa(taId: String){
        Amplify.DataStore.query(MeetingRequest.self, where: MeetingRequest.keys.meetingRequestTaId.eq(taId)) { result in
                switch result {
                case .success(let fetchedRequests):
                    DispatchQueue.main.async {
                        self.meetingRequests = fetchedRequests
                    }
                case .failure(let error):
                    print("Error fetching meeting requests: \(error)")
                    DispatchQueue.main.async {
                        self.meetingRequests = []
                    }
                }
            }
    }
    
    func getRequestByStudent(studentID: String){
        Amplify.DataStore.query(MeetingRequest.self, where: MeetingRequest.keys.meetingRequestStudentId.eq(studentID)) { result in
                switch result {
                case .success(let fetchedRequests):
                    DispatchQueue.main.async {
                        self.meetingRequests = fetchedRequests
                    }
                case .failure(let error):
                    print("Error fetching meeting requests: \(error)")
                    DispatchQueue.main.async {
                        self.meetingRequests = []
                    }
                }
            }
    }
    
    

    func fetchTimeSlotsAndUsers() {
        Amplify.DataStore.query(TimeSlot.self) { result in
            switch result {
            case .success(let slots):
                self.groupTimeSlotsByUserId(slots)
                print("timeSlotsByUserId:",timeSlotsByUserId)
            case .failure(let error):
                print("Error fetching time slots: \(error)")
            }
        }
    }

    private func groupTimeSlotsByUserId(_ timeSlots: [TimeSlot]) {
        var groupedSlots = [String: [TimeSlot]]()
        for slot in timeSlots {
            groupedSlots[slot.userId, default: []].append(slot)
        }
        self.timeSlotsByUserId = groupedSlots
        self.fetchUsersForGroupedTimeSlots()
    }

    func fetchUsersForGroupedTimeSlots() {
        let userIds = Set(timeSlotsByUserId.keys)
        Amplify.DataStore.query(User.self) { result in
            switch result {
            case .success(let users):
                let filteredUsers = users.filter { userIds.contains($0.id) }
                self.usersInTimeSlots = filteredUsers
            case .failure(let error):
                print("Error fetching users: \(error)")
            }
        }
    }

    func saveMeetingRequests(_ meetingRequests: [MeetingRequest]) {
        for request in meetingRequests {
            Amplify.DataStore.query(MeetingRequest.self) { result in
                switch result {
                case .success(_):
                    self.saveRequest(request)
                case .failure(let error):
                    print("Could not save meeting request: \(error)")
                }
            }
        }
    }
    
    private func saveRequest(_ request: MeetingRequest) {
        Amplify.DataStore.save(request) { result in
            switch result {
            case .success(let savedrequest):
                print("Successfully saved slot: \(savedrequest)")
            case .failure(let error):
                print("Could not save slot: \(error)")
            }
        }
    }
    
    func deleteMeetingRequest(_ requestID: String) {
        Amplify.DataStore.query(MeetingRequest.self, where: MeetingRequest.keys.id.eq(requestID)) { result in
            switch result {
            case .success(let meetingRequests):
                if let requestToDelete = meetingRequests.first {
                    self.deleteRequest(requestToDelete)
                } else {
                    print("No meeting request found with ID \(requestID)")
                }
            case .failure(let error):
                print("Error querying for meeting request: \(error)")
            }
        }
    }

    private func deleteRequest(_ request: MeetingRequest) {
        Amplify.DataStore.delete(request) { result in
            switch result {
            case .success():
                print("Successfully deleted meeting request: \(request)")
            case .failure(let error):
                print("Could not delete meeting request: \(error)")
            }
        }
    }
}
