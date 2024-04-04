//
//  NotificationBadge.swift
//  CCLearn
//
//  Created by Eamon Ma on 11/27/23.
//

import Foundation
import SwiftUI


// Notification badge view
struct NotificationBadge: View {
    let count: Int // Number to display in the badge

    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.red)
                .frame(width: 20, height: 20)
            Text("\(count)")
                .foregroundColor(.white)
                .font(.system(size: 12))
        }
    }
}

struct NotificationBadge_Previews: PreviewProvider {
    static var previews: some View {
        NotificationBadge(count: 1)
    }
}
