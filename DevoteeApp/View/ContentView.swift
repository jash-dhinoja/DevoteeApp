//
//  ContentView.swift
//  DevoteeApp
//
//  Created by Jash Dhinoja on 15/03/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    //MARK: Properties
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var task: String = ""
    
    
    //MARK: Body
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    VStack(spacing: 16){
                        TextField("New Task", text: $task)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(10)
                        Button(action: {
                            addItem()
                            task = ""
                            hideKeyboard()
                        }, label: {
                            Spacer()
                            Text("Save")
                            Spacer()
                        })
                        .padding()
                        .font(.headline)
                        .foregroundColor(.white)
                        .background(task.isEmpty ? .gray : .pink)
                        .cornerRadius(10)
                        .disabled(task.isEmpty)
                    }//: Inner VStack
                    .padding()
                    
//                    Item List View
                    List {
                        ForEach(items) { item in
                            NavigationLink {
                                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                            } label: {
                                VStack(alignment: .leading) {
                                    Text(item.task ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                    Text(item.timestamp!, formatter: itemFormatter)
                                        .font(.footnote)
                                        .foregroundColor(.gray)
                                }
                            }
                        }// For Each item
                        .onDelete(perform: deleteItems)
                    }// List View
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .listRowBackground(Color.clear)
                    .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.3), radius: 12)
                    .padding(.vertical,0)
                    .frame(maxWidth: 640)
                    
                }//: Outer VStack
            }//: ZStack
            .navigationTitle("Daily Tasks")
            .background(BackgroundImageView())
            .background(backgroundGradient.ignoresSafeArea(.all))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .onAppear(){
                UITableView.appearance().backgroundColor = UIColor.clear
            }
        }//: Stack Navigation View
    }
    
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
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

//MARK: Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
