//
//  ViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 10. 21..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, XMLParserDelegate {
    var tour : [String : String] = [:]
    var tours : [[String : String]] = []
    var List : [String : String] = [:]
    var blank : Bool = false
    var currentName = ""
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    @IBOutlet weak var image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let xml = Bundle.main.path(forResource: "tourChangwon", ofType: "xml")
        let xmlData = NSData(contentsOfFile: xml!)
        let parser = XMLParser(data: xmlData! as Data)
        parser.delegate = self
        let success = parser.parse()
        
        if success {
            print("Parsing Success")
        } else {
            print("Parsing Failure")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        for node in tours { //축제 데이터 파싱코드
            if node["소재지도로명주소"]?.range(of: "마산") != nil { // 주소에 마산이 들어가면
                ref?.child("마산").child("관광지").child(node["관광안내소명"]!).setValue(node)
            }
            else if node["소재지도로명주소"]?.range(of: "진해") != nil { // 주소에 마산이 들어가면
                ref?.child("진해").child("관광지").child(node["관광안내소명"]!).setValue(node)
            } else {
                ref?.child("창원").child("관광지").child(node["관광안내소명"]!).setValue(node)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentName = elementName
        blank = true
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if blank == true && currentName != "root" && currentName != "header" {
            if string != "\n" {
                tour[currentName] = string
            }
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Row" {
            tours.append(tour)
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

