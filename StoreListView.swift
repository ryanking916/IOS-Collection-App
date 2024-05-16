//
//  StoreListView.swift
//  Collection
//
//  Created by William Curtiss
//

import SwiftUI
//view after selecting Explore stores on profile view
struct StoreListView: View {
    //private state variables for stores including the name and link to store
    @State private var newStoreName = ""
    @State private var newStoreLink = ""
    
    @State private var isAddingStore = false
    
    @State private var stores = [
        ("Amazon", "https://www.amazon.com"),
        ("eBay", "https://www.ebay.com"),
        ("Walmart", "https://www.walmart.com"),
        ("Best Buy", "https://www.bestbuy.com"),
        ("Target", "https://www.target.com")
    ] // here is an example list of stores, when clicked it will take you to that stores internet page
    
    var body: some View {
        List {
            //listing each store as a hyperlink, for reference: https://developer.apple.com/documentation/swiftui/link
            ForEach(stores, id: \.0) { store, url in
                Link(store, destination: URL(string: url)!)
            }
        }
        .navigationBarTitle("Top Stores")
        .navigationBarItems(trailing:
            Button(action: {
                isAddingStore = true
            }) {
                Image(systemName: "plus")
            }
        )
        //implementing sheet / function to add stores to list
        .sheet(isPresented: $isAddingStore) {
            VStack {
                TextField("Store Name", text: $newStoreName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                TextField("Store Link", text: $newStoreLink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add Store") {
                    if !newStoreName.isEmpty && !newStoreLink.isEmpty {
                        stores.append((newStoreName, newStoreLink))
                        newStoreName = ""
                        newStoreLink = ""
                        isAddingStore = false
                    }
                }
                .padding()
            }
        }
    }
}

