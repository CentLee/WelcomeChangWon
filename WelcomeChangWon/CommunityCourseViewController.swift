//
//  CommunityCourseViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 12. 3..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class CommunityCourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LL.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SharedCourse.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = cell.viewWithTag(1) as? UILabel
        name?.text = "\(self.LL[indexPath.row][0]["Auth"]!)님이 공유한"
        name?.font = UIFont(name: "KoreanSNROR", size: 25)
        name?.adjustsFontSizeToFitWidth = true
        let CourseName = cell.viewWithTag(2) as? UILabel
        CourseName?.text = "\(self.LL[indexPath.row][0]["name"]!)시작 코스"
        CourseName?.font = UIFont(name: "KoreanSNROR", size: 25)
        CourseName?.adjustsFontSizeToFitWidth = true
        return cell
    }

    var LL : [[[String : String]]] = []
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    
    @IBOutlet var SharedCourse: UITableView!
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.LL.removeAll()
        if LL.count == 0 {
            ref?.child("Community").child("Course").observe(.childAdded, with: { (snapshot) in
                if snapshot.value is NSNull {
                    print("Null")
                } else {
                    print(snapshot.childrenCount)
                    if let item = snapshot.value as? [[String : String]] {
                        self.LL.append(item)
                        self.SharedCourse.reloadData()
                    }
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 10))
        SharedCourse.tableFooterView = footerView
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ComCourseView", sender: self)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = SharedCourse.indexPathForSelectedRow
        let destination = segue.destination as? SharedCourseViewController
        if let index1 = index {
           destination?.CourseList = self.LL[index1.row]
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
