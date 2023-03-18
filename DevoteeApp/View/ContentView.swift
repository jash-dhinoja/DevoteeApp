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
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false
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
                    HStack(spacing: 10){
//                    Title
                        Text("Devotee")
                            .font(.system(.largeTitle,design: .rounded))
                            .fontWeight(.heavy)
                            .padding(.leading,4)
                            
                        Spacer()

//                        Edit Button
                        EditButton()
                        .font(.system(size: 16,weight: .semibold))
                        .padding(.horizontal,10)
                        .frame(minWidth: 70,minHeight: 24)
                        .background(
                            Capsule()
                                .stroke(Color.white, lineWidth: 2)
                        )
//                        Appearance Button
                        Button(action: {
                            isDarkMode.toggle()
                        }, label: {
                            Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                                .resizable()
                                .frame(width: 24,height: 24)
                                .font(.system(.title,design: .rounded))
                        })
                        
                        
                    }// Header HStack
                    .padding()
                    .foregroundColor(.white)
                    
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
            .toolbar(.hidden)
            .background(BackgroundImageView())
            .background(backgroundGradient.ignoresSafeArea(.all))
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
