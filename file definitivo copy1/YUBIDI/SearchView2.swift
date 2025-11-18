//
//  SearchView2.swift
//  YUBIDI
//
//  Created by Matilde Davide on 13/11/25.
//

import SwiftUI

struct SearchView2: View {
    @State private var searchText = ""
    
    private let categories = [
        Category(name: "Latin Music", color: Color(red: 0.9, green: 0.7, blue: 0.5)),
        Category(name: "Pop", color: Color(red: 0.8, green: 0.4, blue: 0.6)),
        Category(name: "Rock", color: Color(red: 0.5, green: 0.3, blue: 0.7)),
        Category(name: "Hip-Hop", color: Color(red: 0.9, green: 0.5, blue: 0.3)),
        Category(name: "Jazz", color: Color(red: 0.4, green: 0.6, blue: 0.8)),
        Category(name: "Classical", color: Color(red: 0.6, green: 0.5, blue: 0.7)),
        Category(name: "Electronic", color: Color(red: 0.3, green: 0.8, blue: 0.6)),
        Category(name: "Country", color: Color(red: 0.9, green: 0.7, blue: 0.4)),
        Category(name: "R&B", color: Color(red: 0.7, green: 0.4, blue: 0.5)),
        Category(name: "Indie", color: Color(red: 0.5, green: 0.7, blue: 0.6))
    ]
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(categories) { category in
                            NavigationLink(destination: CategoryDetailView(category: category)) {
                                CategoryCard(category: category)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct CategoryCard: View {
    let category: Category
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 8)
                .fill(category.color)
                .frame(height: 100)
            
            Text(category.name)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .padding(12)
        }
    }
}

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let color: Color
}

struct CategoryDetailView: View {
    let category: Category
    
    var body: some View {
        VStack {
            Text(category.name)
                .font(.largeTitle)
                .bold()
            Text("Category content goes here")
                .foregroundColor(.gray)
        }
        .navigationTitle(category.name)
    }
}

#Preview {
    SearchView2()
}
