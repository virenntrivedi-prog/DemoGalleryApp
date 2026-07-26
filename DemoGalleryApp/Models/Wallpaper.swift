//
//  Wallpaper.swift.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation

struct Wallpaper: Codable {
    let id: String
    let author: String
    let width: Int
    let height: Int
    let url: String
    let download_url: String
}

struct WallpaperItem {

    let id: String
    let author: String
    let imageURL: String
    let imageData: Data?

}
