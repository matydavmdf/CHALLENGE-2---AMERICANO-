//
//  SectionView.swift
//  YUBIDI
//
//  Created by Matilde Davide on 11/11/25.
//

import SwiftUI

struct SectionView: View {
    let sectionTitle: String
    let albums: [Album]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(sectionTitle)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(albums) { album in
                        VStack {
                            // Album artwork
                            Image(album.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill )
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                
//
                            
                            Text(album.title)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.primary)
                                
                        }
                     
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct SectionView2: View {
    let sectionTitle: String
    let albums: [Album]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(sectionTitle)
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(albums) { album in
                        VStack(alignment: .leading) {
                            // Album artwork
                            Image(album.imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fill )
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                
//
                            
                            Text(album.title)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.primary)
                                .lineLimit(1)
                            Text(album.subtitle)
                        }
                        .frame(width: 150, alignment: .leading)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}


