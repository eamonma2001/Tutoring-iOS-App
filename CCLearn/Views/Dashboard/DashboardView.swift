//  Dashboard.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/10/27.
//

import Foundation
import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var dataModel: DataModel
    let currentDate = Date()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .none
        return formatter
    }()
    @State private var searchText = ""
    @State private var isReminderSectionExpanded: Bool = true
    @State private var isToDoListExpanded: Bool = true
    
    @State private var navigateToAdd = false
    @ObservedObject var loginManager: LoginManager
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink(destination: ProfileView(loginManager: loginManager)
                        .environmentObject(dataModel)
                    ) {
                        VStack {
                            Text("Hello, \(dataModel.currUser.name)!")
                                .font(.title)
                                .foregroundColor(Color.blue)
                                .fontWeight(.bold)
                                .padding(.bottom, 10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Today is \(dateFormatter.string(from: currentDate)).")
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Welcome to CCLearn!")
                                .fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .listRowBackground(Color.blue.opacity(0.1))
                    }
                    
                    Section() {
                        NavigationLink(destination: ConfirmView()
                            .environmentObject(dataModel)) {
                                HStack {
                                    if dataModel.isCurrUserStudent{
                                        Text("Pending Meeting Request")
                                    }
                                    else {
                                        Text("New Meeting Request")
                                    }
                                    Spacer()
                                    NotificationBadge(count: dataModel.meetingRequests.count)
                                        .padding(.trailing, 20)
                                }
                            }
                    }
                    .onAppear{
                        if dataModel.isCurrUserStudent {
                            dataModel.getRequestByStudent(studentID: dataModel.currUser.id)
                        }
                        else {
                            dataModel.getRequestByTa(taId: dataModel.currUser.id)
                        }
                        
                    }
                    
                    Section(header: headerView("Reminder", isExpanded: $isReminderSectionExpanded)) {
                        if isReminderSectionExpanded {
                            ReminderView(searchText: $searchText)
                        }
                    }
                    
                    Section(header: headerView("To Do List", isExpanded: $isToDoListExpanded)) {
                        if isToDoListExpanded {
                            //Text("appear")
                            ToDoView(searchText: $searchText)
                        }
                    }
                }
            }
            .navigationTitle("Dashboard")
            .searchable(text: $searchText)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .sheet(isPresented: $navigateToAdd) {
                AddEditView(adding: true)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        self.navigateToAdd = true
                    }) {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func headerView(_ title: String, isExpanded: Binding<Bool>) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 25)).fontWeight(.bold)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.red, .blue, .green, .yellow],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .padding(.top, 2).textCase(.none)

            Spacer()

            Button(action: {
                withAnimation {
                    isExpanded.wrappedValue.toggle()
                }
            }) {
                Image(systemName: isExpanded.wrappedValue ? "chevron.down" : "chevron.right")
                    .font(.title)
            }
        }
        .padding(.top, 5)
        .frame(maxWidth: .infinity)
    }
}

//struct DashboardView_Previews: PreviewProvider {
//    static var previews: some View {
//        DashboardView()
//            .environmentObject(DataModel())
//    }
//}

