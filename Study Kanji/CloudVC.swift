//
//  CloudVC.swift
//  Study Kanji
//
//  Created by User on 5/5/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class CloudVC: UIViewController {


    @IBOutlet weak var studyKanjiLabel: UILabel!
    @IBOutlet weak var circle1: UIImageView!
    @IBOutlet weak var circle2: UIImageView!
    @IBOutlet weak var backgroundIV: UIImageView!
    var newImage = UIImage(named: "day")

    var animateOption = true
    let defaults:UserDefaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.animateOption = defaults.object(forKey: "SplashAnimateOption") as? Bool ?? true

        }
    
    override func viewWillAppear(_ animated: Bool) {


        
        if self.animateOption == true {
            //animate
            initialSettings()
            self.backgroundIV.image = UIImage(named: "night")

            moveList()
        } else {
            //no animate
            performSegue(withIdentifier: "CollectionVC", sender: nil)

            self.studyKanjiLabel.alpha = 1.0

        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if self.animateOption == true {
            //animate
                    UIView.transition(with: backgroundIV, duration: 10.0,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.backgroundIV.image = self.newImage
            },
                              completion: nil
            )
        } else {
            // got directly to startscreen
            performSegue(withIdentifier: "CollectionVC", sender: nil)

        }
        
    }

    func initialSettings () {
        self.circle1.layer.cornerRadius = self.circle1.frame.size.width / 2
        self.circle1.layer.masksToBounds = false
        self.circle1.layer.shadowOffset.height = 7
        self.circle1.layer.shadowOffset.width = 7
        self.circle1.layer.shadowRadius = 7
        self.circle1.layer.shadowOpacity = 0.5
       
        self.circle2.layer.cornerRadius = self.circle1.frame.size.width / 2
        self.circle2.layer.masksToBounds = false
        self.circle2.layer.shadowOffset.height = 7
        self.circle2.layer.shadowOffset.width = 7
        self.circle2.layer.shadowRadius = 7
        self.circle2.layer.shadowOpacity = 0.5

    }
    
    func moveList() {


        moveDot(x1: 0, y1: 0, x2: 0, y2: 0, timeDelay: 1.0)
        moveDot(x1: 100, y1: 10, x2: -100, y2: -10, timeDelay: 2.0)
        moveDot(x1: -20, y1: 50, x2: 20, y2: -50, timeDelay: 3.0)
        moveDot(x1: -30, y1: 40, x2: 30, y2: 40, timeDelay: 4.0)
        moveDot(x1: -100, y1: 20, x2: 100, y2: -20, timeDelay: 5.0)
        moveDot(x1: 20, y1: -120, x2: -40, y2: 60, timeDelay: 6.0)
        moveDot(x1: 60, y1: 80, x2: 80, y2: 90, timeDelay: 7.0)
        moveDot(x1: 30, y1: -60, x2: -100, y2: -100, timeDelay: 8.0)
        moveDot(x1: -60, y1: -20, x2: 40, y2: 10, timeDelay: 9.0)
        UIView.animate(withDuration: 4.0, delay: 10.0, options: [], animations: {
            self.studyKanjiLabel.alpha = 1.0
        }, completion: { (finished: Bool) in
            self.performSegue(withIdentifier: "CollectionVC", sender: nil)
        })
    }

    func moveDot(x1: CGFloat, y1: CGFloat, x2: CGFloat, y2: CGFloat, timeDelay: Double) {
        UIView.animate(withDuration: 2.0, delay: timeDelay, options: [], animations: { 
            self.circle1.center.x += x1
            self.circle1.center.y += y1
            self.circle2.center.x += x2
            self.circle2.center.y += y2
        }, completion: nil)
        
    }
    
    func fade(imageView: UIImageView, toImage: UIImage) {
        UIView.transition(with: imageView, duration: 5.0,
                          options: .transitionCrossDissolve,
                          animations: {
                            imageView.image = self.newImage
        },
                          completion: nil
        )
    }
    
    @IBAction func screenTapped(_ sender: Any) {

        performSegue(withIdentifier: "CollectionVC", sender: nil)
        
    }
 
}
