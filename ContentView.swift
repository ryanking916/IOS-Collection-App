//
//  ContentView.swift
//  Collection
//
//  Created by Ryan King on 5/4/24.
//

import SwiftUI

// Main view for app, displays tabbed interface
struct ContentView: View {
    // holds collection data
    @ObservedObject private var collectionStore: CollectionStore = CollectionStore(collections: collectionData)
    
    var body: some View {
        TabView {
            // Tab for the collections list
            NavigationView {
                List {
                    // Iterates over each collection, using unique id for each element
                    ForEach(Array(collectionStore.collections.enumerated()), id: \.element.id) { index, collection in
                        ListCell(collection: $collectionStore.collections[index])
                    }
                    .onDelete(perform: deleteCollections) // allows deletion of collections
                    .onMove(perform: moveCollections) // allows reordering of collections
                }
                .navigationBarTitle("Collections")
                .navigationBarItems(leading: NavigationLink(destination: AddNewCollection(collectionStore: self.collectionStore)) {
                    Text("Add")
                        .foregroundColor(.blue)
                }, trailing: EditButton())
            }
            // tabbed items, with label and icon for the tab
            .tabItem {
                Label("Collections", systemImage: "list.bullet")
            }
            FavoritesView(collectionStore: collectionStore)
                .tabItem {
                    Label("Favorites", systemImage: "star")
                }
            WishlistView()
                .tabItem {
                    Label("Wishlist", systemImage:"heart")
                }
            
            ProfileView(collections: $collectionStore.collections)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
    
    // Function to delete collections
    func deleteCollections(at offsets: IndexSet) {
        collectionStore.collections.remove(atOffsets: offsets)
    }
    
    // Function to move collectins from one index to another
    func moveCollections(from source: IndexSet, to destination: Int) {
        collectionStore.collections.move(fromOffsets: source, toOffset: destination)
    }
}

// Custom view for displaying each collection in list
struct ListCell: View {
    @Binding var collection: Collection // Binding to collection object

    var body: some View {
        // Creates navigation link to collection detail view
        NavigationLink(destination: CollectionDetail(selectedCollection: $collection)) {
            HStack {
                // Asynchronously loads and displays an image from a URL
                AsyncImage(url: URL(string: collection.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Display during load
                    case .success(let image):
                        image.resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 100, height: 60)
                    case .failure:
                        Image("placeholder")
                             .resizable()
                             .aspectRatio(contentMode: .fit)
                             .frame(width: 100, height: 60)
                    @unknown default:
                        EmptyView()
                    }
                }
                Text(collection.name)
            }
        }
    }
}



// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
