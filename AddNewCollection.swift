//
//  AddNewCollection.swift
//  Collection
//
//  Created by Ryan King on 5/4/24.
//

import Foundation
import SwiftUI

// SwiftUI view for adding a new collection to the app
struct AddNewCollection: View {
    // Observable object that stores the collection data
    @ObservedObject var collectionStore: CollectionStore
    
    // State variables for storing user inputs from the form
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var imageURL: String = ""
    @State private var trendingPriceString: String = ""
    @State private var trendingPrice: Int = 0
    @State private var items: [Item] = [] // List of items within the collection

    var body: some View {
        NavigationView {
            Form {
                // Section for inputting the basic details of the collection
                Section(header: Text("Collection Details")) {
                    TextField("Name", text: $name)
                    TextField("Description", text: $description)
                    TextField("Image URL", text: $imageURL)
                }
                // Section for managing items within the collection
                Section(header: Text("Items")) {
                    // Loop over the indices of items to provide views for each item
                    ForEach(items.indices, id: \.self) { index in
                        ItemInputView(item: $items[index])
                    }
                    // Button to add a new item to the collection
                    Button(action: {
                        items.append(Item(id: UUID().uuidString, name: "", description: "", trendingPrice: 0, collectionName: "", imageURL: ""))
                    }) {
                        Text("Add New Item")
                    }
                }
                // Section with a button to save the collection
                Section {
                    Button(action: saveCollection) {
                        Text("Save Collection")
                    }
                }
            }
            .navigationTitle("Add New Collection")
        }
    }
    // Function to save the new collection to the collection store
    private func saveCollection() {
        let newCollection = Collection(id: UUID().uuidString, name: name, description: description, imageURL: imageURL, items: items)
        collectionStore.collections.append(newCollection)
        // Reset fields after saving
        name = ""
        description = ""
        imageURL = ""
        items = []
    }
}

// Subview for inputting and editing details of an item in the collection
struct ItemInputView: View {
    @Binding var item: Item // Binding to an item for two way data flow
    @State private var trendingPriceString: String // State for handling the item's price input as a string
    
    // Initialize the view with a binding to an item
    init(item: Binding<Item>) {
        self._item = item
        self._trendingPriceString = State(initialValue: String(item.wrappedValue.trendingPrice))
    }
    
    var body: some View {
        VStack {
            TextField("Item Name", text: $item.name)
            TextField("Item Description", text: $item.description)
            TextField("Trending Price", text: $trendingPriceString)
                .keyboardType(.numberPad)
                .onSubmit {
                    if let trendingPrice = Int(trendingPriceString) {
                        item.trendingPrice = trendingPrice
                    } else {
                        trendingPriceString = String(item.trendingPrice)  // revert if invalid
                    }
                }
                .onChange(of: trendingPriceString) { newValue in
                    if let price = Int(newValue) {
                        item.trendingPrice = price
                    }
                }
        }
    }
}


struct AddNewCollection_Previews: PreviewProvider {
    static var previews: some View {
        AddNewCollection(collectionStore: CollectionStore(collections: collectionData))
    }
}
