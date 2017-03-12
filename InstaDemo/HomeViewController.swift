//
//  HomeViewController.swift
//  InstaDemo
//
//  Created by Michelle Shu on 3/12/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var postTable: UITableView!
    var user: PFUser?
    var posts: [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postTable.delegate = self
        postTable.dataSource = self
        // Do any additional setup after loading the view.
        self.user = PFUser.current()
        if (user?["postid"] != nil) {
            self.appendData()
        }
    }

    
    override func viewDidAppear(_ animated: Bool) {
        self.user = PFUser.current()
        if (user?["postid"] != nil) {
            self.appendData()
        }
    }
    
    func appendData(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let query = PFQuery(className: "PhotoPost")
        query.order(byDescending: "createdAt")
        query.includeKey("user")
        query.whereKey("user", equalTo: self.user!)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error != nil {
                print("error")
            } else {
                print("success")
                if let objects = objects {
                    self.posts = objects
                    OperationQueue.main.addOperation(){
                        //Perform action on main thread
                        self.postTable.reloadData()
                    }
                    MBProgressHUD.hide(for: self.view, animated: true)
                    //print(self.posts as Any)
                }
            }
        }


    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if posts == nil {
            return 0
        } else {
            return posts!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = postTable.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath) as! PostTableViewCell
        
        if let post = posts?[indexPath.row] {
            cell.captionLabel.text = post["text"] as! String?
            if let imageData = post["image"] {
                let imagePt = UIImage(data: (imageData as! NSData) as Data)
                cell.postImageView.image = imagePt
            }
        }
        
        return cell

        
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
