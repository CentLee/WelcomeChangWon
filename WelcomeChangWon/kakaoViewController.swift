//
//  kakaoViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 11. 24..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import SnapKit

class kakaoViewController: UIViewController {
    var kakao = UIButton()
    var cancel = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(kakao)
        self.view .addSubview(cancel)
        
        kakao.snp.makeConstraints { (make) in
            make.width.equalTo(self.view.frame.width/3)
            make.height.equalTo(self.view.frame.height/20)
            make.center.equalTo(self.view)
        }
        cancel.snp.makeConstraints { (make) in
            make.size.equalTo(kakao)
            make.top.equalTo(kakao.snp.bottom).offset(10)
            make.centerX.equalTo(self.view)
        }
        kakao.setImage(UIImage(named : "KaKao.jpg"), for: .normal)
        kakao.addTarget(self, action: #selector(openKakao), for: .touchUpInside)
        cancel.setImage(UIImage(named : "Return.jpg"), for: .normal)
        cancel.addTarget(self, action: #selector(Cancel), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    @objc func Cancel(sender : UIButton) {
        performSegue(withIdentifier: "Cancel", sender: self)
    }
    @objc func openKakao(sender : UIButton) {
        let session  = KOSession.shared()
        if let token = session {
            if token.isOpen() {
                token.close()
            }
            token.open(completionHandler: { (error) in
                if error == nil {
                    if token.isOpen() {
                       self.performSegue(withIdentifier: "kakao", sender: self)
                    }
                    else {
                        print("실패")
                    }
                }
                else {
                    print(error!)
                }
            })
        }
        else {
            print("Nothing")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
