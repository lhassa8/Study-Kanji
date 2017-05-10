//
//  StrokesVC.swift
//  Study Kanji
//
//  Created by User on 4/25/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit
import AVKit

class StrokesVC: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var strokeNumLabel: UILabel!
    @IBOutlet weak var strokeTotalLabel: UILabel!
    
    var timer: Timer!
    var slideNum = 0
    var kanji: Kanji = Kanji(char: "K", meaning: " ")


    override func viewDidLoad() {
        super.viewDidLoad()
            }

    func runTimerCode() {
        
        if slideNum < kanji.strokes.count {

            let url = URL(string: kanji.strokes[slideNum])
            let request = URLRequest(url: url!)
            webView.loadRequest(request)
            strokeNumLabel.text = String(slideNum + 1)
            slideNum += 1
        } else {
            timer.invalidate()
        }

    }


    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    

}
