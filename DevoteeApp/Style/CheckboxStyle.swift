//
//  CheckboxStyle.swift
//  DevoteeApp
//
//  Created by Jash Dhinoja on 19/03/2023.
//

import SwiftUI

struct CheckboxStyle: ToggleStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        return HStack{
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .foregroundColor(configuration.isOn ? .pink : .primary)
                .font(.system(size: 30,weight: .semibold,design: .rounded))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
            Spacer()
            configuration.label
        }// HStack
    }
    
}

struct CheckboxStyle_Previews: PreviewProvider {
    static var previews: some View {
        Toggle("PlaceHolder label ", isOn: .constant(true))
            .padding()
            .previewLayout(.sizeThatFits)
            .toggleStyle(CheckboxStyle())
    }
}
