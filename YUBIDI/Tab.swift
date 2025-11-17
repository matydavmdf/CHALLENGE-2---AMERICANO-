//
//  Tab.swift
//  YUBIDI
//
//  Created by Matilde Davide on 10/11/25.
//
import SwiftUI

struct MainTabView: View {
    @State private var text: String = ""
    @State private var AccessoryModal = false
    
    var body: some View {
    
        TabView () {
                    
                    Tab ("Home", systemImage: "music.note.house") {
                        HomeView() }
                    
                    Tab ("Library", systemImage: "music.note.square.stack") {
                        LibraryViewPlus()}
                    
                    Tab (role: .search) {
                        NavigationStack {
                            SearchView2()
                        }
                    }
                }
        .searchable(text: $text, placement: .toolbarPrincipal, prompt: "Artists, songs, or genres")
        .tabViewSearchActivation(.searchTabSelection)
        .tabViewBottomAccessory {
            Button {
                            AccessoryModal.toggle()
                        } label: {
                            AccessoryView()
                        }
                        .buttonStyle(.plain)
                    }
                    .sheet(isPresented: $AccessoryModal) {
                        MusicPlayerView()
                            .presentationDragIndicator(.visible)
                    }
            
           
}
    }

struct AccessoryView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            Image("Certe notti cover")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 32)
              
                           
            VStack (alignment: .leading) {
                Text("Certe Notti")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
            }
            Spacer()
            Image(systemName: "play.fill")
                .foregroundColor(.indigo)
            Image(systemName: "forward.end.alt")
                .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .padding()
        }
    }
        
#Preview {
    MainTabView()
}
