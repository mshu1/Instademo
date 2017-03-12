//
//  uploadImageViewController.swift
//  InstaDemo
//
//  Created by Michelle Shu on 3/11/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit
import Parse

class UploadImageViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var successLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var captionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.successLabel.isHidden = true
        self.captionField.text = ""
    }
    @IBAction func onTapImage(_ sender: Any) {
        print("reconize?")
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
        
    {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.userImageView.image = image
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onPostBt(_ sender: Any) {
        let photoPost = PFObject(className: "PhotoPost")
        photoPost["text"] = self.captionField.text!
        let imageData = self.userImageView.image?.lowestQualityJPEGNSData
        photoPost["image"] = imageData
        if let user = PFUser.current() {
            photoPost["user"] = user
        }
        photoPost.saveInBackground { (success: Bool, error: Error?) in
            if (success) {
                self.addPosttoUser(photoPost)
                self.successLabel.isHidden = false

            }
        }
    }
    
    func addPosttoUser(_ post: PFObject) {
        let user = PFUser.current()
        if user?["postid"] != nil {
            var postList = user?["postid"] as! [String]
            postList.append(post.objectId!)
            user?["postid"] = postList
        user?.saveInBackground(block: { (success: Bool, error:Error?) in
            if (success) {
                print("success save user")
            }
        })
        } else {
            var postList = [String]()
            postList.append(post.objectId!)
            user?["postid"] = postList
            user?.saveInBackground(block: { (success: Bool, error:Error?) in
                if (success) {
                    print("success save user")
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

extension UIImage
{
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)! as NSData }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! as NSData}
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)! as NSData }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! as NSData}
    var lowestQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.0)! as NSData }
}
