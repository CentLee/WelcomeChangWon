//
//  SearchViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 10. 21..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import SnapKit
protocol DataEnteredDelegate {
    func userDidEnterInformation(info: [[String : String]])
}
class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DataEnteredDelegate {
    var ClassName : String = ""
    var Name : [String] = []
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    var key : [String] = []
    var iden : String = ""
    var List : [[String : String]] = []
    var allList : [[String : String]] = []
    var str : [String] = []
    var Location : String = ""
    var Check = UIButton()
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var search: UITableView!
    override func viewDidAppear(_ animated: Bool) {
        //search.isHidden = true
        print(List)
        self.search.reloadData()
    }
    @IBAction func Search(_ sender: UIButton) {
        key = []
        List = []
        str = []
        SelectAlert()
        print(List)
        
    }
    func userDidEnterInformation(info: [[String : String]]) {
        List = info
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if List.count == 0 {
            return "0개의 항목"
        } else {
            return "\(self.List.count)개의 항목"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.view.addSubview(Check)
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 10))
        search.tableFooterView = footerView
        searchButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-20)
        }
        Check.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width/5)
            make.height.equalTo(self.view.frame.height/30)
            make.top.equalTo(searchButton).offset(20)
            make.centerX.equalTo(self.view)
        }
        Check.setImage(UIImage(named : "Filltering.jpg"), for: .normal)
        Check.addTarget(self, action: #selector(Filltering), for: .touchUpInside)
        Check.isHighlighted = true
    }
    @objc func Filltering() {
        if List.count != 0 {
            let Alert = UIAlertController(title: "필터링", message: "옵션을 선택하세요.", preferredStyle: .actionSheet)
            let Favorite = UIAlertAction(title: "좋아요 순", style: .default) { (action) in
                self.List = self.FillteringOption(self.List, "Count")
                self.search.reloadData()
            }
            let Review = UIAlertAction(title: "리뷰 갯수 순", style: .default) { (action) in
                self.List = self.FillteringOption(self.List, "ReviewCount")
                self.search.reloadData()
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            Alert.addAction(Favorite)
            Alert.addAction(Review)
            Alert.addAction(cancel)
            present(Alert, animated: true, completion: nil)
        }
        
        
    }
    func checkNil(_ TempList : [[String : String]],_ iden : String) -> [[String : String]] { //카운트 없는 값 ㅊ ㅔ 크
        var List1 = TempList
        for i in 0...List1.count-1 {
            if List1[i][iden] == nil {
                List1[i][iden] = "0"
            }
        }
        return List1
    }
    func FillteringOption(_ TempList : [[String : String]],_ iden : String) -> [[String : String]] {
        var List1 = TempList
        List1 = checkNil(List1, iden)
        if List1.count == 1 {
            print("하난데?")
            return List1
        } else {
            for i in (1...List1.count-1).reversed() {
                for j in 0...i-1 {
                    if Int(List1[j][iden]!)! > Int(List1[j+1][iden]!)! {//앞 뒤 둘다 닐이 아닐때
                        continue
                    }
                    else if Int(List1[j][iden]!)! < Int(List1[j+1][iden]!)! {
                        List1.swapAt(j, j+1)
                        print("Swap Condition")
                        
                    }
                }
            }
        }
        return List1
    }
    func MenuAlert(_ Location : String) {
        handle = ref?.child(Location).observe(.value, with: { (snapshot) in
            for child in snapshot.children {
                let user = child as! DataSnapshot
                let key = user.key
                self.key.append(key)
            }
            if self.key.count == Int(snapshot.childrenCount) {
                self.LocationAlert(self.key, Location)
            }
        })
    }
    func LocationAlert(_ List : [String], _ Location : String) {
        let Alert = UIAlertController(title: Location, message: nil, preferredStyle: .alert)
        let tour = UIAlertAction(title: List[0], style: .default) {
            (action : UIAlertAction) -> Void in
            self.handle = self.ref?.child(Location).child(List[0]).observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? [String : String] {
                    
                    self.List.append(item)
                    self.str.append(snapshot.key)
                    self.iden = List[0]
                }
                self.search.reloadData()
            })
        }
        let Food = UIAlertAction(title: List[1], style: .default) {
            (action : UIAlertAction) -> Void in
            self.handle = self.ref?.child(Location).child(List[1]).observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? [String : String] {
                    
                    self.List.append(item)
                    self.str.append(snapshot.key)
                    self.iden = List[1]

                }
                self.search.reloadData()
            })
        }
        let Heritage = UIAlertAction(title: List[2], style: .default) {
            (action : UIAlertAction) -> Void in
            self.handle = self.ref?.child(Location).child(List[2]).observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? [String : String] {
                    self.List.append(item)
                    self.str.append(snapshot.key)
                    self.iden = List[2]
                }
                self.search.reloadData()
            })
        }
        let Festival = UIAlertAction(title: List[3], style: .default) {
            (action : UIAlertAction) -> Void in
            self.handle = self.ref?.child(Location).child(List[3]).observe(.childAdded, with: { (snapshot) in
                if let item = snapshot.value as? [String : String] {
                    self.List.append(item)
                    self.str.append(snapshot.key)
                    self.iden = List[3]
                    
                    
                }
                self.search.reloadData()
            })
        }
        Alert.addAction(tour)
        Alert.addAction(Food)
        Alert.addAction(Heritage)
        Alert.addAction(Festival)
        present(Alert, animated: true, completion: nil)
    }
    func SelectAlert() {
        let Alert = UIAlertController(title: "분류를 선택하시오", message: nil, preferredStyle: .alert)
        let changwon = UIAlertAction(title: "창원", style: .default) {
            (action : UIAlertAction) -> Void in
            self.handle = self.ref?.child("창원").observe(.value, with: { (snapshot) in
                self.MenuAlert("창원")
                self.Location = "창원"
            })
        }
        let Masan = UIAlertAction(title: "마산", style: .default) {
            (action : UIAlertAction) -> Void in
            self.handle = self.ref?.child("마산").observe(.value, with: { (snapshot) in
                self.MenuAlert("마산")
                self.Location = "마산"
            })
        }
        let Jinhae = UIAlertAction(title: "진해", style: .default) {
            (action : UIAlertAction) -> Void in
            self.handle = self.ref?.child("진해").observe(.value, with: { (snapshot) in
                self.MenuAlert("진해")
                self.Location = "진해"
            })
        }
        Alert.addAction(changwon)
        Alert.addAction(Masan)
        Alert.addAction(Jinhae)
        present(Alert, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return List.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.darkGray
        }
        else {
            cell.backgroundColor = UIColor.black
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = search.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //print(iden)
        if iden == "맛집" {
            let dic = List[indexPath.row]
            let label = cell.viewWithTag(1) as? UILabel
            label?.text = dic["이름"] //이름
            let label1 = cell.viewWithTag(2) as? UILabel
            label1?.text = dic["주소"]
            label?.font = UIFont(name: "KoreanSNROR", size: 23)
            label1?.font = UIFont(name: "KoreanSNROR", size: 23)
            label?.tintColor = UIColor.white
            label1?.tintColor = UIColor.white
            label?.adjustsFontSizeToFitWidth = true
            label1?.adjustsFontSizeToFitWidth = true
            let image = cell.viewWithTag(3) as? UIImageView
            image?.image = UIImage(named: dic["사진"]!)
        }
        else if iden == "관광지" {
            let dic = List[indexPath.row]
            let label = cell.viewWithTag(1) as? UILabel
            label?.text = dic["관광안내소명"] //이름
            label?.adjustsFontSizeToFitWidth = true
            let label1 = cell.viewWithTag(2) as? UILabel
            label1?.text = dic["소재지도로명주소"]
            label1?.adjustsFontSizeToFitWidth = true
            label?.font = UIFont(name: "KoreanSNROR", size: 23)
            label1?.font = UIFont(name: "KoreanSNROR", size: 23)
            label?.tintColor = UIColor.white
            label1?.tintColor = UIColor.white
            
            let image = cell.viewWithTag(3) as? UIImageView
            image?.image = UIImage(named: dic["사진"]!)
        }
        else if iden == "문화유산" {
            
            let dic = List[indexPath.row]
            let image = cell.viewWithTag(3) as? UIImageView
            print(dic["이미지정보1"]!)
            image?.image = UIImage(named: dic["이미지정보1"]!)
            let label = cell.viewWithTag(1) as? UILabel
            label?.text = dic["향토문화유적명"] //이름
            label?.adjustsFontSizeToFitWidth = true
            let label1 = cell.viewWithTag(2) as? UILabel
            label1?.text = dic["소재지도로명주소"]
            label1?.adjustsFontSizeToFitWidth = true
            label?.font = UIFont(name: "KoreanSNROR", size: 23)
            label1?.font = UIFont(name: "KoreanSNROR", size: 23)
            label?.tintColor = UIColor.white
            label1?.tintColor = UIColor.white
        }
        else { //축제일 때
            let dic = List[indexPath.row]
            let label = cell.viewWithTag(1) as? UILabel
            label?.text = dic["축제명"] //이름
            label?.adjustsFontSizeToFitWidth = true
            let label1 = cell.viewWithTag(2) as? UILabel
            label1?.text = dic["소재지도로명주소"]
            label1?.adjustsFontSizeToFitWidth = true
            label?.font = UIFont(name: "KoreanSNROR", size: 23)
            label1?.font = UIFont(name: "KoreanSNROR", size: 23)
            label?.tintColor = UIColor.white
            label1?.tintColor = UIColor.white
            
            let image = cell.viewWithTag(3) as? UIImageView
            image?.image = UIImage(named: dic["사진"]!)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if iden == "맛집" {
            performSegue(withIdentifier: "Food", sender: self)
            
        }
        else if iden == "관광지" {
            performSegue(withIdentifier: "Tour", sender: self)
        }
        else if iden == "문화유산" {
            performSegue(withIdentifier: "heritage", sender: self)
        }
        else {
           performSegue(withIdentifier: "Festival", sender: self)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Food" {
           let select = search.indexPathForSelectedRow
           let destination = segue.destination as! FoodViewController
            if let index = select {
                destination.List = self.List[index.row]
                destination.AllListCount = List.count
                destination.delegate = self
                destination.Location = Location
            }
        }//맛집 선택 뷰 정보
        if segue.identifier == "Tour" {
            let select = search.indexPathForSelectedRow
            let destination = segue.destination as! TourViewController
            if let index = select {
                destination.List = self.List[index.row]
                destination.AllListCount = List.count
                destination.delegate = self
                destination.Location = Location
            }
        }//맛집 선택 뷰 정보
        if segue.identifier == "heritage" {
            let select = search.indexPathForSelectedRow
            let destination = segue.destination as! HeritageViewController
            if let index = select {
                destination.List = self.List[index.row]
                destination.AllListCount = List.count
                destination.delegate = self
                destination.Location = Location
            }
        }//맛집 선택 뷰 정보
        if segue.identifier == "Festival" {
            let select = search.indexPathForSelectedRow
            let destination = segue.destination as! FestivalViewController
            if let index = select {
                destination.List = self.List[index.row]
                destination.AllListCount = List.count
                destination.delegate = self
                destination.Location = Location
            }
        }//축제 선택 뷰 정보
    }
 

}
