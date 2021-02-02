//
//  BookListViewController.swift
//  Book Store
//
//  Created by BBVAMobile on 30/01/2021.
//  Copyright © 2021 Alexandre Carvalho. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class BookListViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var collectionResult: UICollectionView!
    @IBOutlet weak var stackLoading: UIStackView!
    
    //MARK: - Var and Let
    static let stringSearch:String = "ios"
    let userDefaults = UserDefaults()
    
    var books: [Item] = []        // var containing book array
    var startIndexValue: Int = 0  // var for start index of Search
    var numberOfItems: Int = 14  // var for number of items for show
    var isLoading:Bool = false   // var for loading state in load more
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "star"), style: .done, target: self, action: #selector(BookListViewController.showFavorits))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        stackLoading.isHidden = true
        callStarterService()
    }

     @objc func showFavorits() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "favoritesViewController") as! FavoritesViewController
        self.navigationController?.pushViewController(newViewController, animated: true)
    }

    
    //MARK: - Func Section
    func callStarterService() {
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad){ numberOfItems = 20 }
        RequestsManager.getBooks(search: "ios", maxResults: numberOfItems, startIndex: startIndexValue) { result in
            if result != nil {
                self.books = result?.items ?? []
                self.startIndexValue = (self.numberOfItems+1)
                self.collectionResult.reloadData()
            }
        }
    }

    func loadMoreBooks(){
        RequestsManager.getBooks(search: "ios", maxResults: numberOfItems, startIndex: startIndexValue) { result in
            if result != nil && result?.items != nil{
                    var books2: [Item] = []
                    books2 = self.books + (result?.items)!
                    self.books = books2
                    self.startIndexValue = self.startIndexValue + (self.numberOfItems+1)
                self.collectionResult.reloadData()
                    self.isLoading = false
                    self.stackLoading.isHidden = true
            }
            else {
                 self.isLoading = false
                 self.stackLoading.isHidden = true
            }
        }
    }
}

    //MARK: - Collection View DataSource
    extension BookListViewController: UICollectionViewDataSource{
        
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
    extension BookListViewController: UICollectionViewDelegateFlowLayout {
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

//MARK: - Scrollview Delegate
extension BookListViewController: UIScrollViewDelegate {
    
    //MARK :- Getting user scroll down event here
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionResult{
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= (scrollView.contentSize.height)){
                if isLoading == false {
                    stackLoading.isHidden = false
                    isLoading = true
                    //Start locading new data
                    loadMoreBooks()
                }
            }
        }
    }
}

