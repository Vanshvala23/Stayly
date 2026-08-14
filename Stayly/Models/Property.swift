//
//  Property.swift
//  Stayly
//
//  Created by Vansh Vala on 13/08/26.
//


import Foundation
struct Amenity {
    let icon: String
    let name: String
}

struct Property: Identifiable {
    let id = UUID()
    
    let title: String
    let location: String
    let price: Int
    let rating: Double
    let imageName: String
    let category: String
    
    let description: String
    
    let hostName: String
    let reviewCount: Int
    
    let guests: Int
    let bedrooms: Int
    let beds: Int
    let bathrooms: Int
    
    let amenities: [Amenity]
}
