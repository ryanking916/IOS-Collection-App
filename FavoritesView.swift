//
//  FavoritesView.swift
//  Collection
//
//  Created by Ryan King on 5/6/24.
//

import SwiftUI

// Defines view to display favorite items from all collections
struct FavoritesView: View {
    @ObservedObject var collectionStore: CollectionStore
    
    // Computed property to retrieve favorite items from all collections.
    var favoriteItems: [(item: Item, collectionIndex: Int, itemIndex: Int)] {
        var results = [(item: Item, collectionIndex: Int, itemIndex: Int)]()
        for (collectionIndex, collection) in collectionStore.collections.enumerated() {
            for (itemIndex, item) in collection.items.enumerated() where item.isFavorite {
                results.append((item, collectionIndex, itemIndex))
            }
        }
        return results
    }
    
    var body: some View {
        NavigationView {
            List {
                // Iterate over favorite items to create a list
                ForEach(favoriteItems, id: \.item.id) { favorite in
                    NavigationLink(destination: ItemDetail(item: $collectionStore.collections[favorite.collectionIndex].items[favorite.itemIndex])) {
                        VStack(alignment: .leading) {
                            Text(favorite.item.name).font(.headline)
                            Text("Collection: \(favorite.item.collectionName)")
                            Text("Price: $\(favorite.item.trendingPrice)").font(.subheadline)
                        }
                        Spacer()
                        // Load and display image from a URL with handling for various states
                        AsyncImage(url: URL(string: favorite.item.imageURL)) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .clipped() // Clip to bounds of the frame.
                            case .failure:
                                Image(systemName: "photo") // Placeholder image if the load fails
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray)
                                    .foregroundColor(.white)
                            @unknown default:
                                EmptyView()
                            }
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)                    }
                }
            }
            .navigationBarTitle("Favorites")
        }
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleCollections = [Collection(
            id: "1",
            name: "Collection 1",
            description: "Desc 1",
            imageURL: "URL-to-image",
            items: [
                Item(
                    id: "1",
                    name: "Item 1",
                    description: "Desc Item 1",
                    trendingPrice: 100,
                    isFavorite: true,
                    collectionName: "Collection",
                    imageURL: "URL-to-item-image"  // Provided imageURL
                ),
                Item(
                    id: "2",
                    name: "Item 2",
                    description: "Desc Item 2",
                    trendingPrice: 150,
                    isFavorite: false,
                    collectionName: "Collection",
                    imageURL: "URL-to-item-image"  // Provided imageURL
                )
            ]
        )]
        let store = CollectionStore(collections: sampleCollections)
        
        return FavoritesView(collectionStore: store)
    }
}


