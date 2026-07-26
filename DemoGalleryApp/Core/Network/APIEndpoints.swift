//
//  APIEndpoints.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation

enum APIEndpoints {

    static let baseURL = "https://picsum.photos/v2"

    static func wallpapers(page: Int, limit: Int) -> String {
        return "\(baseURL)/list?page=\(page)&limit=\(limit)"
    }
}
