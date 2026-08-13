//
//  Property.swift
//  Stayly
//
//  Created by Vansh Vala on 13/08/26.
//


import Foundation

struct Property: Identifiable {
    let id = UUID()
    let title: String
    let location: String
    let price: Int
    let rating: Double
    let imageName: String
    let category: String
}
