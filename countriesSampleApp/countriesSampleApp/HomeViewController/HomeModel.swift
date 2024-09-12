//
//  HomeViewModel.swift
//  countriesSampleApp
//
//  Created by Shanmukh D M on 12/09/24.
//

import Foundation

struct Media: Codable {
    let flag: String
    let emblem: String
    let orthographic: String
}

struct Country: Codable {
    let abbreviation: String
    let capital: String
    let currency: String
    let name: String
    let phone: String
    let population: Int?
    let media: Media
    let id: Int
}
