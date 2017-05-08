//
//  KanjiCollectionViewCell.swift
//  Study Kanji
//
//  Created by User on 4/24/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class KanjiCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var kanjiLbl: UILabel!
    @IBOutlet weak var kunyomiLbl: UILabel!
    @IBOutlet weak var onyomiLbl: UILabel!
    @IBOutlet weak var meaningLbl: UILabel!
    
    var kanji: Kanji!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        
    }
    
    
    func configureCell(kanji: Kanji) {
        self.kanji = kanji
        kanjiLbl.text = self.kanji.char
        kunyomiLbl.text = self.kanji.kunyomi.hiragana
        onyomiLbl.text = self.kanji.onyomi.katakana
        meaningLbl.text = self.kanji.meaning
    }
}
