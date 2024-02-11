//
//  Photo.swift
//  Assignment2WibuApp
//
//  Created by Riza Adi Kurniawan on 11/02/24.
//

import Foundation

struct Anime: Decodable, Equatable, Identifiable {
    let id = UUID()
    let image: String
    let anime: String
    let name: String
}
