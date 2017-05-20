//
//  AuthSpotifyVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 17/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit

class AuthSpotifyVC: UIViewController {
    
    let kClient = "fdad9d96ab20485e954addb639fd222a"
    let kCallbackURL = "musicfinder-auth://callback"
    //let kTokenSwapURL = "http://Localhost:1234/sw"
    //let kTokenRefreshServiceURL = ""

    @IBOutlet weak var loginSpotifyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginWithSpotify(_ sender: Any) {
        
    }
}
