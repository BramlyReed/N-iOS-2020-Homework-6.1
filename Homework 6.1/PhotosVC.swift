//
//  PhotosVC.swift
//  Homework 6.1
//
//  Created by Stas on 07.12.2020.
//

import UIKit

struct Photo: Codable {
    let url: String
    var image: UIImage?
    
    init(url: String) {
        self.url = url
    }
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}

class PhotosVC: UIViewController {

    
    @IBOutlet weak var collections: UICollectionView!
    var photos: [Photo] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        collections.delegate = self
        collections.dataSource = self
        
        collections.register(UINib(nibName: "customCell", bundle: nil), forCellWithReuseIdentifier: "customCell")
    }
    
    @IBAction func loadPhotos(_ sender: Any) {
        getphotosFromApi()
    }
    
    func getphotosFromApi() {
        let tmpURL = "https://jsonplaceholder.typicode.com/photos"
        photos = Array(repeating: Photo(url: tmpURL), count: 20)
        guard let imageURL = URL(string: tmpURL) else { return }
        URLSession.shared.dataTask(with: imageURL) { data, _ ,_ in
            guard let data = data, let photos = try? JSONDecoder().decode([Photo].self, from: data) else { return }
            
            self.photos = photos.prefix(20).map { Photo(url: $0.url)}
            DispatchQueue.main.async {
                self.collections.reloadData()
            }
        }.resume()
    }
}
extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count > 0 ? photos.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CollectionViewCell
        if photos.count != 0 {
                cell.chosenImage(photoModel: photos[indexPath.item]) { [weak self] (image) in
                    self?.photos[indexPath.item].image = image
                }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let image: UIImage = photos[indexPath.item].image else {
            return
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let fullScreanVC = storyboard.instantiateViewController(identifier: "fullScrean") as! ViewController
        fullScreanVC.modalTransitionStyle = .flipHorizontal
        fullScreanVC.tmpImage = image
        present(fullScreanVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collections.frame.width - 40) / 3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

