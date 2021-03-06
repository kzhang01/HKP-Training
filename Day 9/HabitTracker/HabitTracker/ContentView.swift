//
//  ContentView.swift
//  HabitTracker
//
//  Created by Karina Zhang on 1/1/21.
//

import SwiftUI

struct Activity: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let timesCompleted: Int
}

class Activities: ObservableObject {
    @Published var items: [Activity] {
        didSet {
            saveActivities()
        }
    }
    
    func saveActivities() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: "Items")
        }
    }

    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Activity].self, from: items) {
                self.items = decoded
                return
            }
        }
        self.items = []
    }
}

struct ContentView: View {
    @ObservedObject var activities = Activities()
    @State private var showingAddActivity = false

    var body: some View {
        NavigationView {
            List {
                ForEach(activities.items) { item in
                    
                    NavigationLink(destination: DetailView(activities: self.activities, activity: item)) {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.description)
                            Text("Times completed: \(item.timesCompleted)")
                        }
                    }
                    
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("Activity Tracker")
            .navigationBarItems(
                leading: EditButton(),
                trailing: Button(action: {
                    self.showingAddActivity = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddActivity) {
                AddView(activities: self.activities)
            }
        }
    }

    func removeItems(at offsets: IndexSet) {
        activities.items.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
