//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Nicholas Johnson on 8/8/24.
//

import Foundation

@Observable
class Favorites {
    private var resorts: Set<String>
    
    private let key = "Favorites"
    
    let savePath = URL.documentsDirectory.appending(path: "SavedFavorites.json")
    
    init() {
        if let data = UserDefaults.standard.data(forKey: key) {
            if let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                resorts = decoded
                return
            }
        }

        resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
