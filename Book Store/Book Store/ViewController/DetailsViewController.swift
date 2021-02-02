//
//  DetailsViewController.swift
//  Book Store
//
//  Created by BBVAMobile on 01/02/2021.
//  Copyright © 2021 Alexandre Carvalho. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
   
    //MARK: - Outlets
    @IBOutlet weak var imgCover: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbPublisher: UILabel!
    @IBOutlet weak var lbLanguage: UILabel!
    @IBOutlet weak var lbPubDate: UILabel!
    @IBOutlet weak var lbBookLength: UILabel!
    @IBOutlet weak var lbCategories: UILabel!
    @IBOutlet weak var btnFavorits: UIButton!
    
    //MARK: - Var and Let
    let userDefaults = UserDefaults()
    var book: Item! // var containing book
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Book Details"
        loadInfoForView()
        
        if validateIfFavorite() {
            btnFavorits.setTitle("Unfavorite Book", for: .normal)              }
        else {
            btnFavorits.setTitle("Add to Favorites", for: .normal)
        }
    }

    
    //MARK: - Func Section
    
    func loadInfoForView(){
        var strAuthors: String = ""
        var strCategories: String = ""
        
        
        if let imgUrl = book.volumeInfo?.imageLinks?.thumbnail {
            let urlImg = URL(string: imgUrl)!
            imgCover.af.setImage(withURL: urlImg)
        }
        else {
            imgCover.image = UIImage(named: "notFound")
        }
        
        for author in book.volumeInfo?.authors ?? [] {
            strAuthors = "\(author); \(strAuthors)"
        }
        
        for cat in book.volumeInfo?.categories ?? [] {
            strCategories = "\(cat); \(strCategories)"
        }

        lbTitle.text = book.volumeInfo?.title ?? "No Title"
        lbSubTitle.text = strAuthors
        lbPrice.text = "\(book.saleInfo?.retailPrice?.amount ?? 0) \(book.saleInfo?.retailPrice?.currencyCode ?? "EUR")"
        lbDescription.text = book.volumeInfo?.volumeInfoDescription ?? "No Info"
        lbLanguage.text = AppUtils.getLanguageString(book.volumeInfo?.language ?? "")
        lbPublisher.text = book.volumeInfo?.publisher ?? "No Info"
        lbPubDate.text = book.volumeInfo?.publishedDate ?? "No Info"
        lbBookLength.text = String(book.volumeInfo?.pageCount ?? 0)
        lbCategories.text = strCategories
    }
    
    
    func saveDataFavorites() {
        var favs = userDefaults.value(forKey: "Fav") as? [String]
        if favs == nil{
            var arrFav: [String] = []
            arrFav.append(book.id ?? "")
            userDefaults.set(arrFav, forKey: "Fav")
        }else {
            
            var i: Int = 0
            var exist:Bool = false
            
            for fav in favs! {
                if fav == book.id {
                    favs?.remove(at: i)
                    exist = true
                }
                i += 1
            }
            
            if exist == false {
                favs?.append(book.id ?? "")
            }
            userDefaults.set(favs, forKey: "Fav")
        }
    }
    
    
    func changeLayout(){
        if validateIfFavorite() {
            btnFavorits.setTitle("Unfavorite Book", for: .normal)
            let alert = UIAlertController(title: "Sucesss", message: "The book has been added to your favorites.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            btnFavorits.setTitle("Add to Favorites", for: .normal)
            let alert = UIAlertController(title: "Sucesss", message: "The book has been unfavorite.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func validateIfFavorite() -> Bool{
           let favs = userDefaults.value(forKey: "Fav") as? [String]
           if favs != nil{
               for fav in favs! {
                   if fav == book.id {
                       return true
                   }
               }
           }
           return false
       }
    
    //MARK: - IBAction Funcs
    
    @IBAction func btnBuyBookClick(_ sender: Any) {
        
        if let url = URL(string: book.saleInfo?.buyLink ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func btnFavoritClick(_ sender: Any) {
        saveDataFavorites()
        changeLayout()
    }
}
