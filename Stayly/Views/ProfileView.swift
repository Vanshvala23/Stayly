//
//  ProfileView.swift
//  Stayly
//
//  Created by Vansh Vala on 13/08/26.
//


import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 14) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.secondary)
                        
                        VStack(alignment: .leading) {
                            Text("Guest")
                                .font(.headline)
                            
                            Text("Welcome to Stayly")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section {
                    Label("Account", systemImage: "person")
                    Label("Settings", systemImage: "gearshape")
                    Label("Help", systemImage: "questionmark.circle")
                }
            }
            .navigationTitle("Profile")
        }
    }
}