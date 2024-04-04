//  ConfirmRow.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/11/26.
//

import Foundation
import SwiftUI

struct ConfirmRow: View {
    var meetingRequest: MeetingRequest
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            InfoRow(label: "Student Name: ", value: getStudentName(studentID: meetingRequest.meetingRequestStudentId))
            InfoRow(label: "Meeting Date: ", value:  formattedTime(date: meetingRequest.date.foundationDate))
        }
    }
    
    private func formattedTime(date: Date) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.timeStyle = .short
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
         return dateFormatter.string(from: date)
     }
    
    private func getStudentName(studentID: String) -> String {
        var name = ""
        dataModel.getUserByID(studentID) { user in
            if let user = user {
                name = user.name
            }
        }
        return name
    }
}



struct InfoRow: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.brown) // Set label color
                .fontWeight(.bold)
                .padding(.trailing, 5)
                .frame(width: 150, alignment: .leading)
                .font(.system(size: 14))
            
            Text(value)
                .lineLimit(1)
                .truncationMode(.tail)
                .font(.system(size: 14))
        }
    }
}

struct ConfirmRow_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmRow(meetingRequest: DataModel().meetingRequests[0])
            .environmentObject(DataModel())
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
