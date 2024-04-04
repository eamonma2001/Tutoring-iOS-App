
//  TutorDetail.swift
//  CCLearn
//
//  Created by Brandon C. on 2023/11/26.
//

import Foundation
import SwiftUI
import URLImage
import SwiftSMTP
import Amplify

struct TutorDetail: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var selectedDate = Date()
    @State var tutor: User
    @State var selection: TimeSlot?
    @State var selections: [TimeSlot] = []
    

    var body: some View {
        VStack {
            ZStack {
                Image("profile_bg")
                    .rotationEffect(.degrees(180))
                if let avatarURL = URL(string: tutor.avatar_url ?? "") {
                    URLImage(avatarURL) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                    }
                }
                else {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                }

            }
            .frame(height: 340)

            Spacer().frame(height: 20)

            Text("\(tutor.name)")
                .font(.title)
                .padding()
            
            VStack{
                List(dataModel.timeSlotsByUserId[tutor.id]?.indices ?? 1..<2, id: \.self) { index in
                    if (dataModel.timeSlotsByUserId[tutor.id] != nil){
                        SlotRow(slot:dataModel.timeSlotsByUserId[tutor.id]![index], selection: $selection, selections: $selections , tutor: $tutor, index: index)
                    } else {
                        Text("No Available Slots")
                    }
                }
                HStack {
                    Spacer().frame(height: 20)
                    if (dataModel.timeSlotsByUserId[tutor.id] != nil){
                        Button("Confirm") {
                            for slot in selections {
                                sendMail(receiver: Mail.User(name: tutor.name,email: tutor.primary_email), emailType: "request", studentName: dataModel.currUser.name, taName: tutor.name, meetingDate: formattedDate(date: slot.start), message: "")
                                let request = MeetingRequest(id: UUID().uuidString, student: dataModel.currUser, ta: tutor, date: slot.start, meetingRequestStudentId: dataModel.currUser.id, meetingRequestTaId: tutor.id)
                                dataModel.saveMeetingRequests([request])
                            }
                            print("Confirm successful")
                        }
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding()
                    }
                }
                Spacer().frame(height: 10)
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            print(dataModel.timeSlotsByUserId)
            dataModel.fetchTimeSlotsAndUsers()
        }
        Spacer()
    }
    
    private func formattedDate(date: Temporal.DateTime) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        return dateFormatter.string(from: date.foundationDate)
    }
    
}

struct SlotRow: View {
    @State var slot: TimeSlot
    @Binding var selection: TimeSlot?
    @Binding var selections: [TimeSlot]
    @Binding var tutor: User
    let index: Int
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        Button {
           if selections.contains(where: { $0 == slot }) {
               selections.removeAll { $0 == slot }
           } else {
               selections.append(slot)
           }
       } label: {
           Label2(slot: slot, isSelected: selections.contains { $0 == slot })
       }
       .buttonStyle(.plain)
    }

    
}

private struct Label2: View {
    var slot: TimeSlot
    var isSelected: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Available: \(formattedTimeRange(slot: slot))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 20, height: 20)
        }
        .padding(8)
    }
    
    private func formattedTimeRange(slot: TimeSlot) -> String {
         let dateFormatter = DateFormatter()
         dateFormatter.timeStyle = .short
         dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
         return "\(dateFormatter.string(from: slot.start.foundationDate)) - \( (dateFormatter.string(from: slot.end.foundationDate)))"
     }
}
    


struct TutorDetail_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock Tutor with some sample data
        return VStack {
            TutorDetail(tutor: ta1)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
