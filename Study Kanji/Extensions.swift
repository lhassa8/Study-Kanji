//
//  Extensions.swift
//  Kanji DB
//
//  Created by User on 4/22/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func replace(target: String) -> String {
        var resultCharacters: [Character] = ["\\", "u", "{"]
        var targetChars = [Character]()
        for char in target {
            targetChars.append(char)
        }
        resultCharacters.append(targetChars[2])
        resultCharacters.append(targetChars[3])
        resultCharacters.append(targetChars[4])
        resultCharacters.append(targetChars[5])
        
        resultCharacters.append("}")
        
        return String(resultCharacters)
    }
    
    func firstLetter() -> String {
        return String(self.prefix(1))
    }
}


extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}

