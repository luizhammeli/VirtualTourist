//
//  CoreDataManager.swift
//  Virtual Tourist
//
//  Created by iOS Developer on 01/03/2018.
//  Copyright © 2018 iOS Developer. All rights reserved.
//

import CoreData

struct CoreDataManager {
    static let share = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Failed to load the database: \(err)")
            }
        }
        return container
    }()
    
    func createPin(_ latitude: Double, _ longitude: Double)->(Pin?, String?){
        let context = CoreDataManager.share.persistentContainer.viewContext
        let pin = NSEntityDescription.insertNewObject(forEntityName: Entity.Pin, into: context) as! Pin
        pin.latitude = latitude
        pin.longitude = longitude
        
        do{
            try context.save()
            return (pin, nil)
        }catch let error{
            print(error)
        }
        return (nil, "Error to create Pin")
    }
    
    func fetchPins()->[Pin]{
        let context = CoreDataManager.share.persistentContainer.viewContext
         let fetchRequest = NSFetchRequest<Pin>(entityName: Entity.Pin)
        do{
            let pins = try context.fetch(fetchRequest)
            return pins
        }catch let error{
            print(error)
        }
        return [Pin]()
    }
    
    func removePin(_ pin: Pin)->Bool{
        let context = CoreDataManager.share.persistentContainer.viewContext
        context.delete(pin)
        do{
            try context.save()
            return true
        }catch let error{
            print(error)
        }
        return false
    }
    
    func insertPhotos(_ photosDic: [[String:Any]], _ pin: Pin){
        let context = CoreDataManager.share.persistentContainer.viewContext

        for dic in photosDic{
            let photo = NSEntityDescription.insertNewObject(forEntityName: Entity.Photo, into: context) as! Photo
            photo.flickrID = dic[FlickrParameterValues.ID] as? String
            photo.url = dic[FlickrParameterValues.MediumURL] as? String
            photo.pin = pin
            context.insert(photo)
        }
        
        do{
            try context.save()
        }catch let error{
            print(error)
        }
    }
    
    func fetchPhotos()->[Photo]{
        let context = CoreDataManager.share.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Photo>(entityName: Entity.Photo)
        do{
            let photos = try context.fetch(fetchRequest)
            return photos
        }catch let error{
            print(error)
        }
        return [Photo]()
    }
    
    func updatePhotos(_ photo: Photo){
        let context = CoreDataManager.share.persistentContainer.viewContext
        do{
            try context.save()
        }catch let error{
            print(error)
        }
    }
}
