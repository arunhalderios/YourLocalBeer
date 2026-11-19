//
//  Constants.swift
//  YLB
//
//  Created by Abhishek Mullick on 09/01/19.
//  Copyright © 2019 Abhishek Mullick. All rights reserved.
//

import Foundation

enum ServiceCallType:String {
    case POST
    case GET
}

let GET :ServiceCallType = ServiceCallType.GET
let POST :ServiceCallType = ServiceCallType.POST
let App_title :String = "Your Local Beer"
let Service_err_msg :String = "Something went wrong. Please try again"
let Service_timeout :TimeInterval = 5.0

let BASE_URL = "https://www.beta.yourlocalbeer.com/api/"
//let BASE_URL = "https://www.yourlocalbeer.com/api/"
let WEB_URL = "https://www.beta.yourlocalbeer.com/"
//let WEB_URL = "https://www.yourlocalbeer.com/"
