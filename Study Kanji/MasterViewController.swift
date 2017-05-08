//
//  MasterViewController.swift
//  Study Kanji
//
//  Created by User on 4/24/17.
//  Copyright © 2017 TheSitePass. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    //var objects = [Any]()
    var fullList = [Kanji]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.leftBarButtonItem = editButtonItem
        
        readJson()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(_ sender: Any) {
        //objects.insert(NSDate(), at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = fullList[indexPath.row] as! NSDate
             //   let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
           //     controller.detailItem = object
           //     controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
           //     controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fullList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = (fullList[indexPath.row].char + " " +  fullList[indexPath.row].meaning)
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    // MARK: - Helper Functions
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
                        //print(object[i])
                        if let record = object[i] as? [String: Any] {
                            //print(record["kanji"])
                            // each item is here
                            let newKanji = Kanji(char: "none", meaning: "none")
                            if let kanjiRecord = record["kanji"] as? [String: Any] {
                                // first grab each kanji
                                if let char = kanjiRecord["character"] as? String,
                                    let meaning = kanjiRecord["meaning"] as? NSDictionary {
                                    if let englishMeaning = meaning["english"] as? String {
                                        newKanji.char = char
                                        newKanji.meaning = englishMeaning
                                        //print(newKanji.char, newKanji.meaning)
                                        if let kunyomi = kanjiRecord["kunyomi"] as? [String: Any] {
                                            if let hiragana = kunyomi["hiragana"] as? String {
                                                newKanji.kunyomi.hiragana = hiragana
                                                //print(newKanji.kunyomi.hiragana)
                                            }
                                            if let romaji = kunyomi["romaji"] as? String {
                                                newKanji.kunyomi.romaji = romaji
                                                //print(newKanji.kunyomi.romaji)
                                            }
                                        }
                                        if let onyomi = kanjiRecord["onyomi"] as? [String: Any] {
                                            if let katakana = onyomi["katakana"] as? String {
                                                newKanji.onyomi.katakana = katakana
                                                //print(newKanji.onyomi.katakana)
                                            }
                                            if let romaji = onyomi["romaji"] as? String {
                                                newKanji.onyomi.romaji = romaji
                                                //print(newKanji.onyomi.romaji)
                                            }
                                        }
                                        if let strokes = kanjiRecord["strokes"] as? [String: Any] {
                                            if let images = strokes["images"] as? [String] {
                                                newKanji.strokes = images
                                                //newKanji.downloadStrokeImages()
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
                            
                            if let kanjiRecord = record["radical"] as? [String: Any] {
                                //capture radical
                            }
                            
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
                            print(newKanji.char)
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

    
    
}

