//
//  ConfirmView.swift
//  CCLearn
//
//  Created by Eamon Ma on 11/27/23.
//

import Foundation
import SwiftUI
import SwiftSMTP

struct ConfirmView: View {
    @EnvironmentObject var dataModel: DataModel
    @State var idToDelete: String = ""
    @State var isDeclineSheetPresented: Bool = false
    
    var allMeetingRequests: [MeetingRequest] {
        dataModel.meetingRequests
    }
    @State var studentNameToDecline: String = ""
    @State var taNameToDecline: String = ""
    @State var studentEmailToDecline: String = ""
    @State var meetingDateToDecline: String = ""
    @State var meetingTimeToDecline: String = ""
    
    var body: some View {
        List {
            if !dataModel.isCurrUserStudent {
                Section() {
                    Text("Please swipe to perform actions:")
                }
            }
            ForEach(allMeetingRequests.indices, id: \.self) { index in
                Section(header: Text("Meeting Request \(index + 1)")) {
                    if dataModel.isCurrUserStudent{
                        ConfirmRow(meetingRequest: allMeetingRequests[index])
                            .padding(.bottom, 5)
                    } else{
                        ConfirmRow(meetingRequest: allMeetingRequests[index])
                            .padding(.bottom, 5)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    idToDelete = allMeetingRequests[index].id
                                    dataModel.getUserByID(allMeetingRequests[index].meetingRequestStudentId) { user in
                                        if let user = user {
                                            sendMail(receiver: Mail.User(name: user.name, email: user.primary_email), emailType: "accept", studentName: user.name, taName: dataModel.currUser.name, meetingDate: allMeetingRequests[index].date.iso8601String, message: "")
                                            let originalDate = allMeetingRequests[index].date.foundationDate
                                            
                                            let dateFormatter = DateFormatter()
                                            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:sssZ"
                                            
                                            let updatedDate = originalDate.addingTimeInterval(3600) // 3600 seconds = 1 hour
                                            
                                            let updatedOriginal = dateFormatter.string(from: originalDate)
                                            let updatedDateString = dateFormatter.string(from: updatedDate)
                                            
                                            let newEvent = CalendarEvent(id: UUID().uuidString, title: "Meeting between \(user.name) and \(dataModel.currUser.name)", start_at: updatedOriginal, end_at: updatedDateString)
                                            
                                            dataModel.saveCalendarEvent(newEvent)
                                            print("User found: \(user.name)")
                                        } else {
                                            print("User not found")
                                        }
                                    }
                                    withAnimation {
                                        dataModel.deleteMeetingRequest(idToDelete)
                                        dataModel.getRequestByTa(taId: dataModel.currUser.id)
                                        
                                        
                                    }
                                } label: {
                                    Image(systemName: "checkmark")
                                }
                                .tint(.blue)
                                
                                Button {
                                    idToDelete = allMeetingRequests[index].id
                                    idToDelete = allMeetingRequests[index].id
                                    dataModel.getUserByID(allMeetingRequests[index].meetingRequestStudentId) { user in
                                        if let user = user {
                                            studentEmailToDecline = user.primary_email
                                            studentNameToDecline = user.name
                                            taNameToDecline = dataModel.currUser.name
                                            meetingDateToDecline = allMeetingRequests[index].date.iso8601String
                                            isDeclineSheetPresented = true
                                            print("User found: \(user.name)")
                                        } else {
                                            print("User not found")
                                        }
                                    }
                                    withAnimation {
                                        dataModel.deleteMeetingRequest(idToDelete)
                                        dataModel.getRequestByTa(taId: dataModel.currUser.id)
                                    }
                                } label: {
                                    Image(systemName: "xmark")
                                }
                                .tint(.red)
                            }
                    }
                }
            }
        }
        .sheet(isPresented: $isDeclineSheetPresented) {
            DeclineView(studentName: studentNameToDecline, taName: taNameToDecline, studentEmail: studentEmailToDecline, meetingDate: meetingDateToDecline, meetingTime: meetingTimeToDecline)
        }
        .navigationBarTitle("Meeting Request", displayMode: .inline)
        .onAppear{
            if dataModel.isCurrUserStudent{
                dataModel.getRequestByStudent(studentID: dataModel.currUser.id)
            }else{
                dataModel.getRequestByTa(taId: dataModel.currUser.id)
            }
        }
    }
}

struct ConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmView()
            .environmentObject(DataModel())
    }
}
