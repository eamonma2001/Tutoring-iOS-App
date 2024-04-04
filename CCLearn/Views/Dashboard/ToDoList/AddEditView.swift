//
//  AddToDoView.swift
//  CCLearn
//
//  Created by Yuxuan Gu on 2023/11/13.
//

import Foundation
import SwiftUI

struct AddEditView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataModel: DataModel
    
    // Add state properties for the additional fields
    @State var taskName: String = ""
    @State var taskDescription: String = ""
    var taskIndex: Int = -1
    var adding: Bool = false
    var suggestTasks: [[String]] = [
        ["Morning Meditation", "Start your day with a peaceful meditation session. Find a quiet space, focus on your breath, and clear your mind. Set intentions for the day ahead to boost productivity and inner peace."],
        ["Daily Journaling", "Spend some time writing in a journal. Reflect on your thoughts, feelings, and experiences. It's a great way to organize your thoughts, track your progress, and foster creativity."],
        ["30-Minute Workout", "Engage in a quick workout routine. It could be a jog, yoga, or a home workout. Exercise boosts energy levels, improves mood, and enhances overall well-being."],
        ["Learn Something New", "Dedicate time to learn a new skill or topic of interest. It could be a language, musical instrument, cooking, or anything you've been curious about. Keep your mind active and continuously grow your knowledge."],
        ["Random Act of Kindness", "Perform a random act of kindness for someone. It could be as simple as complimenting a stranger, helping a neighbor, or volunteering for a local cause. Spread positivity and make someone's day better."],
        ["Digital Detox", "Take a break from screens for a set period. Unplug from devices, social media, and emails. Use this time to engage in activities like reading, spending time outdoors, or bonding with family and friends."],
        ["Healthy Meal Prep", "Plan and prepare a healthy meal for yourself or your family. Focus on nutritious ingredients and try new recipes. Eating well supports overall health and provides a sense of accomplishment."],
        ["Creative Expression", "Engage in a creative activity, such as painting, writing, crafting, or playing an instrument. Express yourself creatively to relieve stress and stimulate imagination."],
        ["Nature Walk", "Take a leisurely walk outdoors in nature. Enjoy the fresh air, observe the surroundings, and appreciate the beauty of nature. It helps in relaxation and reduces stress."],
        ["Mindfulness Practice", "Practice mindfulness exercises to enhance self-awareness and focus. Pay attention to the present moment without judgment, promoting mental clarity and emotional balance."],
        ["Reading Time", "Dive into a good book that interests you. Reading stimulates the mind, broadens knowledge, and offers an escape into different worlds or perspectives."],
        ["Home Spa Day", "Treat yourself to a relaxing spa day at home. Take a soothing bath, do a face mask, or enjoy a self-massage. Pampering yourself can rejuvenate both body and mind."],
        ["Volunteer Work", "Engage in volunteer activities in your community or virtually. Contribute your time and skills to help others in need, fostering a sense of purpose and making a positive impact."],
        ["Stretching Routine", "Spend time stretching your body to improve flexibility and reduce muscle tension. Incorporating stretching into your routine can help prevent injuries and promote relaxation."],
        ["Mind Mapping", "Create a mind map to organize thoughts, ideas, or plans visually. It's an effective technique for brainstorming, problem-solving, and organizing information."],
        ["Music Appreciation", "Listen to your favorite music or explore new genres. Music has a therapeutic effect on emotions and can uplift your mood or help in relaxation."],
        ["Photography Session", "Grab a camera or use your smartphone to capture interesting scenes or moments around you. Photography encourages creativity and allows you to see things from a different perspective."],
        ["DIY Project", "Embark on a do-it-yourself (DIY) project. It could be crafting, home decor, or repairs. DIY projects offer a sense of accomplishment and can be both fun and rewarding."]
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Text("Task Name: ")
                        .foregroundColor(.brown) // Set label color
                        .fontWeight(.bold)
                        .padding(.trailing, 10)
                    TextField(text: $taskName, prompt: Text("What's your task?"), label: {() in Text("What's your task?")})
                    Text("Task Description: ")
                        .foregroundColor(.brown) // Set label color
                        .fontWeight(.bold)
                        .padding(.trailing, 10)
                    TextEditor(text: $taskDescription)
                        .frame(width: 300, height: 300, alignment: .leading)
                }
                Spacer() // Ensure space between form and animation
                
                Button(action: {
                    let randomTask = suggestTasks.randomElement()!
                    taskName = randomTask[0]
                    taskDescription = randomTask[1]
                }) {
                    Text("Want some Ideas? Click Me!")
                        .font(.headline)
                        .padding()
                        .cornerRadius(10)
                }
            }
            .navigationTitle("Add / Edit a Task")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    if adding {
                        dataModel.addTasks(tasks: [Task(id: UUID().uuidString + dataModel.currUser.name.replacingOccurrences(of: " ", with: ""),
                                                        name: taskName, description: taskDescription)])
                    } else {
                        dataModel.updateTask(task: dataModel.defaultTasks[taskIndex], taskName: taskName, taskDescription: taskDescription)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

