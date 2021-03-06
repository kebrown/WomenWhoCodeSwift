//
//  HTTPClient.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/6/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import Parse

class ParseAPIClient{
    
    init(){
        Parse.setApplicationId(Constants.Api.Parse.appId, clientKey: Constants.Api.Parse.clientKey)
    }
    
    func query(className: String) -> PFQuery{
        return PFQuery(className: className)
    }
    
    func create(parseObject: PFObject, callback: PFBooleanResultBlock?){
        parseObject.saveInBackgroundWithBlock(callback)
    }
    
    //Events *****************************************************************************
    
    func getEventsByFilter(networks: [Network]?, features: [Feature]?,completion: (events: [Event]?, error: NSError?) -> ()) {
        
        let query = PFQuery(className:"Event")
        
//        query.whereKey("feature", containedIn: features!)
//        query.whereKey("network", containedIn: networks!)
//        
        query.includeKey("feature")
        query.includeKey("network")
        getEventList(query, completion: completion)
    }
    
    func getEvents(completion: (events: [Event]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Event")
        query.includeKey("network")
        query.includeKey("feature")
        getEventList(query, completion: completion)
    }
    
    func getEventList(query: PFQuery, completion: (events: [Event]?, error: NSError?) -> ()){
        var events: [Event] = []
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let event = Event(object: object)
                        events.append(event)
                    }
                }
                completion(events: events, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(events: nil, error: error)
            }
        }
    }
    
    func getEventWithEventId(objectID: String, completion: (event: Event?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Event")
        query.includeKey("network")
        query.includeKey("feature")
        query.whereKey("objectId", equalTo: objectID)

        var event: Event?
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        event = Event(object: object)
                    }
                }
                completion(event: event, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(event: nil, error: error)
            }
        }
        
    }
    
    //UserEvents ******************************************************************
    
    func getEventsForUser(userId: String, completion: (events: [Event]?, error: NSError?) -> ()){
        let userEventsquery = PFQuery(className: "UserEvents")
        userEventsquery.whereKey("user_id", equalTo: userId)
        var eventIds:[String] = []
        userEventsquery.findObjectsInBackgroundWithBlock {(objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil{
                if let objects = objects {
                    for object in objects {
                        eventIds.append(object["event_id"] as! String)
                    }
                    //Get Events for the list
                    let query = PFQuery(className:"Event")
                    query.includeKey("network")
                    query.includeKey("feature")
                    query.whereKey("objectId", containedIn: eventIds)
                    self.getEventList(query, completion: completion)
                }
            }else {
                print("Error in getEventIdsForUser: \(error!)")
                completion(events: nil, error: error)
            }
        }
    }
    
    func getUserWithUserId(objectID: String, completion: (user: User?, error: NSError?) -> ()) {
        let query = PFQuery(className:"User")
        query.whereKey("objectId", equalTo: objectID)
        
        var user: User?
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        user = User(object: object)
                    }
                }
                completion(user: user, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(user: nil, error: error)
            }
        }
        
    }
    
    

    
    //Network ***********************************************************************
    
    func getNetworkWithNetworkName (name: String, completion: (network: Network?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Network")
        var network: Network?
        query.whereKey("title", equalTo: name)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        network = Network(object: object)
                    }
                }
                completion(network: network, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(network: nil, error: error)
            }
        }
        
    }
    
    func getNetworks(completion: (networks: [Network]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Network")
        query.orderByAscending("title")
        var networks: [Network] = []

        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let network = Network(object: object)
                        networks.append(network)
                    }
                }
                completion(networks:networks, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(networks: nil, error: error)
            }
        }
        
    }
    
    //Profiles ***********************************************************************
    
    func getProfiles(completion: (profiles: [Profile]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Profile")
        var profiles: [Profile] = []
        query.orderByDescending("updatedAt")
        //query.limit = 10
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let profile = Profile(object: object)
                        profiles.append(profile)
                    }
                }
                completion(profiles: profiles, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(profiles: nil, error: error)
            }
        }
        
    }
    
    func getProfileWithUserId (objectID: String, completion: (profile: Profile?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Profile")
        var profile: Profile?
        query.whereKey("user_id", equalTo: objectID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        profile = Profile(object: object)
                    }
                }
                completion(profile: profile, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(profile: nil, error: error)
            }
        }
        
    }
    
    
    //Posts ***********************************************************************
    
    func getPosts(completion: (posts: [Post]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Post")
        var posts: [Post] = []
        query.orderByDescending("updatedAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let post = Post(object: object)
                        posts.append(post)
                    }
                }
                completion(posts: posts, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(posts: nil, error: error)
            }
        }
        
    }
    
    //Subscriptions ***********************************************************************
    func getSubscriptions(completion: (subscribed: [Subscribed]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Subscribe")
        var subscriptions: [Subscribed] = []
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let subscribe = Subscribed(object: object)
                        subscriptions.append(subscribe)
                    }
                }
                completion(subscribed: subscriptions, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(subscribed: nil, error: error)
            }
        }
        
    }
    
    
    func updateSubscriptionForUser(userId: String?, featureId: String?, subscribed: Bool?, recommended: Bool?, completion: (success:Bool? , error: NSError?) -> ()) {
        let query = PFObject(className:"Subscribe")
        query["user_id"] = userId
        query["feature_id"] = featureId
        query["subscribed"] = subscribed
        query["recommended"] = recommended
        query["user"] = PFObject(withoutDataWithClassName: "_User", objectId: userId)
        query["feature"] = PFObject(withoutDataWithClassName:  "Feature", objectId: featureId)
        
        query.saveInBackgroundWithBlock { (success:Bool?, error: NSError?) -> Void in
            if success == true {
                completion(success: success, error: nil)
            }
            else {
                completion(success: false, error: error)
            }
        }
    }

    func updateExistingSubscriptionForUser(userId: String?, featureId: String?, subscribed: Bool?, recommended: Bool?, completion: (success:Bool? , error: NSError?) -> ()) {
        
        //print("user_id = \(userId!), feature_id = \(featureId!)")
        let subscription = PFObject(className:"Subscribe")
        let predicate = NSPredicate(format:"user_id == '\(userId!)' AND feature_id == '\(featureId!)'")
        let query = PFQuery(className: "Subscribe", predicate: predicate)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                //print("Successfully retrieved \(objects!.count) profiles.")
                
                if objects!.count == 0 {
                    subscription["user_id"] = userId
                    subscription["feature_id"] = featureId
                    subscription["subscribed"] = subscribed
                    subscription["recommended"] = recommended
                    subscription["user"] = PFObject(withoutDataWithClassName: "_User", objectId: userId)
                    subscription["feature"] = PFObject(withoutDataWithClassName:  "Feature", objectId: featureId)
                    // This will save both myPost and myComment
                    subscription.saveInBackground()
                    
                }
                else {
                    //Update existing subscription
                    for object in objects! {
                        object["user_id"] = userId
                        object["feature_id"] = featureId
                        object["subscribed"] = subscribed
                        object["recommended"] = recommended
                        object["user"] = PFObject(withoutDataWithClassName: "_User", objectId: userId)
                        object["feature"] = PFObject(withoutDataWithClassName:  "Feature", objectId: featureId)
                        object.saveInBackground()
                    }

                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        }

    }
    
    //Features ***********************************************************************
    
    func getFeatures(completion: (features: [Feature]?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Feature")
        var features: [Feature] = []
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let feature = Feature(object: object)
                        features.append(feature)
                    }
                }
                completion(features: features, error: nil)
            } else {
                print("Error: \(error!) \(error!.userInfo)")
                completion(features: nil, error: error)
            }
        }
        
    }
    
    func getFeatureWithFeatureId(objectID: String, completion: (feature: Feature?, error: NSError?) -> ()) {
        let query = PFQuery(className:"Feature")
        query.whereKey("objectId", equalTo: objectID)
        
        var feature: Feature?
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        feature = Feature(object: object)
                    }
                }
                completion(feature: feature, error: nil)
            } else {
                completion(feature: nil, error: error)
            }
        }
        
    }
    
    

}
