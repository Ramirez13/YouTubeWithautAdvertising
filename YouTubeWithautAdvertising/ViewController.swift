//
//  ViewController.swift
//  YouTubeWithautAdvertising
//
//  Created by Konstantin Chukhas on 11/18/18.
//  Copyright © 2018 Konstantin Chukhas. All rights reserved.
//

import UIKit
import Alamofire
import YouTubePlayer



class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,videoModelDelegate,UISearchBarDelegate,UIScrollViewDelegate {
   
    
    
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    var searchBar = UISearchBar()
    var searchBarButtonItem: UIBarButtonItem?
    var videos:[Video] = [Video]()
    var selectedVideo :Video?
    let model:VideoModel = VideoModel()
    var searchControllerIsActive = false
var text = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.model.delegate = self
        self.model.getFeedVideos()
        searchBarMethod()
        addRightBarButton()
        createImageTitleView()
        topLeftItemButton()
        
    }
    fileprivate func addRightBarButton() {
        //add barButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                                 target: self,
                                                                 action: #selector(search(param: )))
       
    }
    fileprivate func topLeftItemButton() {
        
        //create a new button
        let button = UIButton(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "cup.png"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(topVideo(param: )), for: .touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 53, height: 51)
        button.contentMode = .scaleAspectFit
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
    }
   
 
    fileprivate func createImageTitleView() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        //чтобы не расстягивалась фотография
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "yt")
        imageView.image = image
        self.navigationItem.titleView = imageView
    }
    fileprivate func searchBarMethod() {
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBarButtonItem = navigationItem.rightBarButtonItem
        searchBar.tintColor = UIColor.brown
    }
    @objc func search(param:UIBarButtonItem){
        if param.isEnabled {
            showSearchBar()

        }
    }
    @objc func topVideo(param:UIBarButtonItem){
          self.model.getFeedVideos()
        hideSearchBar()
    }
    
    func showSearchBar() {
        searchBar.alpha = 0
        navigationItem.titleView = searchBar
        navigationItem.setRightBarButton(nil, animated: true)
        UIView.animate(withDuration: 0.5, animations: {
            self.searchBar.alpha = 1
        }, completion: { finished in
            self.searchBar.becomeFirstResponder()
        })
        
        
    }
    func hideSearchBar(){
        UIView.animate(withDuration: 1.0, animations: {
            self.searchBar.alpha = 0.0
        }, completion: {
            (value: Bool) in
            //do nothing after animation
            
        })
    }
    
    
    //MARK:Search Video Model Delegate Method
    
    
    //MARK: Video Model Delegate Method
    func dataReady() {
        //Access the video object
        self.videos = self.model.videoArray
        self.tableViewOutlet.reloadData()
    }
    //MARK: TableView Delegate Method
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchControllerIsActive{
           return  videoArray.count
        }else{
           return  videos.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if searchControllerIsActive{
            
            let cell1 = tableViewOutlet.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell
            cell1?.titleLabel?.text = videos[indexPath.row].videoTitle
             DispatchQueue.main.async {
            let URLString = self.videos[indexPath.row].videoId
            // print(URLString)
            cell1?.webViewYouTube.loadVideoID(URLString)
            }
            return cell1!
            

        }else{
            let cell = tableViewOutlet.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MainTableViewCell
            cell?.titleLabel?.text = videos[indexPath.row].videoTitle
            DispatchQueue.main.async {
                let URLString = self.videos[indexPath.row].videoId
                cell?.webViewYouTube.loadVideoID(URLString)
            }
            

            return cell!
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (self.view.frame.width / 480 ) * 360
    }
    //ScrollView Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        tableViewOutlet.keyboardDismissMode = .onDrag
        addRightBarButton()
        hideSearchBar()
        //createImageTitleView()
    }
    var videoArray = [Video]()
    func scrollToFirstRoww() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tableViewOutlet.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
        text = searchText
        
    }
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(row: 0, section: 0)
        self.tableViewOutlet.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
       
     //   print(text )
        
        let url = URL(string: "https://www.googleapis.com/youtube/v3/search")!
        
        let APIKey = "AIzaSyBFu4tnszxRbfMBzedRVz72cb5MJyGUw9o"
        let params: Parameters = [
            "part":"snippet",
            "maxResults":"25",
            "q":self.text,
            "type":"video",
            
            "key":APIKey
            
        ]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
            if let data = response.data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        //  print(jsonResult)
                        
                        var arrayOfVideo = [Video]()
                        for video in (jsonResult["items"] as? NSArray)!{
                            //   print("video\(video)")
                            
                            let videoObj = Video()
                            videoObj.videoTitle = (video as AnyObject).value(forKeyPath: "snippet.title") as! String
                            videoObj.videoId = (video as AnyObject).value(forKeyPath: "id.videoId") as! String
                            
                            
                           // print(videoObj.videoId)
                            
                            videoObj.videoThumbnail = (video as AnyObject).value(forKeyPath: "snippet.thumbnails.default.url") as! String
                            arrayOfVideo.append(videoObj)
                            
                            self.videos = arrayOfVideo
                            self.tableViewOutlet.reloadData()
                        }
                    }
                    
                    
                } catch {
                    print(error)
                }
            }
            
            
        }
        
        self.searchBar.endEditing(true)
        scrollToFirstRow()
        
    }
    
}
