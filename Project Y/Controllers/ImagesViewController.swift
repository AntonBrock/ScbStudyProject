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
    var imageArr = [String]()
    
    var refreshCtrl: UIRefreshControl!
    var collectionData: [ImagesResults]!
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkDataFetcher.fetchImages { (fetchResults) in
            let results = fetchResults
            self.collectionData = results
            
            self.collectionView.reloadData()
//            results?.map({image in
//                print(image)
//                self.imageArr.append(image.urls.small)
//                print(self.imageArr)
//        })
        }
        
        setupUi()
        setupLogic()
        
    }
    
    func setupUi() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "ImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.imageCellIdentifier)
    }
    
    func setupLogic() {
        session = URLSession.shared
        task = URLSessionDownloadTask()
        cache = NSCache()

        
        self.refreshCtrl = UIRefreshControl()
        self.collectionView.refreshControl = self.refreshCtrl
        
//        self.collectionData = []
        
//        refreshCollectionView()
    }
    
//    func refreshCollectionView() {
//        let url: URL! = URL(string: "https://itunes.apple.com/search?term=flappy&entity=software")
//        task = session.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
//
//            if location != nil{
//                let data:Data! = try? Data(contentsOf: location!)
//                do{
//                    let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
//                    self.collectionData = dic.value(forKey : "results") as? [AnyObject]
//                    DispatchQueue.main.async(execute: { () -> Void in
//                        self.collectionView.reloadData()
//                        self.collectionView.refreshControl?.endRefreshing()
//                    })
//                } catch{
//                    print("something went wrong, try again")
//                }
//            }
//        })
//        task.resume()
//    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension ImagesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionData != nil {
            return collectionData.count
        } else {
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCellIdentifier, for: indexPath) as! ImagesCollectionViewCell
        
        if collectionData != nil {
            // 1
            if let data = collectionData {
                let dictionary = data[(indexPath as NSIndexPath).row]
                cell.imageView?.image = UIImage(named: "imagePlaceholder")
                if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
                    // Use cache
                    print("Cached image used, no need to download it")
                    cell.imageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
                } else {
                    let artworkUrl = dictionary.urls.small
                    let url:URL! = URL(string: artworkUrl)
                    task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                        if let data = try? Data(contentsOf: url){
                            // 4
                            DispatchQueue.main.async(execute: { () -> Void in
                                // 5
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
            
//            let dictionary = self.collectionData[(indexPath as NSIndexPath).row] as! [String]
//            cell.imageView?.image = UIImage(named: "imagePlaceholder")
            
//            if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
//                // 2
//                // Use cache
//                print("Cached image used, no need to download it")
//                cell.imageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
//            } else {
//                // 3
//                let artworkUrl = dictionary[indexPath.row]
//                let url:URL! = URL(string: artworkUrl)
//                task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
//                    if let data = try? Data(contentsOf: url){
//                        // 4
//                        DispatchQueue.main.async(execute: { () -> Void in
//                            // 5
//                            // Before we assign the image, check whether the current cell is visible
//                            if let updateCell = collectionView.cellForItem(at: indexPath) as? ImagesCollectionViewCell {
//                                let img: UIImage! = UIImage(data: data)
//                                updateCell.imageView?.image = img
//                                self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
//                            }
//                        })
//                    }
//                })
//                task.resume()
//            }
            return cell
        } else {
            cell.imageView?.image = UIImage(named: "imagePlaceholder")
            return cell
        }
        
        
        
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.imageCellIdentifier, for: indexPath) as! ImagesCollectionViewCell
    }
    
    
}
