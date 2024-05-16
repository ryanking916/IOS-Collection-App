//
//  AddNewItem.swift
//  Collection
//
//  Created by Ryan King on 5/5/24.
//

import SwiftUI

// SwiftUI view for adding a new item to a collection
struct AddNewItem: View {
    // Binding to the collection to which the new item will be added
    @Binding var collection: Collection
    // State variables to store user inputs for the new item
    @State private var itemName: String = ""
    @State private var itemDescription: String = ""
    @State private var itemImageURL: String = ""
    @State private var trendingPrice: Int = 0
    @State private var buttonColor = Color.blue

    var body: some View {
        NavigationView {
            Form {
                // Text fields for entering new item details
                TextField("Item Name", text: $itemName)
                TextField("Item Description", text: $itemDescription)
                TextField("Image URL", text: $itemImageURL)
                TextField("Trending Price", value: $trendingPrice, format: .number)
                Button("Add Item") {
                    addItem()
                }
                .padding()
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .navigationBarTitle("Add New Item", displayMode: .inline)
        }
    }
    
    // Function to add the new item to the collection and reset the form
    private func addItem() {
        let newItem = Item(id: UUID().uuidString, name: itemName, description: itemDescription, trendingPrice: trendingPrice, collectionName: collection.name, imageURL: itemImageURL)
        collection.items.append(newItem)
        itemName = ""
        itemImageURL = ""
        itemDescription = ""
        trendingPrice = 0
        
        // Change button color to green to indicate added item
        withAnimation(.easeInOut(duration: 0.5)) {
            buttonColor = .green
        }
        
        // Reset the color back to blue after 0.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                buttonColor = .blue
            }
        }
    }
}


struct AddNewItem_Previews: PreviewProvider {
    @State static var previewCollection = Collection(id: "0", name: "Preview Collection", description: "This is a preview collection.", imageURL: "", items: [])
    
    static var previews: some View {
        AddNewItem(collection: $previewCollection)
    }
}

