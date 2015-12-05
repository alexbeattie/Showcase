//
//  ViewController.swift
//  showcase-dev
//
//  Created by Alex Beattie on 11/6/15.
//  Copyright © 2015 Alex Beattie. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func fbBtnPressed(sender:UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            if facebookError != nil {
                print("Facebook Login Failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully Logged in With Facebook. \(accessToken)")
                
                DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                    
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        print("logged in \(authData)")
                        
                        let user = ["provider": authData.provider!, "blah":"test"]
                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                        
                        NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                    
                })
            }
        }
    }

    @IBAction func attemptLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text
            where pwd != "" {
                
                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                    if error != nil {
                        
                        print(error)
                        
                        if error.code == STATUS_ACCOUNT_NONEXISTS {
                            DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { (error, result) -> Void in
                                
                                if error != nil {
                                    self.showErrorAlert("Could not create account", msg: "Problem creating account, try again please")
                                } else {
                                    NSUserDefaults.standardUserDefaults().setValue([KEY_UID], forKey: KEY_UID)
                                    
                                
                                    DataService.ds.REF_USERS.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                                        let user = ["provider": authData.provider!, "blah":"emailtest"]
                                        DataService.ds.createFirebaseUser(authData.uid, user: user)
                                    })
                                    
                                    
                                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                                }
                            })
                        } else {
                            self.showErrorAlert("Could not login", msg: "Please check username or password")
                        }
                    } else {
                        self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                    }
                })
                
        } else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")
        }
    }
   
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}
