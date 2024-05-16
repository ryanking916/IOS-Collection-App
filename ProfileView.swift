//
//  ProfileView.swift
//  Collection
//
//  Created by Ryan King and William Curtiss
//

import SwiftUI

// Defines SwiftUI view that displays user and collection information
struct ProfileView: View {
    // State variables for user input fields.
    @State private var username = ""
    @State private var email = ""
    
    @Binding var collections: [Collection]
    
    // Computed property to calculate the total value of all items across all collections
    var totalValue: Int {
        collections.reduce(0) { total, collection in
            total + collection.items.reduce(0) { subtotal, item in
                subtotal + item.trendingPrice
            }
        }
    }
    
    // Computed property to find the most valuable item among all collections
    var mostValuableItem: Item? {
        collections.flatMap { $0.items }.max(by: { $0.trendingPrice < $1.trendingPrice })
    }
    
    // Computed property to determine the most active category based on the number of items
    var mostActiveCategory: (name: String, count: Int)? {
        collections.map { ($0.name, $0.items.count) }
                   .max(by: { $0.count < $1.count })
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                // Section for user information input
                Section(header: Text("User Information")) {
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        VStack(alignment: .leading) {
                            TextField("Enter Username", text: $username)
                                .font(.headline)
                            TextField("Enter Email", text: $email)
                                .foregroundColor(.gray)
                        }
                    }
                }
                // Section displaying the total value of all collections
                Section(header: Text("Total Value of Collections")) {
                    Text("$\(totalValue)")
                        .font(.title)
                }
                // Section for displaying the most valuable item
                Section(header: Text("Most Valuable Item")) {
                    if let item = mostValuableItem {
                        Text("\(item.name) - $\(item.trendingPrice)")
                    } else {
                        Text("No items available")
                    }
                }
                // Section for displaying the most active category
                Section(header: Text("Most Active Category")) {
                    if let category = mostActiveCategory {
                        Text("\(category.name) with \(category.count) items")
                    } else {
                        Text("No categories available")
                    }
                }
                
                // Navigation link to another view for exploring top stores
                Section(header: Text("Top Stores")) {
                    NavigationLink(destination: StoreListView()) {
                        Text("Explore Top Stores")
                    }
                }
            }
            .navigationBarTitle("Profile", displayMode: .large)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    // Created mock data for collections
    static let mockCollections = [
        Collection(id: "1", name: "Collection 1", description: "Description 1", imageURL: "ImageName1", items: [
            Item(id: "1", name: "Item 1", description: "Description Item 1", trendingPrice: 100, collectionName: "Collection", imageURL: "Image URL"),
            Item(id: "2", name: "Item 2", description: "Description Item 2", trendingPrice: 150, collectionName: "Collection", imageURL: "Image URL")
        ]),
        Collection(id: "2", name: "Collection 2", description: "Description 2", imageURL: "ImageName2", items: [
            Item(id: "3", name: "Item 3", description: "Description Item 3", trendingPrice: 200, collectionName: "Collection", imageURL: "Image URL")
        ])
    ]
    
    static var previews: some View {
        ProfileView(collections: .constant(mockCollections))
    }
}


