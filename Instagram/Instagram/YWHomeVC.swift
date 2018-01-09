//
//  YWHomeVC.swift
//  Instagram
//
//  Created by 于武 on 2018/1/4.
//  Copyright © 2018年 于武. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class YWHomeVC: UICollectionViewController {

    //刷新控件
    var refresherControl: UIRefreshControl!
    
    //每页载入帖子的数量
    var page: Int = 12
    //puuid数组
    var puuidArray = [String]()
    //picture数组
    var picArray = [AVFile]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //弹簧效果
        collectionView?.alwaysBounceVertical = true
        //设置导航栏标题
      self.navigationItem.title = AVUser.current()?.username?.uppercased()
        //设置刷新控件到集合视图之中
        refresherControl = UIRefreshControl()
        refresherControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
        collectionView?.addSubview(refresherControl)
        loadPostsData()
        
    }

    //刷新控件方法
    @objc func refreshAction ()  {
        collectionView?.reloadData()
        //停止刷新动画
        refresherControl.endRefreshing()
    }

    //加载数据方法
    func loadPostsData ()  {
       
        let query = AVQuery.init(className: "Posts")
        query.whereKey("username", equalTo: AVUser.current()?.username ?? "无数据")
        query.limit = page
        query.findObjectsInBackground { (objects: [Any]?, error: Error?) in
            
            //查询成功
            if error == nil {
                //清空数组
                self.puuidArray.removeAll(keepingCapacity: false)
                self.picArray.removeAll(keepingCapacity: false)
                
                for object in objects! {
                    
               self.puuidArray.append((object as AnyObject).value(forKey: "puuid") as! String)
               self.picArray.append((object as AnyObject).value(forKey: "pic") as! AVFile)
                    
                }
                
                self.collectionView?.reloadData()
            }else {
                
                print(error?.localizedDescription ?? "无法找到具体原因")
                
            }
            
            
            
        }
        
        
        
    }
   
   
    // MARK: UICollectionViewDataSource。几个分区
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }

   // UICollectionViewDataSource。几个cell
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return  picArray.count == 0 ? 0 : 20
    }
    
    //返回cell的代理方法
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //从集合视图可复用队列中获取单元格对象
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! YWPictureCell
        //从数组中获取图片
        picArray[0].getDataInBackground { (data:Data?, error: Error?) in
            //如果有数据，则复制给对应的imageView
            if error == nil {
                cell.picImg.image = UIImage.init(data: data!)
                
          
                
             }else //没有数据则打印错误信息
              {
                print(error?.localizedDescription ?? "没找到具体原因")
              }
            
        }
        
        return cell
        
    
    }
    
    //自定义cell的HeaderView的代理方法
    override   func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //定义头部
    let header = self.collectionView?.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath) as! YWHeaderView
    header.fullNameLabl.text = (AVUser.current()?.object(forKey: "username") as? String)?.uppercased()
    header.webTxt.text = AVUser.current()?.object(forKey: "web") as? String
    header.webTxt.isEnabled = false
    header.webTxt.sizeToFit()
    header.bioLbl.text = AVUser.current()?.object(forKey: "bio") as? String
    header.bioLbl.sizeToFit()
    //取头像数据
    let avaQuery = AVUser.current()?.object(forKey: "ava") as! AVFile
    
     avaQuery.getDataInBackground { (data:Data?, error: Error?) in
        if data == nil {
           
            print(error?.localizedDescription ?? "pp")
        }else {
        
            header.avaImg.image = UIImage.init(data: data!)
        
              }
                                   }
    //取帖子等数据
        let currentUser: AVUser = AVUser.current()!
        
        //帖子数
        let postQuery = AVQuery.init(className: "Posts")
        
        postQuery.whereKey("username", equalTo: currentUser.username ?? "不知道是什么东东")
        postQuery.countObjectsInBackground { (count: Int, error:Error?) in
            
            if error == nil {
                
                header.posts.text = String(count)
            }
            
        }
        //关注者
        let followerQuery = AVQuery.init(className: "_Follower")
        
        followerQuery.whereKey("user", equalTo: currentUser)
        followerQuery.countObjectsInBackground { (count: Int, error:Error?) in
            
            if error == nil {
                
                header.followers.text = String(count)
            }
            
        }
        
        //关注
        let followeeQuery = AVQuery.init(className: "_Followee")
        
        followeeQuery.whereKey("user", equalTo: currentUser)
        followeeQuery.countObjectsInBackground { (count: Int, error:Error?) in
            
            if error == nil {
                
                header.followings.text = String(count)
            }
            
        }
        
        // 为lable添加手势
        let postsTap = UITapGestureRecognizer.init(target: self, action: #selector(postsTap(_ :)))
        postsTap.numberOfTapsRequired = 1
        header.posts.isUserInteractionEnabled = true
        header.posts.addGestureRecognizer(postsTap)
        
        let followersTap = UITapGestureRecognizer.init(target: self, action: #selector(followersTap (_ :)))
        followersTap.numberOfTapsRequired = 1
        header.followers.isUserInteractionEnabled = true
        header.followers.addGestureRecognizer(followersTap)
        
        let followingsTap = UITapGestureRecognizer.init(target: self, action: #selector(followingsTap (_ :)))
        followingsTap.numberOfTapsRequired = 1
        header.followings.isUserInteractionEnabled = true
        header.followings.addGestureRecognizer(followingsTap)
        
      return header
    
   }
   
    //点击帖子后调用的方法
    @objc  func postsTap(_ recognizer: UITapGestureRecognizer)  {
       
        if !picArray.isEmpty {
            let index = IndexPath.init(item: 0, section: 0)
            self.collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.top, animated: true)
            
        }
    }
    //点击关注者后调用的方法
    @objc  func followersTap(_ recognizer: UITapGestureRecognizer)  {
        //从故事板载入followersvc的视图
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! YWFllowersVC
        followers.user = (AVUser.current()?.username)!
        followers.show = "关注者"
        self.navigationController?.pushViewController(followers, animated: true)
        
        
    }
    //点击关注后调用的方法
    @objc func followingsTap(_ recognizer: UITapGestureRecognizer)  {
        
        //从故事板载入followersvc的视图
        let followings = self.storyboard?.instantiateViewController(withIdentifier: "FollowersVC") as! YWFllowersVC
        followings.user = (AVUser.current()?.username)!
        followings.show = "关注"
        self.navigationController?.pushViewController(followings, animated: true)
        
    }

}



