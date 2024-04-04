
//
//  DeclineView.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/11/26.
//

import Foundation
import SwiftUI
import SwiftSMTP

struct DeclineView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataModel: DataModel

    @State var message: String = ""
    
    var studentName: String
    var taName: String
    var studentEmail: String
    var meetingDate: String
    var meetingTime: String
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Text("You've chosen to decline the meeting with \(studentName) at \(meetingTime), \(meetingDate). Would you like to leave a message to the student?")
                        .foregroundColor(.brown) // Set label color
                        .fontWeight(.bold)
                        .padding(.trailing, 10)
                    TextEditor(text: $message)
                        .frame(width: 300, height: 300, alignment: .leading)
                }
                Spacer() 
                
                Button(action: {
                    sendMail(receiver: Mail.User(name: studentName, email: studentEmail), emailType: "decline", studentName: studentName, taName: taName, meetingDate: meetingDate, message: "")
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Skip")
                        .font(.headline)
                        .padding()
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Leave a Message")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Confirm") {
                    sendMail(receiver: Mail.User(name: studentName, email: studentEmail), emailType: "decline", studentName: studentName, taName: taName, meetingDate: meetingDate, message: message)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct DeclineView_Previews: PreviewProvider {
    static var previews: some View {
        DeclineView(studentName: "Yuxuan Gu", taName: "Yuxuan Gu", studentEmail: "yuxuan.gu@duke.edu", meetingDate: "Nov 29", meetingTime: "10:29 PM")
    }
}
