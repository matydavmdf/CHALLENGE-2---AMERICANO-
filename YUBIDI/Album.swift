//
//  Album.swift
//  YUBIDI
//
//  Created by Matilde Davide on 10/11/25.
//

import Foundation

struct Album: Identifiable {
    let id = UUID()
    let title: String
    var subtitle: String = ""
    let imageName: String
}


    

