//
//  LibraryView2.swift
//  YUBIDI
//
//  Created by Matilde Davide on 13/11/25.
//




import SwiftUI

struct LibraryViewPlus: View {
    @State private var currentLayout: String = "List"
    @State private var showingAddSheet = false

    @State private var playlists: [Playlist] = []

    struct Playlist: Identifiable {
        let id = UUID()
        var name: String
        var image: UIImage?
    }

    private let items: [(String, String, String)] = [
        ("Favourite", "heart", "favourite_cover"),
        ("Recents", "clock", "recents_cover")
    ]

    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            VStack {
                contentView
            }
            .navigationTitle("Library")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {

                    Button(action: {
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .foregroundStyle(.indigo)
                    }

                    Menu {
                        Button {
                            currentLayout = "List"
                        } label: {
                            Label("List", systemImage: "list.bullet")
                        }

                        Button {
                            currentLayout = "Grid"
                        } label: {
                            Label("Grid", systemImage: "square.grid.2x2")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(.indigo)
                    }
                }
            }
            .sheet(isPresented: $showingAddSheet) {
                NewPlaylistView { name, image in
                    playlists.append(Playlist(name: name, image: image))
                }
            }
        }
    }

    // MARK: - CONTENT VIEW
    private var contentView: some View {
        Group {
            // ---------- GRID VIEW ----------
            if currentLayout == "Grid" {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {

                       
                        ForEach(items.indices, id: \.self) { index in
                            let item = items[index]

                            NavigationLink(destination: Text(item.0)) {
                                ZStack(alignment: .bottomTrailing) {

                                    Image("Favourite folder") // ← QUI METTIAMO LA COPERTINA DIVERSA PER OGNI CARD
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 170, height: 170)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))

                                    // 🆕 TITOLO IN BASSO A DESTRA
                                    Text(item.0)
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        
                                        .padding(10)
                                }
                                .frame(width: 170, height: 170)
                            }
                        }


                        
                        ForEach(playlists) { playlist in
                            NavigationLink(destination: Text(playlist.name)) {

                                VStack(spacing: 10) {
                                    if let img = playlist.image {
                                        Image(uiImage: img)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 170, height: 170)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.gray.opacity(0.3))
                                            .frame(width: 170, height: 170)
                                    }

                                    Text(playlist.name)
                                        .font(.headline)
                                }
                                .frame(width: 170, height: 200)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                }

            // ---------- LIST VIEW ----------
            } else {
                List {

                    ForEach(items.indices, id: \.self) { index in
                        let item = items[index]

                        NavigationLink(destination: Text(item.0)) {
                            HStack {
                                Image(systemName: item.1)
                                    .foregroundStyle(.indigo)

                                Text(item.0)
                            }
                        }
                    }

                    ForEach(playlists) { playlist in
                        NavigationLink(destination: Text(playlist.name)) {
                            HStack {
                                if let img = playlist.image {
                                    Image(uiImage: img)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))
                                } else {
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.gray.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                }

                                Text(playlist.name)
                            }
                        }
                    }
                }
            }
        }
        .background(Color(.secondarySystemBackground))
    }
}

#Preview {
    LibraryViewPlus()
}
