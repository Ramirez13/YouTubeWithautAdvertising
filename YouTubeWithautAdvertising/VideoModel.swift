//
//  VideoModel.swift
//  YouTubeWithautAdvertising
//
//  Created by Konstantin Chukhas on 11/18/18.
//  Copyright © 2018 Konstantin Chukhas. All rights reserved.
//




import UIKit
import Alamofire

protocol videoModelDelegate {
    func dataReady()
}



class VideoModel: NSObject {
    var delegate:videoModelDelegate?
    var videoArray = [Video]()
    
    func getFeedVideos()  {
        
        let url = URL(string: "https://www.googleapis.com/youtube/v3/videos")!
        
        let APIKey = "AIzaSyBFu4tnszxRbfMBzedRVz72cb5MJyGUw9o"
        let params: Parameters = [
            "part":"snippet",
            "chart":"mostPopular",
            "regionCode":"UA",
            "maxResults":"30",
            "key":APIKey
            
        ]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default).responseJSON { (response) in
            if let data = response.data {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                        //  print(jsonResult["items"])
                        var arrayOfVideo = [Video]()
                        for video in (jsonResult["items"] as? NSArray)!{
                            //  print("video\(video)")
                            let videoObj = Video()
                            videoObj.videoTitle = (video as AnyObject).value(forKeyPath: "snippet.title") as! String
                            videoObj.videoId = (video as AnyObject).value(forKeyPath: "id") as! String
                            // print(videoObj.videoId)
                            
                            videoObj.videoThumbnail = (video as AnyObject).value(forKeyPath: "snippet.thumbnails.default.url") as! String
                            arrayOfVideo.append(videoObj)
                            
                            self.videoArray = arrayOfVideo
                            
                            
                            if self.delegate != nil{
                                self.delegate?.dataReady()
                            }
                            
                            
                        }
                    }
                    
                    
                } catch {
                    print(error)
                }
            }
            
        }
    }
    
    
    
}
