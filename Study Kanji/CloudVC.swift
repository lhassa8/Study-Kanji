//
//  CloudVC.swift
//  Study Kanji
//
//  Created by User on 5/5/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class CloudVC: UIViewController {

    @IBOutlet weak var cloud1: UIImageView!
    @IBOutlet weak var cloud2: UIImageView!
    @IBOutlet weak var cloud3: UIImageView!
    @IBOutlet weak var cloud4: UIImageView!
    @IBOutlet weak var studyKanjiLabel: UILabel!
    @IBOutlet weak var japaneseFlag: UIImageView!
    
    
    var imageArray = [UIImage]()
    var animatedImage = UIImage()
    var animateOption = true
    let defaults:UserDefaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animateOption = defaults.object(forKey: "AnimateOption") as? Bool ?? true

        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if self.animateOption == true {
            loadImages()
            self.japaneseFlag.image = animatedImage
            self.japaneseFlag.clipsToBounds = true
            self.japaneseFlag.layer.cornerRadius = 15
        } else {
            self.cloud1.alpha = 0.0
            self.cloud2.alpha = 0.0
            self.cloud3.alpha = 0.0
            self.cloud4.alpha = 0.0
            self.studyKanjiLabel.alpha = 1.0

        }

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.animateOption == true {
            UIView.animate(withDuration: 10.0, delay: 0.2, options: [.curveEaseOut], animations: {
                self.cloud1.center.x += 900
                self.cloud2.center.x += 700
                self.cloud3.center.x -= 600
                self.cloud4.center.x -= 800
                
                self.cloud1.alpha = 0.3
                self.cloud2.alpha = 0.3
                self.cloud3.alpha = 0.3
                self.cloud4.alpha = 0.3
                
                self.studyKanjiLabel.alpha = 1.0
                self.japaneseFlag.alpha = 0.6
                
                
            }, completion: nil)
        } else {
            performSegue(withIdentifier: "CollectionVC", sender: nil)

        }

        //loadImages()
        //self.japaneseFlag.image = animatedImage
        
        
    }

    func loadImages() {
        let start = "frame_"
        let end = "_delay-0.05s"
        for i in 0...39 {
            let imageTitle = start + String(i) + end
            let element = UIImage(named: imageTitle)
            self.imageArray.append(element!)
        }
        self.animatedImage = UIImage.animatedImage(with: self.imageArray, duration: 1.2)!
    }

    @IBAction func screenTapped(_ sender: Any) {
        UIView.animate(withDuration: 1.0, delay: 1.0, options: [.curveEaseOut], animations: {
            self.cloud1.center.x += 900
            self.cloud2.center.x += 700
            self.cloud3.center.x -= 600
            self.cloud4.center.x -= 800
            
            self.cloud1.alpha = 0.0
            self.cloud2.alpha = 0.0
            self.cloud3.alpha = 0.0
            self.cloud4.alpha = 0.0
            
            self.studyKanjiLabel.alpha = 0.0
            self.japaneseFlag.alpha = 0.0
            
            
        }, completion: nil)
        let timer = Timer(timeInterval: 1.0, repeats: false, block: {_ in })
        timer.invalidate()
        performSegue(withIdentifier: "CollectionVC", sender: nil)
    }

    
}
