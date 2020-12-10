//
//  CollectionViewCell.swift
//  Homework 6.1
//
//  Created by Stas on 07.12.2020.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var loadImage: UIImageView!
    func chosenImage(photoModel: Photo, completion: @escaping (UIImage?) -> Void) {
        if let image = photoModel.image {
            loadImage.image = image
            return
        }
        guard let imageURL = URL(string: photoModel.url) else {
            return
        }
        URLSession.shared.dataTask(with: imageURL) {data, _ ,_ in
            if let data = data, let image = UIImage(data: data) {
                completion(image)
                DispatchQueue.main.async {
                    self.loadImage.image = image
                }
            }
            
        }.resume()
    }
}
