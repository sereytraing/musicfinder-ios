//
//  ResultSearchVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ResultSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchurl = "https://api.spotify.com/v1/search?q=Bigbang&type=track&limit=2"
    var names = [String]()
    
    typealias JSONFormat = [String: AnyObject]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        requestResult(url: searchurl)
       
    }

    func requestResult(url: String) {
        let token: String?
        if let session = UserInfoSaver().isAuthenticatedSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!]
            print(headers)
            
            Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                (response: DataResponse<ItemTypeTrack>) in
             
                let itemType = response.result.value
                let tracks = itemType?.tracks
                for item in (tracks?.items)! {
                    self.names.append(item.name!)
                }
                self.tableView.reloadData()
            })

        }
    }
    
    /*func requestResult(url: String) {
        let token: String?
        if let session = UserInfoSaver().isAuthenticatedSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!]
            print(headers)
            Alamofire.request(url, headers: headers).responseJSON(completionHandler: { (response) in
                self.parseData(JSONData: response.data!)
            })
        }
    }*/
    
    /*func parseData(JSONData: Data) {
        do {
            var readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONFormat
            if let tracks = readableJSON["tracks"] as? JSONFormat {
                if let items = tracks["items"] as? [JSONFormat] {
                    for i in 0..<items.count {
                        let item = items[i]
                        names.append(item["name"] as! String)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        catch {
            print(error)
        }
        
    }*/
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

