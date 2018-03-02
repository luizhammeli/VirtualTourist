//
// Strings.swift
//  Virtual Tourist
//
//  Created by iOS Developer on 27/02/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import Foundation

struct Strings {    
    static let RemoveSelectedPicturesButtonLabel = "Remove Selected Pictures"
    static let NewCollectionButtonLabel = "New Collection"
    static let ShowImageSelectorSegue = "showImageSelectorViewController"
}

struct Flickr {
    static let APIScheme = "https"
    static let APIHost = "api.flickr.com"
    static let APIPath = "/services/rest"
    
    static let SearchBBoxHalfWidth = 1.0
    static let SearchBBoxHalfHeight = 1.0
    static let SearchLatRange = (-90.0, 90.0)
    static let SearchLonRange = (-180.0, 180.0)
}

struct FlickrParameterKeys {
    static let Method = "method"
    static let APIKey = "api_key"
    static let GalleryID = "gallery_id"
    static let Extras = "extras"
    static let Format = "format"
    static let NoJSONCallback = "nojsoncallback"
    static let SafeSearch = "safe_search"
    static let Text = "text"
    static let BoundingBox = "bbox"
    static let Page = "page"
    static let PerPage = "per_page"
}

struct FlickrParameterValues {
    static let SearchMethod = "flickr.photos.search"
    static let APIKey = "b1b9ec77efa8005894263ccd60021409"
    static let ResponseFormat = "json"
    static let DisableJSONCallback = "1"
    static let MediumURL = "url_m"
    static let UseSafeSearch = "1"
    static let Format = "rest"
    static let ID = "id"
}

struct Entity{
    static let Pin = "Pin"
    static let Photo = "Photo"
}
