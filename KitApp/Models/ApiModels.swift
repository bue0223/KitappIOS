//
//  Price.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/12/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import Foundation

struct ApiResponse<T: Codable>: Codable {
    var code: Int
    var message: String
    var payload: T
}

struct Auth: Codable {
    var token: String
}

struct Product: Codable {
    var id: String?
    var category: String?
    var name: String?
    var image: String?
    var ave_weekly_packs: Int?
    var ave_weekly_cartons: Int?
    var rewards: [Reward]?
    var order: Int?
    var retail: Retail?
    var wholesale: Wholesale?
}

struct Reward: Codable {
    var reward: Int?
    var type: String?
}

struct Retail: Codable {
    var stick_price: Double?
    var pack_price: Double?
    var carton_price: Double?
}

struct Wholesale: Codable {
    var stick_price: Double?
    var pack_price: Double?
    var carton_price: Double?
}

struct InfoGraphics: Codable {
    var id: String
    var video_url: String
    var images: [InfoImage]
    var pssp: [PsspProduct]?
}

struct InfoImage: Codable {
    var caption: String
    var popup_content: PopupContent?
    var image: String
    var index: Int
}

struct PsspProduct: Codable {
    var stick_price: Double?
    var pack_price: Double?
    var image: String?
    var order: Int?
}

struct PopupContent: Codable {
    var popup_image_url: String
    var popup_image_description: String
}

struct ContentVersion: Codable {
    var ios_version: String
    var api_change_identifier: String
}

struct Message: Codable {
    var id: String
    var content: String
    var page: String
    var screen_title: String
}


struct PriceProgram: Codable {
    var first_row: PriceProgramItem?
    var second_row: PriceProgramItem?
    var third_row: PriceProgramItem?
    var fourth_row: PriceProgramItem?
    var fifth_row: PriceProgramItem?
    var sixth_row: PriceProgramItem?
    var type: String?
    var is_shown: Int?
}

struct PriceProgramItem: Codable {
    var carton_price: Double?
    var percentage_value: Double?
    var percentage_label: String?
    var label: String?
    var image: String?
}
