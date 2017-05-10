//
//  CollectionViewController.swift
//  Study Kanji
//
//  Created by User on 4/24/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate  {
        
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentedBar: UISegmentedControl!
    
    var fullList = [Kanji]()
    var inSearchMode = false
    var filteredKanji: [Kanji] = []
    var defaultKanji = Kanji(char: " ", meaning: " ")
    var lovedKanji = [String]()
    var favKanji = [String]()
    var knownKanji = [String]()
    var animateOption = true
    var savedLevel = 0
    let defaults:UserDefaults = UserDefaults.standard

    //MARK: - View Loading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.isTranslucent = true
        searchBar.keyboardAppearance = .dark
        searchBar.returnKeyType = .done
        
        segmentedBar.selectedSegmentIndex = defaults.object(forKey: "SavedLevel") as? Int ?? 0

        readJson()
        setSavedFavorites()
        filterKanji()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.animateOption = defaults.object(forKey: "SplashAnimateOption") as? Bool ?? true

        setSavedFavorites()
        filterKanji()
    }
    
    //MARK: - JSON
    
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "response", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [NSDictionary] {
                    // json is an array
                    print(object[5])
                    print(object.count)
                    for i in 0...object.count-1 {
                        if let record = object[i] as? [String: Any] {
                            // each item is here
                            let newKanji = Kanji(char: "none", meaning: "none")
                            if let kanjiRecord = record["kanji"] as? [String: Any] {
                                // first grab each kanji
                                if let char = kanjiRecord["character"] as? String,
                                    let meaning = kanjiRecord["meaning"] as? NSDictionary {
                                    if let englishMeaning = meaning["english"] as? String {
                                        newKanji.char = char
                                        newKanji.meaning = englishMeaning
                                        if let kunyomi = kanjiRecord["kunyomi"] as? [String: Any] {
                                            if let hiragana = kunyomi["hiragana"] as? String {
                                                newKanji.kunyomi.hiragana = hiragana
                                            }
                                            if let romaji = kunyomi["romaji"] as? String {
                                                newKanji.kunyomi.romaji = romaji
                                            }
                                        }
                                        if let onyomi = kanjiRecord["onyomi"] as? [String: Any] {
                                            if let katakana = onyomi["katakana"] as? String {
                                                newKanji.onyomi.katakana = katakana
                                            }
                                            if let romaji = onyomi["romaji"] as? String {
                                                newKanji.onyomi.romaji = romaji
                                            }
                                        }
                                        if let strokes = kanjiRecord["strokes"] as? [String: Any] {
                                            if let images = strokes["images"] as? [String] {
                                                newKanji.strokes = images
                                            }
                                        }
                                        
                                        if let video = kanjiRecord["video"] as? [String: Any] {
                                            if let mp4 = video["mp4"] as? String {
                                                newKanji.kanjiImages.mp4 = mp4
                                            }
                                            if let poster = video["poster"] as? String {
                                                newKanji.kanjiImages.poster = poster
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                            // grab examples
                            if let kanjiRecord = record["examples"] as? [NSDictionary] {
                                var examples = [Example]()
                                for index in 0...kanjiRecord.count-1 {
                                    var example = Example()
                                    if let exampleTemp = kanjiRecord[index] as? [String: Any] {
                                        example.japanese = exampleTemp["japanese"] as? String
                                        if let englishTemp = exampleTemp["meaning"] as? [String: Any] {
                                            example.english = englishTemp["english"] as? String
                                            
                                        }
                                        examples.append(example)
                                    }
                                    
                                }
                                newKanji.examples = examples
                                
                            }
                            /*
                            if let kanjiRecord = record["radical"] as? [String: Any] {
                                //capture radical
                            }
                            */
                            // grab references
                            if let kanjiRecord = record["references"] as? [String: Any] {
                                if let nelson = kanjiRecord["classic_nelson"] as? String {
                                    newKanji.references.nelson = nelson
                                }
                                if let grade = kanjiRecord["grade"] as? Int {
                                    newKanji.references.grade = grade
                                }
                                if let koshanda = kanjiRecord["koshanda"] as? String {
                                    newKanji.references.kodansha = koshanda
                                }
                            }
                            
                            fullList.append(newKanji)
                        }
                        
                    }
                    
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Load Saved, Loved and Favorites
    
    func setSavedFavorites() {
        lovedKanji = defaults.object(forKey: "LovedKanji") as? [String] ?? [String]()
        favKanji = defaults.object(forKey: "FavKanji") as? [String] ?? [String]()
        knownKanji = defaults.object(forKey: "KnownKanji") as? [String] ?? [String]()
        
        for i in 0...fullList.count-1 {
            if lovedKanji.contains(fullList[i].char) {
                fullList[i].loved = true
            }
            if favKanji.contains(fullList[i].char) {
                fullList[i].favorite = true
            }
            if knownKanji.contains(fullList[i].char) {
                fullList[i].knownKanji = true
            }
        }
        
    }
    
    //MARK: - Collection View
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "KanjiCell", for: indexPath) as? KanjiCollectionViewCell {
            
            var kanji = defaultKanji

            
            if indexPath.row < filteredKanji.count {
                kanji = filteredKanji[indexPath.row]
                if kanji.kunyomi.hiragana == "n/a" {
                    kanji.kunyomi.hiragana = " "
                }
                if kanji.onyomi.katakana == "n/a" {
                    kanji.onyomi.katakana = " "
                }
                if kanji.knownKanji == true {
                    cell.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)
                } else {
                    cell.backgroundColor = UIColor.white
                }
            }
            
            cell.configureCell(kanji: kanji)

            return cell
            
        } else {
            
            return UICollectionViewCell()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedKanji = filteredKanji[indexPath.row]
        

        
        performSegue(withIdentifier: "DetailViewController", sender: selectedKanji)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredKanji.count
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 88, height: 132)
        
    }
    
    //MARK: - Search Bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            view.endEditing(true)
            //in Search Mode = false
            filterKanji()
            collection.reloadData()
        } else {
            //in Search Mode = true
            let lower = searchBar.text!.lowercased()
            
            filteredKanji = fullList.filter({$0.char.range(of: lower, options: .caseInsensitive) != nil})
            let filteredKanji2 = fullList.filter({$0.meaning.range(of: lower, options: .caseInsensitive) != nil})
            let filteredKanji3 = fullList.filter({$0.kunyomi.hiragana?.range(of: lower, options: .caseInsensitive) != nil})
            let filteredKanji4 = fullList.filter({$0.onyomi.katakana?.range(of: lower, options: .caseInsensitive) != nil})
            filteredKanji += filteredKanji2 + filteredKanji3 + filteredKanji4
            collection.reloadData()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filterKanji()
        searchBar.text = ""
        self.searchBar.resignFirstResponder()
    }
    
    //MARK: - Segmented Bar
    
    @IBAction func segmentPressed(_ sender: Any) {
        filterKanji()
        searchBar.text = ""
        defaults.set(self.segmentedBar.selectedSegmentIndex, forKey: "SavedLevel")

    }
    
    //MARK: - Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailViewController" {
            if let detailsVC = segue.destination as? DetailViewController {
                if let senderKanji = sender as? KanjiCollectionViewCell {
                    detailsVC.kanji = senderKanji.kanji
                    print(senderKanji.kanji.char)
                }
            }
        }
        if segue.identifier == "GameVC" {
            if let detailsVC = segue.destination as? GameVC {
                if let senderKanji = sender as? [Kanji] {
                    detailsVC.fullList = senderKanji
                }
            }
        }
    }
    
    //MARK: - Filter
    
    func filterKanji() {
        
        filteredKanji = []
        let grade = Int(self.segmentedBar.titleForSegment(at: self.segmentedBar.selectedSegmentIndex)!)
        if grade != nil {
            for i in 0...fullList.count-1 {
                if fullList[i].references.grade == grade {
                    filteredKanji.append(fullList[i])
                }
            }
        } else {
            if self.segmentedBar.selectedSegmentIndex == 5 {
                for i in 0...fullList.count-1 {
                    if fullList[i].loved == true {
                        filteredKanji.append(fullList[i])
                    }
                }
            } else if self.segmentedBar.selectedSegmentIndex == 6{
                for i in 0...fullList.count-1 {
                    if fullList[i].favorite == true {
                        filteredKanji.append(fullList[i])
                    }
                }
            }
        }
        
        print("The group is: \(String(describing: grade))")
        

        collection.reloadData()
    }
    
    //MARK: - Options
    @IBAction func optionsPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Splash Screen Options", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.view.backgroundColor = UIColor.clear
        alertController.view.tintColor = UIColor.darkGray
        var lineOneText = "Turn Initial Animation - OFF"
        if self.animateOption == false {
            lineOneText = "Turn Initial Animation - ON"
        }
        
        alertController.addAction(UIAlertAction(title: lineOneText, style: UIAlertActionStyle.default, handler: { (action) in
            print("ok button pressed")
            self.animateOption = !self.animateOption
            self.defaults.set(self.animateOption, forKey: "SplashAnimateOption")
        }))
        
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action) in
            print("cancel pressed")
            
            
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: - Game Seque
    
    @IBAction func gameBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "GameVC", sender: filteredKanji)
        
    }
    
    
  /*
        @IBAction func infoPressed(_ sender: Any) {
            
            let alert = UIAlertController(title: "TBD", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
     */
        
}

