//
//  ViewController.swift
//  LinkedInSwift
//
//  Created by Lieberman, Joshua on 3/18/16.
//  Copyright © 2016 4everwild. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var userData: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doLogin(_ sender: AnyObject) {
        LISDKSessionManager.clearSession()
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: { (returnState) -> Void in
            print("success called!")
            print(LISDKSessionManager.sharedInstance().session)
            
            let url = "https://api.linkedin.com/v1/people/~"
            
            if LISDKSessionManager.hasValidSession() {
                LISDKAPIHelper.sharedInstance().getRequest(url, success: { (response) -> Void in
                    print(response?.data)
                    self.userData = (response?.data)!
                    DispatchQueue.main.async(execute: {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Namecard") as! ViewController2
                        vc.userData = self.userData
                        self.present(vc,animated: true,completion: nil)
                        })
                    }, error: { (error) -> Void in
                        print(error)
                })
            }
            
            
            }) { (error) -> Void in
                print("Error: \(error)")
        }
    }
}

