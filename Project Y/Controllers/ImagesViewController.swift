//
//  ImagesViewController.swift
//  Project Y
//
//  Created by Admin on 10.09.2020.
//  Copyright © 2020 Anton Dobrynin. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var networkDataFetcher = NetworkDataFetcher()
    
    var refreshCtrl: UIRefreshControl!
    var collectionData: [ImagesResults]!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        cache = NSCache()
        
        getDataImages()
        
        setupUi()
    }
    
    func setupUi() {
        self.refreshCtrl = UIRefreshControl()
        self.collectionView.refreshControl = self.refreshCtrl

        self.refreshCtrl.addTarget(self, action: #selector(ImagesViewController.refreshCollectionView), for: .valueChanged)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.imageCellIdentifier)
    }
    
    @objc func refreshCollectionView() {
        self.collectionData = []
        self.cache.removeAllObjects()
        
        getDataImages()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    func getDataImages() {
        networkDataFetcher.fetchImages { (fetchResults) in
            let results = fetchResults
            self.collectionData = results
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionData != nil {
            return collectionData.count
        } else {
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCellIdentifier, for: indexPath) as! ImagesCollectionViewCell
        
        if collectionData != nil {
            if let data = collectionData {
                let dictionary = data[(indexPath as NSIndexPath).row]
                cell.imageView?.image = UIImage(named: "imagePlaceholder")
                if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
                    // Use cache
                    print("Изображение закешировано, повторное скачивание не нужно.")
                    cell.imageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
                } else {
                    let artworkUrl = dictionary.urls.small
                    let url:URL! = URL(string: artworkUrl)
                    task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                        if let data = try? Data(contentsOf: url){
                            DispatchQueue.main.async(execute: { () -> Void in
                                // Before we assign the image, check whether the current cell is visible
                                if let updateCell = collectionView.cellForItem(at: indexPath) as? ImagesCollectionViewCell {
                                    let img: UIImage! = UIImage(data: data)
                                    updateCell.imageView?.image = img
                                    self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                                }
                            })
                        }
                    })
                    task.resume()
                }
            }
            return cell
        } else {
            cell.imageView?.image = UIImage(named: "imagePlaceholder")
            return cell
        }
    }
}
