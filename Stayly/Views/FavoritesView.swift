//
//  FavoritesView.swift
//  Stayly
//
//  Created by Vansh Vala on 13/08/26.
//


import SwiftUI

struct FavoritesView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Favorites",
                systemImage: "heart",
                description: Text("Places you save will appear here.")
            )
            .navigationTitle("Favorites")
        }
    }
}