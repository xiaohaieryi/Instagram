//
//  YWFllowersVC.swift
//  Instagram
//
//  Created by 于武 on 2018/1/5.
//  Copyright © 2018年 于武. All rights reserved.
//

import UIKit

class YWFllowersVC: UITableViewController {
    var show = String()
    var user = String()
    
    var followerArray = [AVUser]()
    
 override func viewDidLoad() {
        super.viewDidLoad()
    
       self.navigationItem.title = show
    if  show == "关注者" {
        loadFollowers()
    }else{
        loadFollowings()
    }
    
    
    

}
  
    
    /// 加载关注者数据
    func loadFollowers()  {
        AVUser.current()?.getFollowers({ (followers: [Any]?, error:Error?) in
            
            if error == nil && followers != nil {
                self.followerArray = followers! as! [AVUser]
                self.tableView.reloadData()
            }else {
                
                print(error?.localizedDescription ?? "..")
            }
      
        })
    }
    /// 加载关注数据
    func loadFollowings()  {
        AVUser.current()?.getFollowees({ (followings: [Any]?, error:Error?) in
            
            if error == nil && followings != nil {
                self.followerArray = followings! as! [AVUser]
                self.tableView.reloadData()
            }else {
                
                print(error?.localizedDescription ?? "..")
            }
            
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return followerArray.count
    }

    //配置表格的cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! YWFollowersCell
        cell.usernameLbl.text = followerArray[indexPath.row].username
        let ava = followerArray[indexPath.row].object(forKey: "ava") as! AVFile
        ava.getDataInBackground { (data:Data?, error:Error?) in
            if error == nil {
                cell.avaImg.image = UIImage.init(data: data!)
            }else{
                print("没有读取到关注者头像数据")
            }
            
        }
        //利用按钮外观区分当前用户状态
        let query = followerArray[indexPath.row].followeeQuery()
        query.whereKey("user", equalTo: AVUser.current() as Any)
        query.whereKey("followee", equalTo: followerArray[indexPath.row])
        query.countObjectsInBackground { (count: Int, error: Error?) in
            //根据数量设置按钮风格
            
            if error == nil {
                
                if count == 0 {
                    cell.followBtn.setTitle("关 注", for: .normal)
                    cell.followBtn.backgroundColor = UIColor.lightGray
                }else{
                    cell.followBtn.setTitle("✅ 已关注", for: .normal)
                    cell.followBtn.backgroundColor = UIColor.green
                    
                }
                cell.user = self.followerArray[indexPath.row]
                //为当前用户隐藏关注按钮
                if cell.usernameLbl.text == AVUser.current()?.username
                
                {
                    cell.followBtn.isHidden = true
                }
            
            }
            
        }
        return cell
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
