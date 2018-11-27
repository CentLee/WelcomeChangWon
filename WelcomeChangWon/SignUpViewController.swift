//
//  SignUpViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 11. 24..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var EmailText = UITextField()
    var PasswordText = UITextField()
    var Name = UITextField()
    var Age = UITextField()
    var Uni = UITextField() // 성별
    var back = UIImageView()
    var verify = UIButton()
    var cancel = UIButton()
    var Title = UILabel()
    let toolbar = UIToolbar()
    let toolbar1 = UIToolbar()
    
    var pickoption1 = ["남자", "여자"]
    var pickoption2 = ["10대", "20대", "30대", "40대", "50대"]
    var ref : DatabaseReference?
    var handle : DatabaseHandle?
    var picker = UIPickerView()
    var picker1 = UIPickerView()
    @objc func donePicker(sender : UIBarButtonItem!) {
        Age.resignFirstResponder()
    }
    @objc func donePicker1(sender : UIBarButtonItem!) {
        Uni.resignFirstResponder()
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        let su = self.view!
        picker.delegate = self
        picker1.delegate = self
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        toolbar1.barStyle = .default
        toolbar1.sizeToFit()
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(donePicker))
        view.addGestureRecognizer(tap)
        let tap1 : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(donePicker1))
        view.addGestureRecognizer(tap1)
        
        let donebutton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker))
        let donebutton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePicker1))
        toolbar.setItems([donebutton], animated: false)
        toolbar.isUserInteractionEnabled = true
        toolbar1.setItems([donebutton1], animated: false)
        toolbar1.isUserInteractionEnabled = true
        Age.inputAccessoryView = toolbar
        Age.inputView = picker
        Uni.inputAccessoryView = toolbar1
        Uni.inputView = picker1
        
        su.addSubview(EmailText)
        su.addSubview(PasswordText)
        su.addSubview(Name)
        su.addSubview(Age)
        su.addSubview(Uni)
        su.addSubview(Title)
        su.addSubview(verify)
        su.addSubview(cancel)
        su.insertSubview(back, belowSubview: EmailText)
        
        back.snp.makeConstraints { (make) in
            make.size.equalTo(su)
        }
        back.image = UIImage(named: "water.jpg")
        
        Title.snp.makeConstraints { (make) in
            make.width.equalTo(su.frame.width/2)
            make.height.equalTo(su.frame.height/20)
            make.top.equalTo(su).offset(20)
            make.centerX.equalTo(su)
        }
        Title.text = "회원가입"
        Title.adjustsFontSizeToFitWidth = true
        Title.textAlignment = .center
        
        EmailText.snp.makeConstraints { (make) in
            make.width.equalTo(su.frame.width/2)
            make.height.equalTo(su.frame.height/20)
            make.top.equalTo(Title.snp.bottom).offset(30)
            make.centerX.equalTo(su)
        }
        PasswordText.snp.makeConstraints { (make) in
            make.size.equalTo(EmailText)
            make.top.equalTo(EmailText.snp.bottom).offset(10)
            make.centerX.equalTo(su)
        }
        Name.snp.makeConstraints { (make) in
            make.size.equalTo(EmailText)
            make.top.equalTo(PasswordText.snp.bottom).offset(10)
            make.centerX.equalTo(su)
        }
        Age.snp.makeConstraints { (make) in
            make.size.equalTo(EmailText)
            make.top.equalTo(Name.snp.bottom).offset(10)
            make.centerX.equalTo(su)
        }
        Uni.snp.makeConstraints { (make) in
            make.size.equalTo(EmailText)
            make.top.equalTo(Age.snp.bottom).offset(10)
            make.centerX.equalTo(su)
        }
        verify.snp.makeConstraints { (make) in
            make.width.equalTo(su.frame.width/3)
            make.height.equalTo(su.frame.height/30)
            make.centerX.equalTo(su)
            make.top.equalTo(Uni.snp.bottom).offset(40)
        }
        cancel.snp.makeConstraints { (make) in
            make.size.equalTo(verify)
            make.centerX.equalTo(su)
            make.top.equalTo(verify.snp.bottom).offset(10)
        }
        EmailText.attributedPlaceholder = NSAttributedString(string: "Email ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
        PasswordText.attributedPlaceholder = NSAttributedString(string: "Password ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
        Name.attributedPlaceholder = NSAttributedString(string: "이름 ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
        Age.attributedPlaceholder = NSAttributedString(string: "나이 ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
        Uni.attributedPlaceholder = NSAttributedString(string: "성별 ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
        EmailText.borderStyle = .roundedRect
        PasswordText.borderStyle = .roundedRect
        Name.borderStyle = .roundedRect
        Age.borderStyle = .roundedRect
        Uni.borderStyle = .roundedRect
        EmailText.backgroundColor = UIColor.white
        PasswordText.backgroundColor = UIColor.white
        Name.backgroundColor = UIColor.white
        Age.backgroundColor = UIColor.white
        Uni.backgroundColor = UIColor.white
        EmailText.autocapitalizationType = .none
        PasswordText.autocapitalizationType = .none
        PasswordText.isSecureTextEntry = true
        EmailText.autocorrectionType = .no
        PasswordText.autocorrectionType = .no
        Name.autocorrectionType = .no
        verify.setImage(UIImage(named: "join.jpg"), for: .normal)
        verify.addTarget(self, action: #selector(Signup), for: .touchUpInside)
        cancel.setImage(UIImage(named : "Return.jpg"), for: .normal)
        cancel.addTarget(self, action: #selector(Cancel), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    @objc func Cancel(sender : UIButton) {
        performSegue(withIdentifier: "Return", sender: self)
    }
    func SuccessSignup(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) {
            (action : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "Success", sender: self)
        }
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    @objc func Signup(sender : UIButton) {
        if EmailText.text! != "" && PasswordText.text! != "" && Age.text! != "" && Name.text! != "" && Uni.text! != "" { // 공백이 아니면
            Auth.auth().createUser(withEmail: EmailText.text!, password: PasswordText.text!, completion: { (user, error) in
                if user != nil { // 중복검사를 거쳐 없는 유저이면
                    print("success")
                    let data = ["Email_Name" : self.EmailText.text!]
                    let data1 = ["generation" : self.Age.text!]
                    let data2 = ["Name" : self.Name.text!]
                    let data3 = ["성별" : self.Uni.text!]
                    self.ref?.child("User").child(user!.uid).child("UserProfile").setValue(data)
                    self.ref?.child("User").child(user!.uid).child("UserProfile").updateChildValues(data1)
                    self.ref?.child("User").child(user!.uid).child("UserProfile").updateChildValues(data2)
                    self.ref?.child("User").child(user!.uid).child("UserProfile").updateChildValues(data3)
                    self.SuccessSignup(title: "환영합니다.", message: "\(self.Name.text!)")
                }
                else {
                    if let myError = error?.localizedDescription {
                        print(myError)
                    } else {
                        print("error")
                    }
                }
            })
        }
        else { // 공백이 존재할 떄
           displayErrorMessage(title: "공백이 존재합니다.", message: "데이터를 입력해주세요.")
        }
    }
    func displayErrorMessage(title : String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "확인", style: .default) {
            (action : UIAlertAction) -> Void in
        }
        alert.addAction(confirm)
        present(alert, animated: true, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == picker {
            return pickoption2.count
        }
        else {
            return pickoption1.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == picker {
            return pickoption2[row]
        }else {
           return pickoption1[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == picker {
           Age.text = pickoption2[row]
        }
        else {
            Uni.text = pickoption1[row]
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
