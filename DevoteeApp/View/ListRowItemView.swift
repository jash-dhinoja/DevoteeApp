//
//  ListRowItemView.swift
//  DevoteeApp
//
//  Created by Jash Dhinoja on 19/03/2023.
//

import SwiftUI

struct ListRowItemView: View {
    //MARK: Properties
    @Environment(\.managedObjectContext) var viewContext
    @ObservedObject var item: Item
    
    //MARK: Body
    var body: some View {
        Toggle(isOn: $item.isCompleted){
            Text(item.task ?? "")
                .font(.system(.title2,design: .rounded))
                .fontWeight(.heavy)
                .padding(.vertical, 12)
                .foregroundColor(item.isCompleted ? .pink : .primary)
        }// Toggle
        .toggleStyle(CheckboxStyle())
        .onReceive(item.objectWillChange, perform: { _ in
            if self.viewContext.hasChanges{
                try? self.viewContext.save()
            }
        })
    }
}

//struct ListRowItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListRowItemView()
//    }
//}
