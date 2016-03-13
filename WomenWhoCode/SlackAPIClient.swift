//
//  SlackAPIClient.swift
//  WomenWhoCode
//
//  Created by Vinu Charanya on 3/11/16.
//  Copyright © 2016 WomenWhoCode. All rights reserved.
//

import UIKit
import OAuthSwift
import SwiftyJSON

class SlackAPIClient {
    let clientId = "23398940453.26339368899"
    let clientSecret = "143fc69c2b2c1007d1aa55f40c4d5e7b"
    var oauthswift:OAuth2Swift?
    var oauthToken = ""
    let baseUrl = "https://slack.com/"
    
    
    func readGen(succesCallback: ([Message]) -> Void){
        oauthswift!.client.get("https://slack.com/api/channels.history",
            parameters: ["token": oauthToken, "channel": "C0PBTN49W"],
            success: {
                data, response in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let dataFromString = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let jsonData = JSON(data: dataFromString)
                    //If json is .Dictionary
                    for (key,json):(String, JSON) in jsonData {
                        if (key == "messages"){
                            let messages = Message.initWithJSONArray(json.array!)
                            succesCallback(messages)
                        }
                    }
                }
            }
            , failure: { error in
                print(error)
            }
        )
    }
    
    func login(){
            oauthswift = OAuth2Swift(
            consumerKey:    clientId,
            consumerSecret: clientSecret,
            authorizeUrl:   "https://slack.com/oauth/authorize",
            accessTokenUrl: "https://slack.com/api/oauth.access",
            responseType:   "code"
        )
        oauthswift!.authorizeWithCallbackURL(
            NSURL(string: "womenwhocode://oauth-callback/slack")!,
            scope: "channels:read,channels:history,users:read", state:"SLACK",
            success: { credential, response, parameters in
                self.oauthToken = credential.oauth_token
            },
            failure: { error in
                print(error.localizedDescription, terminator: "")

            }
        )
    }
}
//Channel queries
extension SlackAPIClient{
    
    //get list of channels -- channels:read (scope)
    func getChannelsList(successCallback:([SlackChannel])->Void){
        oauthswift!.client.get("https://slack.com/api/channels.list",
            parameters: ["token": oauthToken, "exclude_archived": 1],
            success: {
                data, response in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let dataFromString = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let jsonData = JSON(data: dataFromString)
                    //If json is .Dictionary
                    for (key,json):(String, JSON) in jsonData {
                        if (key == "channels"){
                            let channels = SlackChannel.initWithJSONArray(json.array!)
                            successCallback(channels)
                        }
                    }
                }
            }
            , failure: { error in
                print(error)
            }
        )
    }
    
    //get channel info -- channels:read (scope)
    func getChannelsInfo(channelId: String, successCallback:(SlackChannel)->Void){
        oauthswift!.client.get("https://slack.com/api/channels.info",
            parameters: ["token": oauthToken, "channel":channelId],
            success: {
                data, response in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let dataFromString = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let jsonData = JSON(data: dataFromString)
                    //If json is .Dictionary
                    for (key,json):(String, JSON) in jsonData {
                        if (key == "channel"){
                            let channel = SlackChannel(dict: json)
                            successCallback(channel)
                        }
                    }
                }
            }
            , failure: { error in
                print(error)
            }
        )
    }
    
    //get list of users -- users:read (scope)
    func getUsersList(successCallback:([SlackUser])->Void){
        oauthswift!.client.get("https://slack.com/api/users.list",
            parameters: ["token": oauthToken, "presence": 1],
            success: {
                data, response in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let dataFromString = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let jsonData = JSON(data: dataFromString)
                    //If json is .Dictionary
                    for (key,json):(String, JSON) in jsonData {
                        if (key == "members"){
                            let users = SlackUser.initWithJSONArray(json.array!)
                            successCallback(users)
                        }
                    }
                }
            }
            , failure: { error in
                print(error)
            }
        )
    }

    
    //get channel history -- channels:history (scope)
    
    func getChannelHistory(channelId: String, successCallback: ([Message]) -> Void){
        oauthswift!.client.get("https://slack.com/api/channels.history",
            parameters: ["token": oauthToken, "channel": channelId],
            success: {
                data, response in
                let dataString = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let dataFromString = dataString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                    let jsonData = JSON(data: dataFromString)
                    //If json is .Dictionary
                    for (key,json):(String, JSON) in jsonData {
                        if (key == "messages"){
                            let messages = Message.initWithJSONArray(json.array!)
                            successCallback(messages)
                        }
                    }
                }
            }
            , failure: { error in
                print(error)
            }
        )
    }
    
    //Write to a channel
    
    //Mentions and auto complete
    
    
    
    
}