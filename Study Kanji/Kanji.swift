//
//  Kanji.swift
//  Kanji DB
//
//  Created by User on 4/22/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import Foundation

//
//  Kanji.swift
//  Kanji DB
//
//  Created by User on 4/18/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import Foundation
import UIKit



class Kanji {
    var char: String!
    var meaning: String!
    var kunyomi = Kunyomi()
    var onyomi = Onyomi()
    var strokes =  [String]()
    var kanjiImages = KanjiImages()
    var references = References()
    var examples = [Example]()
    var strokeImages = [String]()
    var loved = false
    var favorite = false
    var knownKanji = false
    
    init(char: String, meaning: String) {
        self.char = char
        self.meaning = meaning
    }
    
    var strokeCount: Int {
        return self.strokes.count
    }
    
    
    
}

struct Example {
    var japanese: String?
    var english: String?
}

struct References {
    var nelson: String?
    var grade: Int?
    var kodansha: String?
}

struct KanjiImages {
    var mp4: String?
    var poster: String?
}
struct Kunyomi {
    var hiragana: String?
    var romaji: String?
}

struct Onyomi {
    var katakana: String?
    var romaji: String?
}


