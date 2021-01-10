//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Karina Zhang on 1/9/21.
//

import SwiftUI

class Favorites: ObservableObject {
    // the actual resorts the user has favorited
    private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    init() {
        if let data = UserDefaults.standard.data(forKey: self.saveKey){
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data){
                self.resorts = decoded
                return
            }
        }

        self.resorts = []
    }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(resorts){
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
}
