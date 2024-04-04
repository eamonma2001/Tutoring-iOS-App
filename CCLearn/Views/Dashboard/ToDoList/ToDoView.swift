//
//  ToDoView.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/11/13.
//

import Foundation
import SwiftUI

struct ToDoView: View {
    @EnvironmentObject var dataModel: DataModel
    let rowColors: [Color] = [
        Color(red: 173 / 255, green: 216 / 255, blue: 230 / 255), // Light Blue
        Color(red: 255 / 255, green: 218 / 255, blue: 185 / 255), // Peach
        Color(red: 240 / 255, green: 128 / 255, blue: 128 / 255), // Light Coral
        Color(red: 216 / 255, green: 191 / 255, blue: 216 / 255), // Thistle
        Color(red: 188 / 255, green: 229 / 255, blue: 188 / 255)  // Light Green
    ]
    @Binding var searchText: String
    var filteredToDos: [Task] {
        if searchText.isEmpty {
            return dataModel.defaultTasks.filter { task in
                task.id.contains(dataModel.currUser.name.replacingOccurrences(of: " ", with: ""))
            }
        } else {
            return dataModel.defaultTasks.filter { task in
                (task.name + (task.description ?? "")).lowercased().contains(searchText.lowercased()) && task.id.contains(dataModel.currUser.name.replacingOccurrences(of: " ", with: ""))
            }
        }
    }
    
    @State var taskNameToEdit: String = ""
    @State var taskDescriptionToEdit: String = ""
    @State var taskIndexToEdit: Int = -1
    @State var idToDelete: String = ""
    
    private var bindingIsTaskEditorShown: Binding<Bool> { Binding (
        get: { taskNameToEdit != "" && taskIndexToEdit != -1 },
        set: { _ in
                taskNameToEdit = ""
                taskIndexToEdit = -1
                taskDescriptionToEdit = ""
            }
        )
    }
    
    var body: some View {
        ForEach(filteredToDos.indices, id: \.self) { index in
            ToDoListRow(task: filteredToDos[index])
                .listRowBackground(rowColors[index % rowColors.count])
                .padding(.bottom, 5)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        idToDelete = filteredToDos[index].id
                        print(filteredToDos[index].name)
                        print(dataModel.defaultTasks.firstIndex(where: { $0.id == idToDelete })!)
                        print(filteredToDos.count)
                        withAnimation {
                            dataModel.deleteTask(task: filteredToDos[index])
                        }
                    } label: {
                        Image(systemName: "trash")
                    }
                    
                    Button {
                        taskIndexToEdit = dataModel.defaultTasks.firstIndex(where: { $0.id == filteredToDos[index].id })!
                        taskNameToEdit = filteredToDos[index].name
                        taskDescriptionToEdit = filteredToDos[index].description ?? ""
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .tint(.blue)
                }
        }
        .sheet(isPresented: bindingIsTaskEditorShown) {
            AddEditView(taskName: taskNameToEdit, taskDescription: taskDescriptionToEdit, taskIndex: taskIndexToEdit, adding: false)
        }
        .onAppear{
            print(dataModel.defaultTasks)
            print("filteredToDos: ")
            print(filteredToDos)
        }
    }
}

//struct ToDoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ToDoView()
//            .environmentObject(DataModel())
//            .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
