//
//  CollectionDetail.swift
//  Collection
//
//  Created by Ryan King on 5/4/24.
//

import Foundation
import SwiftUI

// SwiftUI view for displaying details of a specific collection
struct CollectionDetail: View {
    @Binding var selectedCollection: Collection // Binding to the collection selected from the parent view
    @State private var searchText = "" // State for storing the search text to filter items within the collection
    @State private var isAddingNewItem = false

    // Computed property to calculate the total trending price of all items in the collection
    var totalTrendingPrice: Int {
        selectedCollection.items.reduce(0) { $0 + $1.trendingPrice }
    }
    
    // Computed property to filter items based on the search text
    var filteredItems: [Item] {
        if searchText.isEmpty {
            return selectedCollection.items
        } else {
            // Filter items where the item name or description contains the search text
            // Used Apple Developer Documentation to learn code below
            return selectedCollection.items.filter { item in
                item.name.localizedCaseInsensitiveContains(searchText) ||
                item.description.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        List {
            // List each item using filteredItems computed property
            ForEach(Array(filteredItems.enumerated()), id: \.element.id) { index, item in
                NavigationLink(destination: ItemDetail(item: $selectedCollection.items[index])) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name).font(.title2)
                            Text(item.description).lineLimit(1)
                        }
                        Spacer()
                        AsyncImage(url: URL(string: item.imageURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                     .aspectRatio(contentMode: .fill)
                                     .frame(width: 60, height: 60)
                                     .clipped()
                            case .failure:
                                Image(systemName: "photo") // Fallback image
                                     .frame(width: 60, height: 60)
                                     .background(Color.gray)
                                     .foregroundColor(.white)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                    }
                }
            }
            .onDelete(perform: deleteItem) // Enable deleting items directly from the list
        }
        // Make the list searchable
        // Used Apple Developer documentation to learn this code below
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .navigationBarTitle(Text(selectedCollection.name), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            isAddingNewItem = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $isAddingNewItem) {
            AddNewItem(collection: $selectedCollection)
        }
    }

    // Function to handle deleting items from the collection
    func deleteItem(at offsets: IndexSet) {
        selectedCollection.items.remove(atOffsets: offsets)
    }
}


struct CollectionDetail_Previews: PreviewProvider {
    static var previews: some View {
        let collection = collectionData[0]
        NavigationView {
            CollectionDetail(selectedCollection: .constant(collection))
        }
    }
}
