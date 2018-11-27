//
//  SharedCourseViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 12. 3..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

class SharedCourseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource { // 마이메뉴 코스랑 공유 코스 보는 뷰
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CourseList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Course.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let imageview = cell.viewWithTag(1) as? UIImageView
        imageview?.image = UIImage(named: CourseList[indexPath.row]["image"]!)
        
        let name = cell.viewWithTag(2) as? UILabel
        name?.text = CourseList[indexPath.row]["name"]
        name?.font = UIFont(name: "KoreanSNROR", size: 20)
        name?.adjustsFontSizeToFitWidth = true
        
        let address = cell.viewWithTag(3) as? UILabel
        address?.text = CourseList[indexPath.row]["address"]
        address?.font = UIFont(name: "KoreanSNROR", size: 20)
        address?.adjustsFontSizeToFitWidth = true
        
        let intro = cell.viewWithTag(4) as? UILabel
        intro?.text = CourseList[indexPath.row]["intro"]
        intro?.font = UIFont(name: "KoreanSNROR", size: 20)
        intro?.adjustsFontSizeToFitWidth = true
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if CourseList.count == 0 {
            return "0개의 항목"
        } else {
            return "\(CourseList.count)개의 항목"
        }
    }
    
    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var navi: UINavigationBar!
    
    @IBOutlet var Course: UITableView!
    var CourseList : [[String : String]] = []
    var Km = UILabel()
    override func viewWillAppear(_ animated: Bool) {
        print(self.CourseList)
        self.Km.text = "대략적인 좌표간의 총 거리 \(round(self.distance(self.CourseList)/1000.0))km"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(Km)
        Km.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view.frame.height/20)
            make.centerX.equalTo(self.view)
            make.top.equalTo(navi.snp.bottom).offset(20)
        }
        Km.adjustsFontSizeToFitWidth = true
        Km.text = ""
        Km.font = UIFont(name: "KoreanSNROR", size: 20)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 10))
        Course.tableFooterView = footerView
        // Do any additional setup after loading the view.
    }

    func distance(_ latList : [[String : String]]) -> Double { //거리 재기
        
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
