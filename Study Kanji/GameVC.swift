//
//  GameVC.swift
//  Study Kanji
//
//  Created by User on 4/26/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit
import AVFoundation

class GameVC: UIViewController {

    @IBOutlet weak var centerCircleImage: UIImageView!
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var upLabel: UILabel!
    @IBOutlet weak var downLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var readButton: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var whiteView: UIView!
    
    

    var scoreCount = 0
    
    
    var targetKanji = Kanji(char: "", meaning: "")
    var correct = Direction.up
    var fullList = [Kanji]()
    let defaults:UserDefaults = UserDefaults.standard
    var readingHint = true
    var speakingHint = false
    let synthesizer = AVSpeechSynthesizer()
    var japaneseVoice = AVSpeechSynthesisVoice(language: "ja-JP")
    var player: AVAudioPlayer!
    let urlCorrect = Bundle.main.url(forResource: "answergood", withExtension: "mp3")!
    let urlWrong = Bundle.main.url(forResource: "answerbad", withExtension: "mp3")!
    var animateOption = true
    var gameSounds = true
    var whiteBounds = CGFloat(0)


    //MARK: - View Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var bestJ = false
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            
            
            if voice.language == "jp=JP" && voice.quality.rawValue == 2 {
                self.japaneseVoice = voice
            }
            
            if voice.identifier == "com.apple.ttsbundle.siri_female_ja-JP_premium" {
                bestJ = true
            }
            
            print(voice.language + " " + voice.name + " " + String(describing: voice.quality.rawValue) + " " + voice.identifier)
        }
        
        if bestJ == true {
            self.japaneseVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_ja-JP_premium")
        }

        self.readButton.alpha = 1.0
        self.readButton.setTitle("字 on", for: .normal)
        self.listenButton.alpha = 0.3
        self.listenButton.setTitle("Speech off", for: .normal)
        loadKanji()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.whiteBounds = (self.redView.bounds.maxX / 2.0) - 50.0
        selectedLabel.text = " "
        scoreCount = defaults.object(forKey: "ScoreCount") as? Int ?? 0
        scoreLabel.text = String(scoreCount)
        self.readingHint = true
        self.speakingHint = false
        self.animateOption = defaults.object(forKey: "AnimateOption") as? Bool ?? true
        if self.animateOption == false {
                self.whiteView.center.y = self.view.center.y + 10
                self.whiteView.layer.cornerRadius = self.whiteBounds
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.animateOption == true {
            self.initialAnimation()
        
        }
        self.gameSounds = defaults.object(forKey: "GameSounds") as? Bool ?? true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(scoreCount, forKey: "ScoreCount")

    }

    //MARK: - Initial Animation
    
    func initialAnimation() {
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            //self.whiteView.frame = self.view.frame
            self.whiteView.layer.cornerRadius = self.whiteView.bounds.maxX / 2 + 400
            self.whiteView.center = self.centerCircleImage.center
        }, completion: nil)

        
        UIView.animate(withDuration: 1, delay: 1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            self.whiteView.center.y += 75
        }, completion: nil)
   
        UIView.animate(withDuration: 0.2, delay: 1.9, options: [], animations: {
            self.whiteView.center = self.centerCircleImage.center
        }, completion: nil)
   
        UIView.animate(withDuration: 1, delay: 2.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            self.whiteView.center.x += 75
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 2.9, options: [], animations: {
            self.whiteView.center = self.centerCircleImage.center
        }, completion: nil)
        
        UIView.animate(withDuration: 1, delay: 3.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [.curveEaseInOut], animations: {
            self.whiteView.center.x -= 75
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 3.9, options: [], animations: {
            self.whiteView.center.y = self.view.center.y + 10
            self.whiteView.center.x = self.view.center.x

            //self.whiteView.layer.cornerRadius = self.whiteView.bounds.maxX / 2
        }, completion: {(finished:Bool) in
            self.redView.isHidden = true
            self.whiteView.layer.cornerRadius = 0
        })
        


    }
    
    
    //MARK: - Swipes
    
    @IBAction func rightSwipe(_ sender: UISwipeGestureRecognizer) {

        let homeX = self.centerCircleImage.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.centerCircleImage.frame.origin.x -= 120
            
        }
        self.centerCircleImage.frame.origin.x = homeX
        if correct == .right {

            correctAnimation()

        } else {

            wrongAnimation()
        }
        loadKanji()
        defaults.set(scoreCount, forKey: "ScoreCount")

    }

    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        let homeX = self.centerCircleImage.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.centerCircleImage.frame.origin.x += 120
        }
        self.centerCircleImage.frame.origin.x = homeX
        if correct == .left {
            
            correctAnimation()
            
        } else {
            
            wrongAnimation()
        }
        loadKanji()
        defaults.set(scoreCount, forKey: "ScoreCount")
    }

    @IBAction func upSwipe(_ sender: UISwipeGestureRecognizer) {
        let homeY = self.centerCircleImage.frame.origin.y
        UIView.animate(withDuration: 0.3) {
            self.centerCircleImage.frame.origin.y += 120
        }
        self.centerCircleImage.frame.origin.y = homeY
        if correct == .up {
            
            correctAnimation()
            
        } else {
            
            wrongAnimation()
        }
        loadKanji()
        defaults.set(scoreCount, forKey: "ScoreCount")
    }

    @IBAction func downSwipe(_ sender: UISwipeGestureRecognizer) {
        let homeY = self.centerCircleImage.frame.origin.y
        UIView.animate(withDuration: 0.3) {
            self.centerCircleImage.frame.origin.y -= 120
        }
        self.centerCircleImage.frame.origin.y = homeY
        if correct == .down {
            
            correctAnimation()
            
        } else {
            
            wrongAnimation()
        }
        loadKanji()
        defaults.set(scoreCount, forKey: "ScoreCount")
    }

    //MARK: - Back Button

    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Randomize Function
    
    func randomChar() -> Kanji {
        let index = Int(arc4random_uniform(UInt32(fullList.count)))
        return fullList[index]
    }
    
    //MARK: Load game slots
    func loadKanji() {
        repeat {
            self.targetKanji = randomChar()
        } while self.targetKanji.meaning == "n/a"
        
        self.centerLabel.text = targetKanji.char
        print("Correct: \(self.targetKanji.meaning)")
        
        var option1 = randomChar()
        while option1.char == self.targetKanji.char || option1.meaning == "n/a" {
            option1 = randomChar()
        }
        
        var option2 = randomChar()
        while option2.char == self.targetKanji.char || option2.meaning == "n/a"{
            option2 = randomChar()
        }
        
        var option3 = randomChar()
        while option3.char == self.targetKanji.char || option3.meaning == "n/a"{
            option3 = randomChar()
        }
        
        selectSlots(first: self.targetKanji, second: option1, third: option2, fourth: option3)
        if speakingHint {
            let utterance = AVSpeechUtterance(string: targetKanji.char)
            utterance.voice = japaneseVoice
            utterance.rate = 0.25
            utterance.preUtteranceDelay = 0.3
            synthesizer.speak(utterance)
        }
    }
    
    func selectSlots(first: Kanji, second: Kanji, third: Kanji, fourth: Kanji) {
        let rand = Int(arc4random_uniform(4))
        let option1 = grabKunyomi(target: first)
        let option2 = grabKunyomi(target: second)
        let option3 = grabKunyomi(target: third)
        let option4 = grabKunyomi(target: fourth)
        
        switch rand {
        case 0:
            self.upLabel.text = option1
            self.downLabel.text = option2
            self.leftLabel.text = option3
            self.rightLabel.text = option4
            self.correct = .up
        case 1:
            self.upLabel.text = option2
            self.downLabel.text = option3
            self.leftLabel.text = option4
            self.rightLabel.text = option1
            self.correct = .right
        case 2:
            self.upLabel.text = option3
            self.downLabel.text = option4
            self.leftLabel.text = option1
            self.rightLabel.text = option2
            self.correct = .left
        case 3:
            self.upLabel.text = option4
            self.downLabel.text = option1
            self.leftLabel.text = option2
            self.rightLabel.text = option3
            self.correct = .down
        default:
            print("error")
        }
    }
    
    func grabKunyomi(target: Kanji) -> String {
        if target.meaning != nil {
            return (target.meaning)!
        } else {
            return("none")
        }
    }
    
    //MARK: - Hint functions
    
    @IBAction func readBtnPressed(_ sender: Any) {
        if readingHint {
            // hide kanji
            self.readButton.setTitle("字 off", for: .normal)
            UIView.animate(withDuration: 0.4, animations: {
                self.centerLabel.alpha = 0.0
                self.readButton.alpha = 0.3
            })
            
        } else {
            // show kanji
            self.readButton.setTitle("字 on", for: .normal)
            UIView.animate(withDuration: 0.4, animations: {
                self.readButton.alpha = 1.0
                self.centerLabel.alpha = 1.0
            })
        }
        readingHint = !readingHint
    }
    
    @IBAction func listenBtnPressed(_ sender: Any) {
        
        if speakingHint {
            // stop audio hints
            self.listenButton.alpha = 0.3
            self.listenButton.setTitle("Speech off", for: .normal)
        } else {
            //start audio hints
            self.listenButton.alpha = 1.0
            self.listenButton.setTitle("Speech on", for: .normal)
            let utterance = AVSpeechUtterance(string: targetKanji.char)
            utterance.voice = japaneseVoice
            utterance.rate = 0.3
            synthesizer.speak(utterance)
        }
        speakingHint = !speakingHint
    }
    
    //MARK: - Animation and Sounds
    
    func correctAnimation() {
        selectedLabel.text = "👍🏻"
        scoreCount += 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.scoreLabel.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            self.scoreLabel.text = String(self.scoreCount)
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.scoreLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
        if gameSounds {
            playSound(url: self.urlCorrect)
        }
        
    }
    

    
    func wrongAnimation() {
        selectedLabel.text = "👎🏻"
        scoreCount -= 1
        self.scoreLabel.text = String(scoreCount)
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.scoreLabel.center.y += 15
            self.scoreLabel.text = String(self.scoreCount)
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [.curveEaseInOut], animations: {
            self.scoreLabel.center.y -= 15
        }, completion: nil)
        if gameSounds {
            playSound(url: self.urlWrong)

        }
    }

    func playSound(url: URL) {
        
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //Mark: - Saved Options
    
    @IBAction func optionsPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Game Options", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.view.backgroundColor = UIColor.clear
        alertController.view.tintColor = UIColor.darkGray
        var lineOneText = "Turn Initial Animation - OFF"
        if self.animateOption == false {
            lineOneText = "Turn Initial Animation - ON"
        }
        
        alertController.addAction(UIAlertAction(title: lineOneText, style: UIAlertActionStyle.default, handler: { (action) in
            print("ok button pressed")
            self.animateOption = !self.animateOption
            self.defaults.set(self.animateOption, forKey: "AnimateOption")
        }))
        
        var lineTwoText = "Turn Game Sounds - OFF"
        if self.gameSounds == false {
            lineTwoText = "Turn Game Sounds - ON"
        }
        
        alertController.addAction(UIAlertAction(title: lineTwoText, style: UIAlertActionStyle.default, handler: { (action) in
            print("not good button pressed")
            self.gameSounds = !self.gameSounds
            self.defaults.set(self.gameSounds, forKey: "GameSounds")

        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            print("cancel pressed")

            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    enum Direction {
        case up, down, left, right
    }

}
