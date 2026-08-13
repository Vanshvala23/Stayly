//
//  TripsView.swift
//  Stayly
//
//  Created by Vansh Vala on 13/08/26.
//


import SwiftUI

struct TripsView: View {
    var body: some View {
        NavigationStack {
            ContentUnavailableView(
                "No Trips",
                systemImage: "suitcase",
                description: Text("Your upcoming stays will appear here.")
            )
            .navigationTitle("Trips")
        }
    }
}