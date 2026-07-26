//
//  WallpaperRepository.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation
import CoreData
import UIKit

final class WallpaperRepository {

    private let context = CoreDataManager.shared.context
    private let service = WallpaperService()
    
    private func pictureExists(id: String) -> Bool {

        let request: NSFetchRequest<PicturesEntity> = PicturesEntity.fetchRequest()

        request.predicate = NSPredicate(format: "id == %@", id)

        do {

            let count = try context.count(for: request)
            return count > 0

        } catch {

            return false
        }
    }
    
    
    private func saveWallpaper(
        _ wallpaper: Wallpaper,
        imageData: Data,
        order: Int
    ) {

        let entity = PicturesEntity(context: context)

        entity.id = wallpaper.id
        entity.author = wallpaper.author
        entity.imageURL = wallpaper.download_url
        entity.imageData = imageData
        entity.displayOrder = Int64(order)

        CoreDataManager.shared.saveContext()
    }
    
    func saveWallpapers(_ wallpapers: [Wallpaper], page: Int) {

        let pageSize = 20
        
        wallpapers.enumerated().forEach { index, wallpaper in

            guard !pictureExists(id: wallpaper.id) else {
                return
            }
            
            let order = ((page - 1) * pageSize) + index

            downloadImage(from: wallpaper.download_url) { [weak self] imageData in

                guard
                    let self = self,
                    let imageData = imageData
                else { return }

                DispatchQueue.main.async {

                    self.saveWallpaper(
                        wallpaper,
                        imageData: imageData,
                        order: order
                    )
                }
            }
        }
    }
    
    
    func fetchWallpapers() -> [PicturesEntity] {

        let request: NSFetchRequest<PicturesEntity> = PicturesEntity.fetchRequest()

        request.sortDescriptors = [
                NSSortDescriptor(
                    key: "displayOrder",
                    ascending: true
                )
            ]
        
        do {

            return try context.fetch(request)

        } catch {

            print(error)

            return []
        }
    }
    
    
    func fetchWallpapers(
        page: Int,
        completion: @escaping(Result<[WallpaperItem], Error>) -> Void
    ) {

        if Reachability.shared.isConnected {

            service.fetchWallpapers(page: page) { result in

                switch result {

                case .success(let wallpapers):

                    self.saveWallpapers(wallpapers, page: page)

                    completion(.success(self.makeWallpaperItems(from: wallpapers)))

                case .failure(let error):

                    completion(.failure(error))
                }
            }

        } else {

            completion(.success(loadOfflineWallpapers()))
        }
    }
    
    
    private func downloadImage(
        from urlString: String,
        completion: @escaping (Data?) -> Void
    ) {

        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in

            guard error == nil else {
                completion(nil)
                return
            }

            completion(data)

        }.resume()
    }
    
    
    func loadOfflineWallpapers() -> [WallpaperItem] {

        let entities = fetchWallpapers()

        return entities.map {

            WallpaperItem(
                id: $0.id ?? "",
                author: $0.author ?? "",
                imageURL: $0.imageURL ?? "",
                imageData: $0.imageData
            )
        }
    }
    
    private func makeWallpaperItems(
        from wallpapers: [Wallpaper]
    ) -> [WallpaperItem] {

        wallpapers.map {

            WallpaperItem(
                id: $0.id,
                author: $0.author,
                imageURL: $0.download_url,
                imageData: nil
            )
        }
    }

}


