//
//  Utils.swift
//  Book Store
//
//  Created by BBVAMobile on 01/02/2021.
//  Copyright © 2021 Alexandre Carvalho. All rights reserved.
//

import Foundation
class AppUtils {

    
    class func getLanguageString(_ strLang:String) -> String {
        let strLangUp = strLang.uppercased()
        
        switch strLangUp {
        case "EN":
            return "English"
        case "FR":
            return "French"
        case "IT":
            return "Italian"
        case "PT":
            return "Portuguese"
        case "ES":
            return "Spanish"
            
        default:
            return "-"
        }
    }
    
}

