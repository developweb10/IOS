//
//  ApiInteraction.swift
//  meetup
//
//  Created by developer on 23/04/19.
//  Copyright © 2019 MDSoft. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ApiInteraction : NSObject{
    
    static let sharedInstance = ApiInteraction()
    
    func funcToHitGetApi(url: String, params: [String: AnyObject]?, header: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (String) -> Void){
        ApiManager.sharedInstance.requestGetURL(url, params: params, headers: header, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }

    func funcToHitPostRawApi(url: String, params: [String: AnyObject]?, header: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (String) -> Void){
        ApiManager.sharedInstance.requestPOSTFormDataURL(url, params: params, headers: header, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
    func funcToHitPostFormDataApi(url: String, params: [String: AnyObject]?, header: [String: String]?, success: @escaping (JSON) -> Void, failure: @escaping (String) -> Void){
        ApiManager.sharedInstance.requestPOSTURL(url, params: params, headers: header, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
    }
    
    func funcToHitMultipartApi(url: String, params:[String: AnyObject]?,imageArray: [UIImage],imgname: [String],header:[String: String]?,success: @escaping (JSON)-> Void, failure: @escaping (String)-> Void){
        ApiManager.sharedInstance.requestMultiPartURL(url, params: params, headers: header, imagesArray: imageArray, imageName: imgname, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
        
    }
    
    func funcToHitMultipartImageDataApi(url: String, params:[String: AnyObject]?,imageArray: [UIImage],imgname: String,header:[String: String]?,success: @escaping (JSON)-> Void, failure: @escaping (String)-> Void){
        ApiManager.sharedInstance.requestMultiPartImageURL(url, params: params, headers: header, imagesArray: imageArray, imageName: imgname, success: { (json) in
            success(json)
        }) { (error) in
            failure(error)
        }
        
    }
}

