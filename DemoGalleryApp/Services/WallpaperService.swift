//
//  WallpaperService.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation

protocol WallpaperServiceProtocol {
    func fetchWallpapers(page: Int, completion: @escaping(Result<[Wallpaper], Error>) -> Void)
}

final class WallpaperService: WallpaperServiceProtocol {
    
    func fetchWallpapers(page: Int, completion: @escaping(Result<[Wallpaper], Error>) -> Void) {
        
        let url = APIEndpoints.wallpapers(page: page, limit: 20)
        APIManager.shared.request(urlString: url, completion: completion)
    }
}
