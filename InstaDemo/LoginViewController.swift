//
//  LoginViewController.swift
//  InstaDemo
//
//  Created by Michelle Shu on 3/11/17.
//  Copyright © 2017 Michelle Shu. All rights reserved.
//

import UIKit
import Parse
class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!

    @IBOutlet weak var passwordField: UITextField!
    var currentUser: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if user != nil {
                print("you logged in hehe!")
                self.currentUser = user
                self.performSegue(withIdentifier: "homeSegue", sender:
                self.currentUser)
            }
        }
    }
    

    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if (success) {
                print("We gotta Usa!")
                self.performSegue(withIdentifier: "homeSegue", sender: self.currentUser)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
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
