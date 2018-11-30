//
//  CourseViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 12. 1..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SnapKit
import CoreLocation

struct CourseItem {
    var name : String
    var address : String
    var image : String
    var lat : String
    var lon : String
    var intro : String
}
class CourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var CourseList : [CourseItem] = []
    var List : [[String:String]] = []
    var TempList : [[String : String]] = []
    var SharedList : [[String : String]] = []
    var positionList : [[String : String]] = []
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    var Km = UILabel()

    
    var bool : Bool = false
    @IBOutlet weak var completeBut : UIButton!
    func distance(_ latList : [[String : String]]) -> Double {
        var Total : Double = 0
        for i in 0..<latList.count {
            if i == latList.count-1 {
                break
            }
            let distance = CLLocation(latitude: Double(latList[i]["lat"]!)!, longitude: Double(latList[i]["lon"]!)!)
            let distance1 = CLLocation(latitude: Double(latList[i+1]["lat"]!)!, longitude: Double(latList[i+1]["lon"]!)!)
            let meter = distance.distance(from: distance1)
            Total += meter
        }
        return Total
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return List.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CourseView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let image = cell.viewWithTag(1) as? UIImageView
        image?.image = UIImage(named: List[indexPath.row]["image"]!)
        
        let name = cell.viewWithTag(2) as? UILabel
        name?.text = List[indexPath.row]["name"]
        name?.font = UIFont(name: "KoreanSNROR", size: 25)
        name?.adjustsFontSizeToFitWidth = true
        
        let address = cell.viewWithTag(3) as? UILabel
        address?.text = List[indexPath.row]["address"]
        address?.font = UIFont(name: "KoreanSNROR", size: 25)
        address?.adjustsFontSizeToFitWidth = true
        
        let intro = cell.viewWithTag(4) as? UILabel
        intro?.text = List[indexPath.row]["intro"]
        intro?.font = UIFont(name: "KoreanSNROR", size: 25)
        intro?.adjustsFontSizeToFitWidth = true
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if List.count == 0 {
            return "0개의 항목"
        } else {
            return "\(self.List.count)개의 항목"
        }
    }

    @IBOutlet var CourseView: UITableView!
    var locationManager:CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference() // connect
        self.view.addSubview(Km)

        Km.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width)
            make.height.equalTo(self.view.frame.height/40)
            make.top.equalTo(completeBut.snp.bottom).offset(20)
            make.centerX.equalTo(self.view)
        }

        Km.adjustsFontSizeToFitWidth = true
        Km.text = ""
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 10))
        CourseView.tableFooterView = footerView
        // Do any additional setup after loading the view.
    }


    func BoolWhat() -> Bool {
        return true
    }
    @IBAction func SetCourse() {
        
        SharedList = self.List
        if List.count != 0 {
            self.ref?.child("User").child((Auth.auth().currentUser?.uid)!).child("Course").childByAutoId().setValue(self.List)
            SharedList[0]["Auth"] = (Auth.auth().currentUser?.email)!
            self.ref?.child("User").child((Auth.auth().currentUser?.uid)!).child("TempCourse").removeValue()
            self.Km.text = ""
            self.List.removeAll()
            self.CourseView.reloadData()
            
            let Alert = UIAlertController(title: "공유", message: "커뮤니티에 공유 하시겠습니까?", preferredStyle: .alert)
            let confirm = UIAlertAction(title: "공유", style: .default) {
                (action : UIAlertAction) -> Void in
                print(self.SharedList)
                
                self.ref?.child("Community").child("Course").childByAutoId().setValue(self.SharedList)//커뮤니티에 저장
                
                
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            Alert.addAction(confirm)
            Alert.addAction(cancel)
            present(Alert, animated: true, completion: nil)
            return
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {

        
        List.removeAll()
        self.bool = false
        if List.count == 0 { // 기본 데이터 가져오기 구문
            handle = ref?.child("User").child((Auth.auth().currentUser?.uid)!).child("TempCourse").observe(.childAdded, with: { (snapshot) in
                if snapshot.value is NSNull {
                    print("NULL")
                    self.completeBut.isEnabled = false
                } else {
                    if let item = snapshot.value as? [String : String] {
                        
                        self.List.append(item)
                        self.completeBut.isEnabled = true
                        self.CourseView.reloadData()
                        self.Km.text = "대략적인 좌표간의 총 거리 \(round(self.distance(self.List)/1000.0))km"
                    }
                }
            })
        }
        }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let dic = self.List[indexPath.row]
            ref?.child("User").child((Auth.auth().currentUser?.uid)!).child("TempCourse").observe(.childAdded, with: { (snapshot) in
                if snapshot.value is NSNull {
                    print("NULL")
                    self.completeBut.isEnabled = false
                } else {
                    if let item = snapshot.value as? [String : String] {

                        if dic["name"] == item["name"] {
                            self.ref?.child("User").child((Auth.auth().currentUser?.uid)!).child("TempCourse").child(snapshot.key).removeValue()
                            self.List.remove(at: indexPath.row)
                            tableView.deleteRows(at: [indexPath], with: .fade)
                            self.Km.text = "대략적인 좌표간의 총 거리 \(round(self.distance(self.List)/1000.0))km"
                            self.CourseView.reloadData()
                            }
                        }
                    }
                
            })
        // Delete the row from the data source
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
