//
//  HeritageViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 11. 10..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth
class HeritageViewController: UIViewController, MTMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    var reviewList : [[String : String]] = []
    var TempList : [String] = []
    var AllList : [[String : String]] = []
    var AllListCount : Int = 0
    var delegate: DataEnteredDelegate?
    var List : [String : String] = [:]
    var Location : String = ""
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    var width = UIScreen.main.bounds.width
    var height = UIScreen.main.bounds.height
    var Back = UIImageView()
    
    @IBOutlet weak var subview: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var navi: UINavigationBar!
    @IBOutlet weak var Review: UITableView!
    @IBOutlet weak var Mainimage : UIImageView!
    @IBOutlet weak var imageBtn1 : UIImageView!
    @IBOutlet weak var imageBtn2 : UIImageView!
    @IBOutlet weak var imageBtn3 : UIImageView!
    @IBOutlet weak var address : UILabel!
    @IBOutlet weak var name : UILabel!
    @IBOutlet weak var intro : UITextView!
    @IBOutlet weak var mapview : MTMapView!
    @IBOutlet weak var Favorite : UIButton!
    @IBOutlet weak var reviewBut : UIButton!
    @IBOutlet weak var Course : UIButton!
    @IBOutlet weak var callBut : UIButton!
    
    override func viewDidLayoutSubviews() {
        DispatchQueue.main.async {
            self.scroll.contentSize = CGSize(width: self.view.frame.size.width, height: self.subview.frame.size.height)
        }
    }

    @IBAction func previous(_ sender: UIBarButtonItem) {
        handle = ref?.child(Location).child("문화유산").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? [String : String] {
                self.AllList.append(item)
                if self.AllList.count == self.AllListCount {
                    self.delegate?.userDidEnterInformation(info: self.AllList)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        handle = ref?.child("Review").child(Location).child("문화유산").child(List["향토문화유적명"]!).observe(.childAdded, with: { (snapshot) in
            if snapshot.value is NSNull {//댓글이 하나도 없다.
                print("없다고")
            } else {
                if let item = snapshot.value as? [String : String] {
                    self.reviewList.append(item)
                    self.Review.reloadData()
                }
            }
        })
    }
    override func viewDidAppear(_ animated: Bool) {
        var items = [MTMapPOIItem]()
        items.append(poiItem(name: List["향토문화유적명"]!, latitude: Double(List["위도"]!)!, longitude: Double(List["경도"]!)!))
        
        mapview.addPOIItems(items)
        mapview.fitAreaToShowAllPOIItems()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        scroll.isDirectionalLockEnabled = true
        scroll.showsVerticalScrollIndicator = false
        mapview.delegate = self
        mapview.baseMapType = .standard
        ref = Database.database().reference()
        navi.backgroundColor = UIColor.lightGray
        navi.topItem?.title = ""
        subview.insertSubview(Back, belowSubview: imageBtn3)
        Back.snp.makeConstraints { (make) in
            make.size.equalTo(subview)
        }
        Back.image = UIImage(named: "star.jpeg")
        
        Mainimage.image = UIImage(named: List["이미지정보1"]!)
        imageBtn1.isUserInteractionEnabled = true
        imageBtn2.isUserInteractionEnabled = true
        imageBtn3.isUserInteractionEnabled = true
        imageBtn1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage(sender:))))
        imageBtn2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage(sender:))))
        imageBtn3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeImage(sender:))))
        imageBtn1.image = UIImage(named : List["이미지정보1"]!)
        imageBtn2.image = UIImage(named : List["이미지정보2"]!)
        imageBtn3.image = UIImage(named : List["이미지정보3"]!)
        
        callBut.addTarget(self, action: #selector(ActCall(sender:)), for: .touchUpInside)
        Favorite.addTarget(self, action: #selector(Thumb), for: .touchUpInside)
        reviewBut.addTarget(self, action: #selector(ActReview), for: .touchUpInside)
        Course.addTarget(self, action: #selector(AddCourse), for: .touchUpInside)
        name.textColor = UIColor.white
        address.textColor = UIColor.white
        intro.backgroundColor = UIColor.black
        intro.textColor = UIColor.white
        
        name.text = "이름 : \(List["향토문화유적명"]!)"
        address.text = "주소 : \(List["소재지도로명주소"]!)"
        intro.text = "설명 : \(List["향토문화유적소개"]!)"
        name.font = UIFont(name: "KoreanSNROR", size: 25)
        address.font = UIFont(name: "KoreanSNROR", size: 25)
        intro.font = UIFont(name: "KoreanSNROR", size: 25)
        
        name.adjustsFontSizeToFitWidth = true
        address.adjustsFontSizeToFitWidth = true
        intro.adjustsFontForContentSizeCategory = true
        
        // Do any additional setup after loading the view.
    }
    @objc func AddCourse() { //코스 등록 버튼 액션 눌리면
        let dic = ["name": List["향토문화유적명"]!, "address": List["소재지도로명주소"]!, "image": List["이미지정보1"]!, "lat": List["위도"]!, "lon": List["경도"]!, "intro": List["향토문화유적소개"]!]
        ref?.child("User").child((Auth.auth().currentUser?.uid)!).child("TempCourse").childByAutoId().setValue(dic)
    }
    @objc func Thumb() { //좋아요 버튼을 눌렀을 시
        if List["Count"] == nil { // 카운트라는 값이 없을 시 즉, 아무런 카운트가 없을 시
            let dic = ["Count" : "1"]
            ref?.child(Location).child("문화유산").child(List["향토문화유적명"]!).updateChildValues(dic)
            List["Count"] = "1"
            Favorite.isEnabled = false
            return
        } else { // 하나라도 값이 있을 시
            List["Count"] = String(Int(List["Count"]!)! + 1)
            ref?.child(Location).child("문화유산").child(List["향토문화유적명"]!).updateChildValues(List)
            Favorite.isEnabled = false
            return
        }
    }
    @objc func ActReview() {
        
        let Alert = UIAlertController(title: "리뷰", message: "댓글을 달아주세요.", preferredStyle: .alert)
        Alert.addTextField { (textfield) in
            textfield.placeholder = "댓글"
        }
        let confirm = UIAlertAction(title: "작성", style: .default) { //댓글을 작성하고 확인을 누르면 해당 관광지 란에 댓글 데이터 입력
            (action : UIAlertAction) -> Void in
            let dic = ["name" : (Auth.auth().currentUser?.email)!, "Content" : Alert.textFields?[0].text]
            self.ref?.child("Review").child(self.Location).child("문화유산").child(self.List["향토문화유적명"]!).childByAutoId().setValue(dic)
            if self.List["ReviewCount"] == nil { // 카운트라는 값이 없을 시 즉, 아무런 카운트가 없을 시
                let dic = ["ReviewCount" : "1"]
                self.ref?.child(self.Location).child("문화유산").child(self.List["향토문화유적명"]!).updateChildValues(dic)
                self.List["ReviewCount"] = "1"
                //self.Favorite.isEnabled = false
            } else { // 하나라도 값이 있을 시
                self.List["ReviewCount"] = String(Int(self.List["ReviewCount"]!)! + 1)
                self.ref?.child(self.Location).child("문화유산").child(self.List["향토문화유적명"]!).updateChildValues(self.List)
                //self.Favorite.isEnabled = false
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        Alert.addAction(confirm)
        Alert.addAction(cancel)
        present(Alert, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let dic = reviewList[indexPath.row]
        cell.textLabel?.text = dic["Content"]
        cell.textLabel?.font = UIFont(name: "KoreanSNROR", size: 23)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.text = dic["name"]
        cell.detailTextLabel?.font = UIFont(name: "KoreanSNROR", size: 18)
        cell.detailTextLabel?.adjustsFontSizeToFitWidth = true
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { // 댓글 삭제 시
            print("삭제")
            let dic = reviewList[indexPath.row]
            if dic["name"] == Auth.auth().currentUser?.email {// 삭제 클릭시 네임과 실제 접속 유저의 이메일과 동일하면 즉 자기가 쓴 글을 자기가 접근을 했을 시
                ref?.child("Review").child(self.Location).child("문화유산").child(self.List["향토문화유적명"]!).observe(.childAdded, with: { (snapshot) in
                    if snapshot.value is NSNull {
                        print("Nothing")
                    } else {
                        if let item = snapshot.value as? [String:String] {
                            if dic["Content"] == item["Content"] {
                                self.ref?.child("Review").child(self.Location).child("문화유산").child(self.List["향토문화유적명"]!).child(snapshot.key).removeValue()
                                self.reviewList.remove(at: indexPath.row)
                                self.List["ReviewCount"] = String(Int(self.List["ReviewCount"]!)!-1)
                                self.ref?.child(self.Location).child("문화유산").child(self.List["향토문화유적명"]!).setValue(self.List)
                                tableView.deleteRows(at: [indexPath], with: .fade)
                            }
                        }
                    }
                })
            }
            
            // Delete the row from the data source
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    func poiItem(name: String, latitude: Double, longitude: Double) -> MTMapPOIItem {
        let item = MTMapPOIItem()
        item.itemName = name
        item.markerType = .redPin
        item.markerSelectedType = .redPin
        item.mapPoint = MTMapPoint(geoCoord: .init(latitude: latitude, longitude: longitude))
        item.showAnimationType = .noAnimation
        item.customImageAnchorPointOffset = .init(offsetX: 30, offsetY: 0)    // 마커 위치 조정
        return item
    }
    @objc func changeImage(sender : UIButton) {
        Mainimage.image = sender.image(for: .normal)
    }
    @objc func ActCall(sender : UIButton) {
        if let url = URL(string: "telprompt://\(List["관리기관전화번호"]!)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
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
