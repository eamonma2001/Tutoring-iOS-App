//
//  ToDoRow.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/11/13.
//

import Foundation
import SwiftUI

struct ToDoListRow: View {
    var task: Task
    @EnvironmentObject var dataModel: DataModel
    var taskIndex: Int {
        dataModel.defaultTasks.firstIndex(where: {
            $0.id == task.id
        }) ?? 0
    }
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .font(.headline)
                Text(task.description != nil && task.description != "" ? task.description! : "No description")
                    .font(.subheadline)
                    .lineLimit(nil) // Allow unlimited lines
                    .truncationMode(.tail)
            }
            Spacer()
            Checkbox(isChecked: Binding<Bool>(
                get: { self.dataModel.defaultTasks[taskIndex].isDone ?? false },
                set: { self.dataModel.defaultTasks[taskIndex].isDone = $0 }
            ), task: task)

        }
    }
}

struct ToDoListRow_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListRow(task: DataModel().defaultTasks[0])
            .environmentObject(DataModel())
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
