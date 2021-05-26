//
//  ViewController.swift
//  TestProject
//
//  Created by Tran Phong on 4/15/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func openSDK(_ sender: Any) {
        if let sdk = AppDelegate.shared?.netaloSDK.buildConversationViewController() {
            self.present(sdk, animated: true, completion: nil)
        }
    }
    
}

