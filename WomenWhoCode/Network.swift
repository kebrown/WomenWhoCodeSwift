//
//  Network.swift
//  WomenWhoCode
//
//  Created by Maha Govindarajan on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//
import UIKit
import Parse

// DB name for CHAPTER
class Network: NSObject {
    
    var objectId: String?
    var imageUrl: String?
    var meetUpUrl : String?
    var meetupUrlName: String?
    var title: String?
    var PFLocation : PFGeoPoint?
    
    //Derived properties
    
    var location : CLLocationCoordinate2D?
    
       override init() {
  
        //Set it to SF by default
        objectId = "QIk7JihCvU"
        imageUrl = "https://www.filepicker.io/api/file/VmFxea2WQLadhXHZ9bXQ"
        meetUpUrl = "http://www.meetup.com/Women-Who-Code-SF"
        title = "San Francisco"
        PFLocation = PFGeoPoint()
    }
    
    init(dictionary: NSDictionary) {
        objectId = dictionary["objectId"] as? String
        imageUrl = dictionary["imageUrl"] as? String
        meetUpUrl = dictionary["meetUpUrl"] as? String
        title = dictionary["title"] as? String
        PFLocation = dictionary["PFLocation"] as? PFGeoPoint
    }
    
    init(object: PFObject) {
        
        title = object["title"] as? String
        objectId = object["objectId"] as? String
        imageUrl = object["image_url"] as? String
        meetUpUrl = object["meetup_url"] as? String
        PFLocation = object["PFLocation"] as? PFGeoPoint
        meetupUrlName = object["meetup_url_name"] as? String
        
    }
    
    init(name: String) {
        super.init()
        
        ParseAPI.sharedInstance.getNetworkWithNetworkName(name, completion: { (network, error) -> () in
            if(error != nil ) {
                print("Error retreiving Network")
            } else {
                self.objectId = network?.objectId
                self.imageUrl = network?.imageUrl
                self.meetUpUrl = network?.meetUpUrl
                self.meetupUrlName = network?.meetupUrlName
                self.title = network?.title
                self.PFLocation = network?.PFLocation
                
            }
        })
        
    }
    
    func convertGeoPointToLocation () -> CLLocationCoordinate2D {
        
        location = CLLocationCoordinate2D()
        
        /*
        TO CONVERT GEOPOINT TO CLLocationCoordinate2D :
        
        var descLocation: PFGeoPoint = PFGeoPoint()
        
        var innerP1 = NSPredicate(format: "ObjectID = %@", objectID)
        var innerQ1:PFQuery = PFQuery(className: "Test", predicate: innerP1)
        
        var query = PFQuery.orQueryWithSubqueries([innerQ1])
        query.addAscendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock {
        (objects: [AnyObject]!, error: NSError!) -> Void in
        
        if error == nil {
        for object in objects {
        descLocation = object["GeoPoint"] as PFGeoPoint
        }
        } else {
        println("Error")
        }
        
        }
        
        
        And in your class where you need the location, just add these line:
        
        var latitude: CLLocationDegrees = descLocation.latitude
        var longtitude: CLLocationDegrees = descLocation.longitude
        
        var location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
        
        
        So you can add annotation to your map using this code:
        
        @IBOutlet var map: MKMapView!
        var annotation = MKPointAnnotation()
        annotation.title = "Test"
        annotation.coordinate = location
        map.addAnnotation(annotation)
        
        
        */
        return location!

    }
}