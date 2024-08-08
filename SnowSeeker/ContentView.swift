//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Nicholas Johnson on 8/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var favorites = Favorites()
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @State private var searchText = ""
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            resorts
        } else {
            resorts.filter { $0.name.localizedStandardContains(searchText)}
        }
    }
    
    enum SortOrder {
        case `default`, name, country
    }
    var sortedResorts: [Resort] {
        switch sortOrder {
        case .default:
            filteredResorts
        case .name:
            filteredResorts.sorted { $0.name < $1.name }
        case .country:
            filteredResorts.sorted { $0.country < $1.country }
        }
    }
    
    @State var sortOrder = SortOrder.default

    var body: some View {
        NavigationSplitView {
            List(sortedResorts) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                .rect(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                ToolbarItem {
                    Menu("Sort") {
                        Picker("Sort by", selection: $sortOrder) {
                            
                            Text("Default")
                                .tag(SortOrder.default)
                            
                            Text("Name")
                                .tag(SortOrder.name)
                            
                            Text("Country")
                                .tag(SortOrder.country)
                            
                            
                        }
                    }
                }
            }
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview {
    ContentView(sortOrder: .name)
}


struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker!")
                .font(.largeTitle)

            Text("Please select a resort from the left-hand menu; swipe from the left edge to show it.")
                .foregroundStyle(.secondary)
        }
    }
}
