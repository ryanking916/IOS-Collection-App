//
//  CollectionData.swift
//  Collection
//
//  Created by Will Curtiss on 5/4/24.
//

import Foundation
import UIKit
import SwiftUI

// global variable holds the collection data loaded from a JSON file
var collectionData: [Collection] = loadJson("data.json")

// function to load JSON data from a file
func loadJson<T: Decodable>(_ filename: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename,
                                     withExtension: nil)
    else {
        fatalError("\(filename) not found.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Could not load \(filename): \(error)")
    }
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        fatalError("Unable to parse \(filename): \(error)")
    }
}
