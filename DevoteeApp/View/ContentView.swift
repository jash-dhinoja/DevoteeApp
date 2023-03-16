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
    
    @State private var isNewTaskItemViewVisible: Bool = false
    
    //MARK: Body
    var body: some View {
        NavigationStack {
            ZStack {
                // Main View
                VStack {
//                    Header
                    Spacer(minLength: 80)
                    
//                    New Task Button
                    Button(action: {
                        isNewTaskItemViewVisible = true
                    }, label: {
                        Image(systemName: "plus.circle")
                            .font(.system(size: 30,weight: .semibold,design: .rounded))
                        Text("New Task")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    })
                    .foregroundColor(.white)
                    .padding(.horizontal,20)
                    .padding(.vertical,15)
                    .background(LinearGradient(gradient: Gradient(colors: [.pink,.blue]), startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .shadow(color: Color(red: 0, green: 0, blue: 0,opacity: 0.25),radius: 2,x: 0,y: 4)
                    
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
                
//                New Task Item View
                if isNewTaskItemViewVisible{
                    BlankView()
                        .onTapGesture {
                            withAnimation(){
                                isNewTaskItemViewVisible = false
                            }
                        }
                    NewTaskItemView(isShowing: $isNewTaskItemViewVisible)
                }
                
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
