//
//  FavoritesViewController.swift
//  Book Store
//
//  Created by BBVAMobile on 01/02/2021.
//  Copyright © 2021 Alexandre Carvalho. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FavoritesViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var collectionResult: UICollectionView!
    @IBOutlet weak var lbNoInfo: UILabel!
    
    //MARK: - Var and Let
    var books: [Item] = []
    let userDefaults = UserDefaults()
    
    
    //MARK: - Override func
    override func viewDidLoad() {
        self.title = "Favorites"
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        showFavorits()
    }

    
    @objc func showFavorits() {
        self.books.removeAll()
        self.collectionResult.reloadData()
        let favs = userDefaults.value(forKey: "Fav") as? [String]
        var count: Int = 0
        if favs != nil{
            for fav in favs! {
                RequestsManager.getBook(bookId: fav) { result in
                    if result != nil {
                        self.books.append(result!)
                        count += 1
                        if count == favs?.count{
                            self.collectionResult.reloadData()
                            
                        }
                    }
                }
            }
            if favs?.count == 0{
                collectionResult.isHidden = true
            }
            
        }else {
            collectionResult.isHidden = true
        }
    }

}

    

    //MARK: - Collection View DataSource
    extension FavoritesViewController: UICollectionViewDataSource{
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
            return books.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            guard books.count != 0 else {
                return cell
            }
            let model = books[indexPath.row]
            if let imgUrl = model.volumeInfo?.imageLinks?.thumbnail {
                let urlImg = URL(string: imgUrl)!
                cell.imageResult.af.setImage(withURL: urlImg)
            }
            else {
                cell.imageResult.image = UIImage(named: "notFound")
            }
            cell.labelTitle.text = model.volumeInfo?.title ?? "No Title"
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "detailsViewController") as! DetailsViewController
            newViewController.book = books[indexPath.row]
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
    }

    //MARK: - UICollectionViewDelegateFlowLayout
    extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 160, height: 300);
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
    }
