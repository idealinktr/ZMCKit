//
//  LensCell.swift
//  ZMCKit
//
//  Created by Can Kocoglu on 27.11.2024.
//


import UIKit
import SCSDKCameraKit

@available(iOS 13.0, *)
class LensCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        imageView.layer.cornerRadius = 35
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        
        let config = UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)
        imageView.image = UIImage(systemName: "camera.filters", withConfiguration: config)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        
        return imageView
    }()
    
    private var imageCache: NSCache<NSString, UIImage>!
    
    override var isSelected: Bool {
        didSet {
            imageView.layer.borderColor = isSelected ? 
                UIColor.systemBlue.cgColor : 
                UIColor.white.withAlphaComponent(0.5).cgColor
            imageView.layer.borderWidth = isSelected ? 4 : 2
            imageView.backgroundColor = isSelected ? 
                UIColor.systemBlue.withAlphaComponent(0.3) : 
                UIColor.white.withAlphaComponent(0.2)
            
            if isSelected {
                UIView.animate(withDuration: 0.2) {
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.transform = .identity
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with lens: Lens, cache: NSCache<NSString, UIImage>) {
        self.imageCache = cache
        let cacheKey = lens.id
        
        if let cachedImage = cache.object(forKey: cacheKey as NSString) {
            imageView.image = cachedImage
            return
        }
        
        let imageURL = lens.iconUrl ?? lens.preview.imageUrl ?? lens.snapcodes.imageUrl
        
        if let imageURL = imageURL {
            URLSession.shared.dataTask(with: imageURL) { [weak self, cacheKey] data, response, error in
                if let error = error {
                    print("Error loading image: \(error)")
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: cacheKey as NSString)
                        self?.imageView.image = image
                    }
                }
            }.resume()
        }
    }
} 
