//
//  CommunityTableViewController.swift
//  WelcomeChangWon
//
//  Created by 박주영 on 2017. 11. 30..
//  Copyright © 2017년 apple. All rights reserved.
//

import UIKit
import MessageUI

class CommunityTableViewController: UITableViewController,MFMailComposeViewControllerDelegate {

   
    var tableitem : [[String:String]] = [["name":"공지사항","jpg":"1.jpg"],["name":"문의","jpg":"2.jpg"],["name":"코스공유","jpg":"3.jpg"]]
    
   override func viewDidLoad() {
        super.viewDidLoad()
//     self.tableView.isHidden = true
//     self.tableView.tableFooterView = UIView()
//
//    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
//    self.tableView.tableHeaderView = footerView
    //self.tableView.tableHeaderView.
      
    }

   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tableitem.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cmt", for: indexPath)
      
        let dic = tableitem[indexPath.row]
        print(dic)
        cell.textLabel?.text = dic["name"]
        cell.textLabel?.font = UIFont(name: "KoreanSNROR", size: 23)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.imageView?.image = UIImage(named: dic["jpg"]!)

        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let imageView = UIImageView()
        if (section == 0) {
            let image = UIImage(named: "4.jpg")
            imageView.image = image
        }
      else {
            imageView.image = UIImage(named: "4.jpg")
            return imageView
    }
        
        return imageView
}
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) ->
        CGFloat {
        return self.tableView.frame.height/6
    }
    func configureMailController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["shety4611@gmail.com"])
        mailComposerVC.setSubject("Hello")
        mailComposerVC.setMessageBody("How are you", isHTML: false)
        
        return mailComposerVC
    }
    
    func showMailError(){
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send email", preferredStyle: .alert)
        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
        sendMailErrorAlert.addAction(dismiss)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = tableitem[indexPath.row]
        if dic["name"] == "문의" {
            let mailComposeViewController = configureMailController()
            if MFMailComposeViewController.canSendMail()
            {
                self.present(mailComposeViewController, animated: true, completion: nil)
            }else {
                showMailError()
            }
            }
        if dic["name"] == "공지사항" {
            self.performSegue(withIdentifier: "segue1", sender: self )
        }
        if dic["name"] == "코스공유" {
            self.performSegue(withIdentifier: "ComCourse", sender: self)
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
