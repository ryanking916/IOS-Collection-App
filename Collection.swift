//
//  Collection.swift
//  Collection
//
//  Created by Will Curtiss on 5/4/24.
//

import Foundation
import SwiftUI

// Defines a Collection struct to represent collections data in the app
struct Collection : Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    var imageURL: String
    var items: [Item]
}
