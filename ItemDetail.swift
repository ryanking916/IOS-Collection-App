//
//  ItemDetail.swift
//  Collection
//
//  Created by Ryan King on 5/5/24.
//

import Foundation
import SwiftUI

// SwiftUI view to display detailed info about an item
struct ItemDetail: View {
    // Binding to an Item object
    @Binding var item: Item
    // State variable to track the favorite status independently within this view
    @State private var isFavorite: Bool
    
    // Initializer sets up bindings and initializes state variables
    init(item: Binding<Item>) {
        self._item = item
        _isFavorite = State(initialValue: item.wrappedValue.isFavorite)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Asynchronously load and display an image from a URL
                AsyncImage(url: URL(string: item.imageURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 300, maxHeight: 300)
                    case .failure:
                        Image(systemName: "photo") // Placeholder image if the load fails
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 10)
                .padding()
                
                Text(item.name)
                    .font(.title)
                    .padding()
                
                Text(item.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Text("Trending Price: $\(item.trendingPrice)")
                    .font(.headline)
                // Toggle for marking the item as a favorite
                Toggle("Favorite", isOn: Binding(
                    get: { item.isFavorite },
                    set: { newValue in
                        item.isFavorite = newValue
                    }
                ))
                .toggleStyle(SwitchToggleStyle(tint: .blue))
                .padding()
                
                Spacer()
            }
        }
        .navigationBarTitle("Item Detail", displayMode: .inline)
    }
}

// Preview
struct ItemDetail_Previews: PreviewProvider {
    static var previews: some View {
        let sampleItem = Item(id: "0", name: "Collectible", description: "A collectible", trendingPrice: 0, isFavorite: false, collectionName: "Collection", imageURL: "URL-to-Image")
        NavigationView {
            ItemDetail(item: .constant(sampleItem)) // Pass a constant binding of the sample item to the view
        }
    }
}
