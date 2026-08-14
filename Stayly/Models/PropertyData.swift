//
//  PropertyData.swift
//  Stayly
//
//  Created by Vansh Vala on 15/08/26.
//


import Foundation

let staylyProperties: [Property] = [
    Property(
        title: "Modern Mountain Cabin",
        location: "Manali, India",
        price: 4500,
        rating: 4.92,
        imageName: "cabin",
        category: "Cabins",
        description: "Enjoy a peaceful stay surrounded by the beautiful mountains of Manali. This cozy cabin is perfect for relaxing, exploring the area, and spending quality time away from the city.",
        hostName: "Vijay",
        reviewCount: 128,
        guests: 4,
        bedrooms: 2,
        beds: 2,
        bathrooms: 1,
        amenities: [
            Amenity(icon: "wifi", name: "Free Wi-Fi"),
            Amenity(icon: "car.fill", name: "Free parking"),
            Amenity(icon: "fork.knife", name: "Kitchen"),
            Amenity(icon: "snowflake", name: "Air conditioning"),
            Amenity(icon: "mountain.2.fill", name: "Mountain view"),
            Amenity(icon: "laptopcomputer", name: "Workspace")
        ]
    ),

    Property(
        title: "Beachfront Villa",
        location: "Goa, India",
        price: 6200,
        rating: 4.87,
        imageName: "beach",
        category: "Beach",
        description: "Relax in this beautiful beachfront villa with stunning ocean views and easy access to the beach.",
        hostName: "Aarav",
        reviewCount: 96,
        guests: 6,
        bedrooms: 3,
        beds: 3,
        bathrooms: 2,
        amenities: [
            Amenity(icon: "wifi", name: "Free Wi-Fi"),
            Amenity(icon: "water.waves", name: "Beach access"),
            Amenity(icon: "car.fill", name: "Free parking"),
            Amenity(icon: "fork.knife", name: "Kitchen"),
            Amenity(icon: "snowflake", name: "Air conditioning")
        ]
    ),

    Property(
        title: "Luxury City Apartment",
        location: "Mumbai, India",
        price: 3800,
        rating: 4.81,
        imageName: "city",
        category: "Cities",
        description: "A modern city apartment in the heart of Mumbai, perfect for business trips and exploring the city.",
        hostName: "Riya",
        reviewCount: 74,
        guests: 3,
        bedrooms: 1,
        beds: 2,
        bathrooms: 1,
        amenities: [
            Amenity(icon: "wifi", name: "Free Wi-Fi"),
            Amenity(icon: "building.2.fill", name: "City view"),
            Amenity(icon: "car.fill", name: "Free parking"),
            Amenity(icon: "snowflake", name: "Air conditioning"),
            Amenity(icon: "laptopcomputer", name: "Workspace")
        ]
    )
]
