//
//  MyMenuViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 11. 24..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MyMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.CourseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyCourse.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(self.CourseList[indexPath.row][0]["name"]!)시작 코스"
        cell.textLabel?.font = UIFont(name: "KoreanSNROR", size: 25)
        cell.textLabel?.tintColor = UIColor.white
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.imageView?.image = UIImage(named: self.CourseList[indexPath.row][0]["image"]!)
        return cell
    }
    

    @IBOutlet var MyCourse: UITableView!
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    var CourseList : [[[String : String]]] = []
    var TempCourseList : [[[String : String]]] = []
    @IBAction func out(_ sender: UIBarButtonItem) {
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "LogOut", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyCourse.frame.height/6
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if CourseList.count == 0 {
            return "0개의 항목"
        } else {
            return "\(self.CourseList.count)개의 항목"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        print(self.CourseList.count)
         self.CourseList.removeAll()
        if self.CourseList.count == 0 {
            self.CourseList.removeAll()
            print("add")
            ref?.child("User").child((Auth.auth().currentUser?.uid)!).child("Course").observe(.childAdded, with: { (snapshot) in
                if snapshot.value is NSNull {
                    print("NULL")
                } else {
                    if let item = snapshot.value as? [[String : String]] {
                        self.CourseList.append(item)
                        self.MyCourse.reloadData()
                        }
                    }
                })
            }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        ref = Database.database().reference()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 10))
        MyCourse.tableFooterView = footerView
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MyCourseView", sender: self)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { //해당 인덱스 값 삭제
            self.CourseList.remove(at: indexPath.row)
            TempCourseList = CourseList
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.CourseList.removeAll()
            ref?.child("User").child((Auth.auth().currentUser?.uid)!).child("Course").removeValue()
            for i in 0..<self.TempCourseList.count {
                ref?.child("User").child((Auth.auth().currentUser?.uid)!).child("Course").childByAutoId().setValue(self.TempCourseList[i])
            }  //해당 값 삭제 후 다시 저장
            return
            // Delete the row from the data source
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = MyCourse.indexPathForSelectedRow
        let destination = segue.destination as? SharedCourseViewController
        if let index1 = index {
            destination?.CourseList = self.CourseList[index1.row]
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
