//
//  NewTaskItemView.swift
//  DevoteeApp
//
//  Created by Jash Dhinoja on 15/03/2023.
//

import SwiftUI

struct NewTaskItemView: View {
    //MARK: Properties
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var task: String = ""
    
    @Binding var isShowing: Bool
    
    //MARK: Handlers
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = task
            newItem.isCompleted = false
            newItem.id = UUID()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
            isShowing = false
        }
    }
    
    //MARK: Body
    var body: some View {
        VStack{
            Spacer()
            VStack(spacing: 16){
                TextField("New Task", text: $task)
                    .padding()
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                    .foregroundColor(.pink)
                    .font(.system(size: 24, weight: .bold ,design: .rounded))
                
                Button(action: {
                    addItem()
                    task = ""
                    hideKeyboard()
                }, label: {
                    Spacer()
                    Text("Save")
                        .font(.system(size: 24,weight: .bold, design: .rounded))
                    Spacer()
                })
                .padding()
                .font(.headline)
                .foregroundColor(.white)
                .background(task.isEmpty ? .gray : .blue)
                .cornerRadius(10)
                .disabled(task.isEmpty)
            }//: Inner VStack
            .padding(.horizontal)
            .padding(.vertical, 20)
            .background(.white)
            .cornerRadius(16)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 24)
            .frame(maxWidth: 640)
        }// VStack
        .padding()
    }
}

struct NewTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskItemView(isShowing: .constant(true))
            .background(Color.gray.ignoresSafeArea(.all))
    }
}