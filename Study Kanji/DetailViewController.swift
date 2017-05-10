//
//  DetailViewController.swift
//  Study Kanji
//
//  Created by User on 4/24/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class DetailViewController: UIViewController, AVSpeechSynthesizerDelegate {

    var kanji: Kanji = Kanji(char: "K", meaning: " ")
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var meaningLabel: UILabel!
    @IBOutlet weak var onyomiLabel: UILabel!
    @IBOutlet weak var kunyomiLabel: UILabel!
    @IBOutlet weak var exampleText: UITextView!
    @IBOutlet weak var gradeLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var heartBtn: UIButton!
    @IBOutlet weak var knownButton: UIButton!
    @IBOutlet weak var listenButton: UIButton!
    
    var speaking = false
    var knownKanji = [String]()
    var lovedKanji = [String]()
    var favKanji = [String]()
    let synthesizer = AVSpeechSynthesizer()
    let defaults:UserDefaults = UserDefaults.standard



    func configureView() {
        // Update the user interface for the detail item.
        if kanji.loved == true {
            heartBtn.alpha = 1.0
        } else {
            heartBtn.alpha = 0.25
        }
        if kanji.favorite == true {
            favButton.alpha = 1.0
        } else {
            favButton.alpha = 0.25
        }
        if kanji.knownKanji == true {
            knownButton.alpha = 1.0
        } else {
            knownButton.alpha = 0.25
        }
        detailDescriptionLabel.text = kanji.char
        meaningLabel.text = kanji.meaning
        onyomiLabel.text = kanji.onyomi.katakana
        kunyomiLabel.text = kanji.kunyomi.hiragana
        gradeLabel.text = String(describing: kanji.references.grade!)
        
        if kanji.examples.count > 0 {
            for i in 0...kanji.examples.count-1 {
                exampleText.text = exampleText.text + kanji.examples[i].japanese! + "\n"
                 exampleText.text = exampleText.text + kanji.examples[i].english! + "\n\n"

            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        synthesizer.delegate = self
        exampleText.isScrollEnabled = false
        
        // load from User Defaults
        lovedKanji = defaults.object(forKey: "LovedKanji") as? [String] ?? [String]()
        favKanji = defaults.object(forKey: "FavKanji") as? [String] ?? [String]()
        knownKanji = defaults.object(forKey: "KnownKanji") as? [String] ?? [String]()
        
        configureView()

    }


    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0, options: [], animations: {
            self.detailDescriptionLabel.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: {
            finished in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.detailDescriptionLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil )
        }
        )
        exampleText.isScrollEnabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .word)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StrokesVC" {
            if let strokesVC = segue.destination as? StrokesVC {
                if let senderKanji = sender as? Kanji {
                    strokesVC.kanji = senderKanji
                    
                }
            }
        }
        
        if segue.identifier == "AVPlayer" {
            let destination = segue.destination as! AVPlayerViewController
            let url = URL(string: kanji.kanjiImages.mp4!)
            
            if let movieURL = url {
                destination.player = AVPlayer(url: movieURL)
                destination.player?.play()
            }
        }
        
    }
    
    
    @IBAction func knownBtnPressed(_ sender: Any) {
        if kanji.knownKanji == true {
            kanji.knownKanji = false
            if let index = knownKanji.index(of: kanji.char) {
                knownKanji.remove(at: index)
            }
            knownButton.alpha = 0.3
        } else {
            kanji.knownKanji = true
            knownKanji.append(kanji.char)
            knownButton.alpha = 1.0
        }
        defaults.set(knownKanji, forKey: "KnownKanji")
    }
    
    
    @IBAction func starBtnPressed(_ sender: Any) {
        if kanji.favorite == true {
            kanji.favorite = false
            if let index = favKanji.index(of: kanji.char) {
                favKanji.remove(at: index)
            }
            favButton.alpha = 0.3
        } else {
            kanji.favorite = true
            favKanji.append(kanji.char)
            favButton.alpha = 1.0
        }
        defaults.set(favKanji, forKey: "FavKanji")
    }
    
    @IBAction func heartBtnPressed(_ sender: Any) {
        if kanji.loved == true {
            kanji.loved = false
            if let index = lovedKanji.index(of: kanji.char) {
                lovedKanji.remove(at: index)
            }
            heartBtn.alpha = 0.3
        } else {
            kanji.loved = true
            lovedKanji.append(kanji.char)
            heartBtn.alpha = 1.0
        }
        defaults.set(lovedKanji, forKey: "LovedKanji")
    }
    
    @IBAction func listenPressed(_ sender: Any) {
        
        var japaneseVoice = AVSpeechSynthesisVoice(language: "ja-JP")
        var englishVoice = AVSpeechSynthesisVoice(language: "en-US")
        var bestJ = false
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            
            
            if voice.language == "jp=JP" && voice.quality.rawValue == 2 {
                japaneseVoice = voice
            } else if (voice.language == "en-AU" || voice.language == "en-US" || voice.language == "en-GB") && voice.quality.rawValue == 2 {
                englishVoice = voice
            }
            
            if voice.identifier == "com.apple.ttsbundle.siri_female_ja-JP_premium" {
                bestJ = true
            }
            
            print(voice.language + " " + voice.name + " " + String(describing: voice.quality.rawValue) + " " + voice.identifier)
        }
        
        if bestJ == true {
            japaneseVoice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.siri_female_ja-JP_premium")
        }
        
        
        
        print((japaneseVoice?.name)! + (englishVoice?.name)!)

        if !synthesizer.isSpeaking {

            let exampleStrings = self.exampleText.text.components(separatedBy: .newlines)
            var exampleIndex = 0
            if exampleStrings.count > 1 {
                for _ in 0..<exampleStrings.count / 3 {
                    
                    var initialString = exampleStrings[exampleIndex]
                    var cleanArray = initialString.components(separatedBy: "（")
                    var utterance = AVSpeechUtterance(string: cleanArray[0])
                    utterance.voice = japaneseVoice
                    synthesizer.speak(utterance)
                    exampleIndex += 1
                    
                    initialString = exampleStrings[exampleIndex]
                    cleanArray = initialString.components(separatedBy: " [")
                    utterance = AVSpeechUtterance(string: cleanArray[0])
                    utterance.voice = englishVoice
                    exampleIndex += 2
                    synthesizer.speak(utterance)
                }
            }

            self.listenButton.setTitle("Stop", for: .normal)
            //utterance.rate = 0.3
            

        } else {
            
            synthesizer.stopSpeaking(at: .word)

            self.listenButton.setTitle("Speak", for: .normal)
        }
        speaking = !speaking
    }
    
   
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        self.listenButton.setTitle("Speak", for: .normal)
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        self.listenButton.setTitle("Stop", for: .normal)
        
    }
    
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        
    }
    
    @IBAction func StrokesBtnPressed(_ sender: Any) {
        //performSegue(withIdentifier: "StrokesVC", sender: kanji)

    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}

