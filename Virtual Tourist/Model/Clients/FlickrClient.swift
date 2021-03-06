//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by iOS Developer on 27/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation
import UIKit

class FlickrClient: NSObject {
    
    static let shared = FlickrClient()
    
    func taskForGETTMethod(_ url: URL, completionHandler: @escaping (_ data: Data?, _ error: Error?) -> Void){
        
        let task = URLSession.shared
        
        task.dataTask(with: url) { (data, response, error) in
            if let error = error{
                print(error)
            }
            
            guard let response = response as? HTTPURLResponse else {return}
            
            if(response.statusCode == 200){
                completionHandler(data, nil)
            }
            
        }.resume()
    }
    
    func getFlickrSearchMethodUrl(_ extras: Bool? = false, _ bbox: String, _ page:String?) -> URL{
        var urlComponent = URLComponents()
        var queryItems = [URLQueryItem]()
        urlComponent.scheme = Flickr.APIScheme
        urlComponent.host = Flickr.APIHost
        urlComponent.path = Flickr.APIPath
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.Method, value: FlickrParameterValues.SearchMethod))
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.APIKey, value: FlickrParameterValues.APIKey))
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.Format, value: FlickrParameterValues.ResponseFormat))
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.BoundingBox, value: bbox))
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.NoJSONCallback, value: FlickrParameterValues.DisableJSONCallback))
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.PerPage, value: "21"))
        if let page = page{
            queryItems.append(URLQueryItem(name: FlickrParameterKeys.Page, value: page))
        }
        
        
        if(extras!){
            queryItems.append(URLQueryItem(name: FlickrParameterKeys.Extras, value: FlickrParameterValues.MediumURL))
        }
        
        urlComponent.queryItems = queryItems
        
        return urlComponent.url!
    }
    
    func getFlickrImages(_ bbox: String, _ page:String?=nil, completionHandler: @escaping (_ totalPages: Int?, _ photos: [[String: Any]]?, _ error: NSError?)->Void){
        let url = getFlickrSearchMethodUrl(true, bbox, page)
        taskForGETTMethod(url) { (data, error) in
            do{
                if let error = error{
                    completionHandler(nil, nil, error as NSError)
                }
                
                guard let data = data else{return}
                
                guard let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] , let photosDic = json["photos"] as? [String: Any], let totalPages = photosDic["total"] as? String, let photosArray = photosDic["photo"] as? [[String: Any]] else {return}
                
                guard let total = Int(totalPages) else {return}                                
                completionHandler(total, photosArray, nil)
                
            }catch let error{
                print(error)
            }
        }
    }
    
    func downloadImages(_ photosDic: [[String:Any]])->[UIImage]{
        
        var photos = [UIImage]()
        for dic in photosDic{
            guard let stringURL = dic[FlickrParameterValues.MediumURL] as? String else {return photos}
            guard let url = URL(string: stringURL) else {return photos}
            guard let imageData = try? Data(contentsOf: url) else {return photos}
            guard let image = UIImage(data: imageData) else {return photos}
            photos.append(image)
        }
        return photos
        
    }
}
