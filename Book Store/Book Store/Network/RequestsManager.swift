//
//  NetworkClass.swift
//  Book Store
//
//  Created by BBVAMobile on 30/01/2021.
//  Copyright © 2021 Alexandre Carvalho. All rights reserved.
//


import Foundation
import Alamofire

class RequestsManager: NSObject {

    static func getBooks(search: String, maxResults: Int, startIndex:Int, completion:@escaping (BooksResponse?)->Void) {
        let index = String(startIndex)
        let max = String(maxResults)
        AF.request(APIRouter.books(search: search,  maxResults: max, startIndex: index)).responseDecodable(of: BooksResponse.self) { (response) in
                completion(response.value)
            }
        }
        
    static func getBook(bookId:String, completion:@escaping (Item?)->Void) {
        AF.request(APIRouter.getBook(id: bookId)).responseDecodable(of: Item.self) { (response) in
            completion(response.value)
        }
    }
    
}







