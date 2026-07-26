//
//  GalleryViewModel.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation

class GalleryViewModel {
    
    private let repository = WallpaperRepository()
    
    private(set) var wallpapers = [WallpaperItem]()
    
    var onDataUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    private var page = 1
    private let limit = 20
    private var isLoading = false
    private var hasMoreData = true
    
    func fetchWallpapers() {
        
        guard !isLoading, hasMoreData else {
            return
        }
        
        isLoading = true
        
        repository.fetchWallpapers(page: page) { [weak self] result in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                
                self.isLoading = false
                
                switch result {
                    
                case .success(let wallpapers):
                    
                    // No more data
                    if wallpapers.isEmpty {
                        self.hasMoreData = false
                        return
                    }
                    
                    self.wallpapers.append(contentsOf: wallpapers)
                    
                    // Last page
                    if wallpapers.count < self.limit {
                        self.hasMoreData = false
                    }
                    
                    self.page += 1
                    self.onDataUpdated?()
                    
                case .failure(let error):
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
    
    func numberOfItems() -> Int {
        wallpapers.count
    }
    
    func wallpaper(at index: Int) -> WallpaperItem {
        wallpapers[index]
    }
}
