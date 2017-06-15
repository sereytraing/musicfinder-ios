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
    
    var searchWord = ""
    var searchType = "track"
    var searchUrl: String?
    var names = [String]()
    var imagesTest = [String]()
    
    typealias JSONFormat = [String: AnyObject]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ResultSearchCell", bundle: nil), forCellReuseIdentifier: "resultcell")
        let searchWordUpdated = searchWord.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        searchUrl = "https://api.spotify.com/v1/search?q=" + searchWordUpdated + "&type=" + searchType
        requestResult(url: searchUrl!)
    }

    func requestResult(url: String) {
        let token: String?
        if let session = UserInfoSaver().isAuthenticatedSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!]
            print(headers)
            
            //Track
            Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                (response: DataResponse<ItemTypeTrack>) in
             
                let itemType = response.result.value
                let tracks = itemType?.tracks
                for item in (tracks?.items)! {
                    self.names.append(item.name!)
                    self.imagesTest.append((item.album?.images?[2].url)!)
                }
                self.tableView.reloadData()
            })

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultcell", for: indexPath) as! ResultSearchCell
        cell.bindData(title: names[indexPath.row], imageURL: imagesTest[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

