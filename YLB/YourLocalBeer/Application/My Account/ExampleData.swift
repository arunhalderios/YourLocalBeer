//
//  ExampleData.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 8/1/17.
//  Copyright © 2017 Yong Su. All rights reserved.
//

import Foundation

//
// MARK: - Section Data Structure
//
public struct Item {
    var name: String
    
    public init(name: String) {
        self.name = name
    }
}

public struct Section {
    var name: String
    var items: [Item]
    var collapsed: Bool
    
    public init(name: String, items: [Item], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

public var sectionsData: [Section] = [
    Section(name: "Beers", items: [
        Item(name: "Reviews"),
        Item(name: "Photos & Descriptions"),
        Item(name: "My Beers")
    ]),
    Section(name: "Breweries", items: [
        Item(name: "Photos & Descriptions"),
        Item(name: "My Breweries")
        ]),
    Section(name: "Bars & Restaurants", items: [
        Item(name: "Reviews"),
        Item(name: "Photos & Descriptions"),
        Item(name: "My Bars & Restaurants")
    ]),
    Section(name: "Bottle Shops", items: [
        Item(name: "Reviews"),
        Item(name: "Photos & Descriptions"),
        Item(name: "My Bottle Shops")
        ]),
    
//    Section(name: "Others", items: [
//        Item(name: "Events"),
//        Item(name: "Achievements"),
//        Item(name: "Local Craft Beer Scene")
//        ])
]
