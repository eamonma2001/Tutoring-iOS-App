//
//  SlotView.swift
//  CCLearn
//
//  Created by Eamon Ma on 11/20/23.
//

import SwiftUI

struct SlotView: View {
    @State var slot: TimeSlot
    @Binding var selection: TimeSlot?
    @Binding var selections: [TimeSlot]
    
    var body: some View {
        Button {
           if selections.contains(where: { $0 == slot }) {
               selections.removeAll { $0 == slot }
           } else {
               selections.append(slot)
           }
       } label: {
           Label(slot: slot, isSelected: selections.contains { $0 == slot })
       }
       .buttonStyle(.plain)
    }
}

/// Styles the button according to its selection status.
private struct Label: View {
    var slot: TimeSlot
    var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading) {
                Text(timeString(from: slot.start.foundationDate))
                    .bold()
                    .foregroundStyle(shapeStyle(Color.primary))
                    .font(.system(size: 15))
            }
        }
        .shadow(radius: isSelected ? 3 : 0)
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(isSelected ? Color.blue : Color.clear)
        }
    }
    
    func shapeStyle<S: ShapeStyle>(_ style: S) -> some ShapeStyle {
        isSelected ? AnyShapeStyle(.background) : AnyShapeStyle(style)
    }
    
    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}


struct SlotView_Previews: PreviewProvider {
    static var previews: some View {
        SlotView(slot: testTime, selection: .constant(nil), selections: .constant([]))
    }
}


