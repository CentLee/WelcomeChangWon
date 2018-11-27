//
//  LoginViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 11. 24..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import SnapKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    var EmailText = UITextField()
    var PasswordText = UITextField()
    var Login = UIButton()
    
    @IBOutlet var segment: UISegmentedControl!
    
    @IBAction func ActSeg(_ sender: UISegmentedControl) {
        if segment.selectedSegmentIndex == 1 { //회원가입 화면
            performSegue(withIdentifier: "SignUp", sender: self)
        }
        else if segment.selectedSegmentIndex == 2 {
            let Alert = UIAlertController(title: "비밀번호 재설정", message: nil, preferredStyle: .alert)
            let St1 = UIAlertAction(title: "비밀번호 재설정", style: .default) {
                (action : UIAlertAction) -> Void in
                let alert1 = UIAlertController(title: "비밀번호 재설정", message: nil, preferredStyle: .alert)
                alert1.addTextField(configurationHandler: { (textfield) in
                    textfield.attributedPlaceholder = NSAttributedString(string: "인증 메일을 전송할 이메일", attributes: [NSAttributedStringKey.foregroundColor : UIColor.red])
                })
                let confirm = UIAlertAction(title: "인증 이메일 전송", style: .default) {
                    (action : UIAlertAction) -> Void in
                    self.reset(email: (Alert.textFields?[0].text)!)
                }
                let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                alert1.addAction(confirm)
                alert1.addAction(cancel)
                self.present(alert1, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            Alert.addAction(St1)
            Alert.addAction(cancel)
            present(Alert, animated: true, completion: nil)
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
    override func viewDidLoad() {
        super.viewDidLoad()
        let su = self.view!
        su.addSubview(EmailText)
        su.addSubview(PasswordText)
        su.addSubview(Login)
        su.backgroundColor = UIColor.black
        segment.snp.makeConstraints { (make) in
            make.width.equalTo(UIScreen.main.bounds.width/1.3)
            make.height.equalTo(UIScreen.main.bounds.height/30)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(100)
        }
        let attr = NSDictionary(object: UIFont(name: "KoreanSNROR", size: 15)!, forKey: NSAttributedStringKey.font as NSCopying)
        segment.setTitleTextAttributes(attr as [NSObject : AnyObject], for: .normal)
    
        EmailText.snp.makeConstraints { (make) in
            make.width.equalTo(segment)
            make.height.equalTo(segment)
            make.left.equalTo(segment.snp.left)
            make.top.equalTo(segment.snp.bottom).offset(50)
        }
        PasswordText.snp.makeConstraints { (make) in
            make.size.equalTo(EmailText)
            make.left.equalTo(EmailText)
            make.top.equalTo(EmailText.snp.bottom).offset(30)
        }
        Login.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width/3)
            make.height.equalTo(self.view.frame.height/20)
            make.centerX.equalTo(su)
            make.top.equalTo(PasswordText.snp.bottom).offset(30)
        }
        Login.setImage(UIImage(named: "Login.jpg"), for: .normal)
        Login.addTarget(self, action: #selector(ActLogin), for: .touchUpInside)
        
        segment.tintColor = UIColor.white
        EmailText.backgroundColor = UIColor.white
        PasswordText.backgroundColor = UIColor.white
        EmailText.placeholder = "이메일"
        PasswordText.placeholder = "비밀번호"
        EmailText.borderStyle = .roundedRect
        PasswordText.borderStyle = .roundedRect
        EmailText.autocapitalizationType = .none
        PasswordText.autocapitalizationType = .none
        EmailText.autocorrectionType = .no
        PasswordText.autocorrectionType = .no
        PasswordText.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    func reset(email : String)  { // 이메일 찾기 > 재설정
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil { //성공적으로 이메일 전송
                self.displayErrorMessage(title: "입력된 이메일로 전송되었습니다.", message: "")
            } else {
                print(error!.localizedDescription)
            }
        }
    }
    
    @objc func ActLogin(sender : UIButton) {
        if EmailText.text! != "" && PasswordText.text! != "" { //공백이 아니면
            Auth.auth().signIn(withEmail: EmailText.text!, password: PasswordText.text!, completion: { (user, error) in
                if user != nil {
                    print("Success")
                    self.performSegue(withIdentifier: "Login", sender: self)
                }
                else {
                    if let myError = error?.localizedDescription {
                        print(myError)
                    }
                    else {
                        print("error")
                    }
                }
            })
            
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
