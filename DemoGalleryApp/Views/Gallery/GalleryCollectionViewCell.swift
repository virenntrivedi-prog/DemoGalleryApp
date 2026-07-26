//
//  LoginViewController.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import UIKit
import Kingfisher

class GalleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
    }
    
    func configure(with wallpaper: WallpaperItem) {
        
        // Offline
        if let imageData = wallpaper.imageData {
            
            imageView.image = UIImage(data: imageData)
            return
        }
        
        // Online
        guard let url = URL(string: wallpaper.imageURL) else {
            
            imageView.image = UIImage(systemName: "photo")
            return
        }
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo")
        )
        
    }
    
}
