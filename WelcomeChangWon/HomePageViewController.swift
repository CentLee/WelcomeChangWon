//
//  HomePageViewController.swift
//  WelcomeChangWon
//
//  Created by apple on 2017. 11. 21..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import SnapKit

class HomePageViewController: UIViewController {
    var web = UIWebView()
    var address : String = ""
    @IBOutlet var navi: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(web)
        web.snp.makeConstraints { (make) in
            make.size.equalTo(self.view)
            make.top.equalTo(navi.snp.bottom)
        }
        let weburl = URL(string: address)
        let request = URLRequest(url: weburl!)
        web.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    @IBAction func Back(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
