//
//  Common.swift
//  Tour Guide Demo
//
//  Created by developer on 20/02/19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

let usernameRegex = "[A-Za-z0-9]{1,30}"

let passwordRegex = "^.{6,20}$"

let emailRegx = "[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

let deviceID = UIDevice.current.identifierForVendor?.uuidString


//Live URL
let mainURL = "http://182.73.95.220/findme/Api/"


let standard = UserDefaults.standard

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let storyboard = UIStoryboard.init(name: "Main", bundle: nil)


//let colorTop =  UIColor(red: 237.0/255.0, green: 76.0/255.0, blue: 57.0/255.0, alpha: 1.0)
let colorTop =  UIColor(red: 0.0/255.0, green: 173.0/255.0, blue: 192.0/255.0, alpha: 1.0)

//let colorBottom = UIColor(red: 254.0/255.0, green: 36.0/255.0, blue: 97.0/255.0, alpha: 1.0)
let colorBottom = UIColor(red: 0.0/255.0, green: 192.0/255.0, blue: 163.0/255.0, alpha: 1.0)

let navColor = UIColor(red: 41/255, green: 127/255, blue: 202/255, alpha: 1)

let BlueRightColor = UIColor(red: 8/255, green: 43/255, blue: 115/255, alpha: 1)

let BlueLeftColor = UIColor(red: 12/255, green: 91/255, blue: 253/255, alpha: 1)

let LightBlueRightColor = UIColor(red: 1/255, green: 228/255, blue: 255/255, alpha: 1)

let LightBlueLeftColor = UIColor(red: 111/255, green: 248/255, blue: 243/255, alpha: 1)

let RedLeftColor = UIColor(red: 224/255, green: 32/255, blue: 29/255, alpha: 1)

let RedRightColor = UIColor(red: 142/255, green: 0/255, blue: 0/255, alpha: 1)




