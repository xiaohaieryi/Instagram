//
//  YWFollowersCell.swift
//  Instagram
//
//  Created by 于武 on 2018/1/5.
//  Copyright © 2018年 于武. All rights reserved.
//

import UIKit

class YWFollowersCell: UITableViewCell {

    @IBOutlet weak var avaImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    var user: AVUser!
    
    
    //关注按钮点击方法
    @IBAction func followBtn_clicked(_ sender: UIButton) {
       
        let title = followBtn.title(for: .normal)
        if title == "关 注"{
            
            guard user != nil else { return }
            AVUser.current()?.follow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                
                if success {
                 self.followBtn.setTitle("✅已关注", for: .normal)
                 self.followBtn.backgroundColor = UIColor.green
                }else{
                    print(error!.localizedDescription)
                }
                
            })
        }else {
            
            guard user != nil else { return }
            AVUser.current()?.follow(user.objectId!, andCallback: { (success: Bool, error: Error?) in
                
                if success {
                    self.followBtn.setTitle("关 注", for: .normal)
                    self.followBtn.backgroundColor = UIColor.lightGray
                }else{
                    print(error!.localizedDescription)
                }
                
            })
            
        }
        
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // 将头像剪裁为圆形
        avaImg.layer.cornerRadius = avaImg.frame.size.width/2
        avaImg.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
