//
//  FlickrClient.swift
//  Virtual Tourist
//
//  Created by iOS Developer on 27/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    static let shared = FlickrClient()
    
    func getFlickrImages(bbox: String){
        
        let url = getFlickrSearchMethodUrl(true, bbox)
        let task = URLSession.shared
        
//        task.dataTask(with: url) { (data, response, error) in
//
//            if let error = error(){
//                print(error)
//            }
//
//            do{
//                guard let json = JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) else{return}
//            }catch let error{
//                print(error)
//            }
//        }
    }
    
    func getFlickrSearchMethodUrl(_ extras: Bool = false, _ bbox: String) -> URL{
        var urlComponent = URLComponents()
        var queryItems = [URLQueryItem]()
        urlComponent.scheme = Flickr.APIScheme
        urlComponent.host = Flickr.APIHost
        urlComponent.path = Flickr.APIPath
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.Method, value: FlickrParameterValues.SearchMethod))
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.APIKey, value: FlickrParameterValues.APIKey))
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.Format, value: FlickrParameterValues.Format))
        queryItems.append(URLQueryItem(name: FlickrParameterKeys.BoundingBox, value: bbox))
                
        if(extras){
            queryItems.append(URLQueryItem(name: FlickrParameterKeys.Extras, value: FlickrParameterValues.MediumURL))
        }
        
        urlComponent.queryItems = queryItems
        
        return urlComponent.url!
    }
}
