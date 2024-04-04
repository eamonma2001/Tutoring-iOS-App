//
//  Checkbox.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/11/13.
//

import Foundation
import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool
    @EnvironmentObject var dataModel: DataModel
    var task: Task
    var body: some View {
        Image(systemName: isChecked ? "checkmark.square.fill" : "square")
            .resizable()
            .frame(width: 25, height: 25, alignment: .center)
            .foregroundColor(isChecked ? Color(UIColor.systemBlue) : Color.secondary)
            .onTapGesture {
                isChecked.toggle()
                dataModel.updateTask(task: task, taskName: task.name, taskDescription: task.description ?? "", isCompleted: isChecked)
            }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox(isChecked: .constant(true), task: Task(id: UUID().uuidString + "ZihanCao", name: "Finish ECE 564 homework", description: "Hmm..."))
    }
}
