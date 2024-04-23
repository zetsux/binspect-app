//
//  Item.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 23/04/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
