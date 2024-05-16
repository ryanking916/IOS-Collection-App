//
//  CollectionStore.swift
//  Collection
//
//  Created by Ryan King on 5/4/24.
//

import Foundation
import SwiftUI
import Combine

// class that conforms to ObservableObject, allowing SwiftUI views to observe changes
class CollectionStore : ObservableObject {
    @Published var collections: [Collection]
    
    // Initializer for the CollectionStore
    init (collections: [Collection] = []) {
        self.collections = collections
    }
}

