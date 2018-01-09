//
//  YWGuestVC.swift
//  Instagram
//
//  Created by 于武 on 2018/1/7.
//  Copyright © 2018年 于武. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
var guestArray = [AVUser]()


class YWGuestVC: UICollectionViewController {

    //从云端获取数据并存储到数组
    var puuidArray = [String]()
    var picArray = [AVFile]()
    
    //界面对象
    var refresher: UIRefreshControl!
    let page: Int = 12
    
     override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
       
        //允许垂直的拉拽刷新操作
        self.collectionView?.alwaysBounceVertical = true
        
        //导航栏顶部信息
        self.navigationItem.title = guestArray.last?.username
        //定义导航栏中新的返回按钮
        self.navigationItem.hidesBackButton = true
        let bacBtn = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(back(_:)))
        self.navigationItem.leftBarButtonItem = bacBtn
      
        //实现向右划动返回
        let bacSwipe = UISwipeGestureRecognizer.init(target: self, action: #selector(back(_:)))
        bacSwipe.direction  = .right
        self.view.addGestureRecognizer(bacSwipe)
        
        //安装刷新控件
        refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView?.addSubview(refresher)
        //调用loadPosts方法
        loadPost()
        
    }
    /// 导航栏左侧返回按钮点击方法
    ///
    /// - Parameter _: 按钮本身
    @objc  func back(_: UIBarButtonItem)  {
        //退回之前的控制器
        self.navigationController?.popViewController(animated: true)
        
        //从guester移除最后一个 AVUser
        if !guestArray.isEmpty {
            guestArray.removeLast()
        }
    }
    
    /// 刷新方法
    @objc func refresh()  {
        self.collectionView?.reloadData()
        self.refresher.endRefreshing()
    }
  //载入发访客发布的帖子
    func loadPost()  {
        let query = AVQuery.init(className:"Posts")
        query.whereKey("username", equalTo: guestArray.last?.username ?? "")
        query.limit = page
        query.findObjectsInBackground { (objects:[Any]?, error:Error?) in
            //查询成功
            if error == nil {
                //清空两个数组
                self.puuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                

                for object in objects! {
                    //将查询到的数据添加到数组中
                    self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
                    self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
                }
                
                self.collectionView?.reloadData()
            }else {
                
                print(error?.localizedDescription ?? "")
            }
            
        }
        
    }
// MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {

        return 0
    }

  //每个分区的单元格个数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     return  picArray.count
    }
    //配置cell头视图
  override    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     //定义header
    let header =  self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! YWHeaderView
    //载入访客的基本数据信息
    let infoQuery =  AVQuery.init(className: "_User")
    infoQuery.whereKey("username", equalTo: guestArray.last?.username ?? "")
    infoQuery.findObjectsInBackground ({ (objects:[Any]?, error: Error?) in
        if error == nil {
            //判断是否有用户数据
            guard let objects = objects, objects.count > 0 else {
                return
            }
          
            //找到用户的相关信息
            for object in objects {
               
                header.fullNameLabl.text = ((object as AnyObject).object(forKey: "fullname") as? String)?.uppercased()
                header.bioLbl.text = ((object as AnyObject).object(forKey: "bio") as? String)?.uppercased()
                header.bioLbl.sizeToFit()
                header.webTxt.text = ((object as AnyObject).object(forKey: "web") as? String)?.uppercased()
                header.webTxt.sizeToFit()
                
                let avaFile = (object as AnyObject).object(forKey:"ava") as? AVFile
                avaFile?.getDataInBackground({(data:Data?,error:Error?) in
                    header.avaImg.image = UIImage.init(data: data!)
                })
                
            }
            
        }else {
            print(error?.localizedDescription ?? "")
        }
    })
             //设置当前用户和访客之间的关系状态
    let followeeQuery = AVUser.current()?.followeeQuery()
    followeeQuery?.whereKey("user", equalTo: AVUser.current() ?? "")
    followeeQuery?.whereKey("followee", equalTo: guestArray.last ?? "")
    followeeQuery?.countObjectsInBackground({ (count:Int, error:Error?) in
    guard error == nil else {print(error?.localizedDescription ?? ""); return}
        
        if count == 0 {
          header.editBtn.setTitle("关 注", for: .normal)
          header.editBtn.backgroundColor = UIColor.lightGray
        }else {
            header.editBtn.setTitle("✅已关注", for: .normal)
            header.editBtn.backgroundColor = UIColor.green
        }
    })
      //计算统计数据
    //访客帖子数
    let posts = AVQuery.init(className: "Posts")
    posts.whereKey("username", equalTo: guestArray.last?.username ?? "")
    posts.countObjectsInBackground { (count: Int, error:Error?) in
        if error == nil {
            header.posts.text = "\(count)"
        }else{
            print(error?.localizedDescription ?? 0)
        }
    }
    
    //访客的关注者数
    let followers = AVUser.followerQuery((guestArray.last?.objectId)!)
    followers.countObjectsInBackground { (count: Int, error:Error?) in
        if error == nil {
            header.followers.text = "\(count)"
        }else{
            print(error?.localizedDescription ?? 0)
        }
    }
    //访客的关注数
    let followings = AVUser.followeeQuery((guestArray.last?.objectId)!)
    followings.countObjectsInBackground { (count: Int, error:Error?) in
        if error == nil {
            header.followings.text = "\(count)"
        }else{
            print(error?.localizedDescription ?? 0)
        }
    }
    return header
}
  //配置Cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! YWPictureCell
   //从云端载入帖子照片
        picArray[indexPath.row].getDataInBackground{(data:Data?, error:Error?) in
            if error == nil {
             cell.picImg.image = UIImage.init(data: data!)
            }else {
                print(error?.localizedDescription ?? "")
            }
       }
        return cell
    }

}
