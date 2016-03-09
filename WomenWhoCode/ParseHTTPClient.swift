//
//  HTTPClient.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class ParseHTTPClient{
    
    //API KEYS
    
    var appId = "sW8VXwGAEeq8FYaKMgcbPfliodb8XA7wx0QXLdx9"
    var clientKey = "HTVvl8X9szeaOlXzI8jEUx0MENGlzDTrCIrPCnIy"
    
    init(){
        Parse.setApplicationId(appId, clientKey: clientKey)
    }
    
    func query(className: String) -> PFQuery{
        return PFQuery(className: className)
    }
    
    func create(parseObject: PFObject, callback: PFBooleanResultBlock?){
        parseObject.saveInBackgroundWithBlock(callback)
    }
    
    func getEvents(completion: (events: [Event]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Event")
        var events: [Event] = []
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
//                print("Successfully retrieved \(objects!.count) scores.")
                if let objects = objects {
                    for object in objects {
                       let event = Event(object: object)
                       events.append(event)
                    }
                }
                completion(events: events, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion(events: nil, error: error)
            }
        }
        
    }
    
    func getProfiles(completion: (profiles: [Profile]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Profile")
        var profiles: [Profile] = []
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) profiles.")
                if let objects = objects {
                    for object in objects {
                        let profile = Profile(object: object)
                        print("Profile fullname: \(profile.fullName)")
                        profiles.append(profile)
                    }
                }
                completion(profiles: profiles, error: nil)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completion(profiles: nil, error: error)
            }
        }
        
    }
}