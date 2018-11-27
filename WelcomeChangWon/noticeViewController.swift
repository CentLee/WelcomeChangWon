//
//  noticeViewController.swift
//  WelcomeChangWon
//
//  Created by 박주영 on 2017. 11. 30..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit

class noticeViewController: UIViewController {
   
    @IBOutlet var noticlb: UILabel!
    @IBOutlet var backBtn: UIButton!
    
    @IBAction func Back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    var labelcontent : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    
    noticlb.text = labelcontent
    noticlb.font = UIFont(name: "KoreanSNROR", size: 25)
    noticlb.adjustsFontSizeToFitWidth = true
    noticlb.numberOfLines = 0
        // Do any additional setup after loading the view.
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
