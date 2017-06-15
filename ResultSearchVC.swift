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
    var searchWordUpdated = ""
    var searchUrl: String?
    var names = [String]()
    var imagesTest = [String]()
    
    typealias JSONFormat = [String: AnyObject]
    @IBOutlet weak var segmentedBar: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.edgesForExtendedLayout = []
        self.tableView.register(UINib(nibName: "ResultSearchCell", bundle: nil), forCellReuseIdentifier: "resultcell")
        searchWordUpdated = searchWord.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        searchUrl = "https://api.spotify.com/v1/search?q=" + searchWordUpdated + "&type=" + searchType
        requestResult(url: searchUrl!, type: searchType)
    }

    func requestResult(url: String, type: String?) {
        let token: String?
        if let session = UserInfoSaver().isAuthenticatedSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!]
            print(headers)
            
            if type == "track" {
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
            else if type == "album" {
                Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                    (response: DataResponse<ItemTypeAlbum>) in
                    
                    let itemType = response.result.value
                    let albums = itemType?.albums
                    for item in (albums?.items)! {
                        self.names.append(item.name!)
                        if item.images?[2].url != nil {
                            self.imagesTest.append((item.images?[2].url)!)
                        }
                    }
                    self.tableView.reloadData()
                })
            }
            
            else if type == "artist"{
                Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                    (response: DataResponse<ItemTypeArtist>) in
                    
                    let itemType = response.result.value
                    let artists = itemType?.artists
                    for item in (artists?.items)! {
                        self.names.append(item.name!)
                    }
                    self.tableView.reloadData()
                })
            }
            

        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultcell", for: indexPath) as! ResultSearchCell
        if searchType == "artist" {
            cell.bindData(title: names[indexPath.row])
        } else {
            cell.bindData(title: names[indexPath.row], imageURL: imagesTest[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    @IBAction func segmentedBarClicked(_ sender: Any) {
        names = []
        imagesTest = []
        switch segmentedBar.selectedSegmentIndex {
            case 0:
                searchType = "track"
                searchUrl = "https://api.spotify.com/v1/search?q=" + searchWordUpdated + "&type=" + searchType
                requestResult(url: searchUrl!, type: searchType)
                self.tableView.reloadData()
                break;
            case 1:
                searchType = "album"
                searchUrl = "https://api.spotify.com/v1/search?q=" + searchWordUpdated + "&type=" + searchType
                requestResult(url: searchUrl!, type: searchType)
                self.tableView.reloadData()
                break;
            case 2:
                searchType = "artist"
                searchUrl = "https://api.spotify.com/v1/search?q=" + searchWordUpdated + "&type=" + searchType
                requestResult(url: searchUrl!, type: searchType)
                self.tableView.reloadData()
                break;
            default:
                break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

