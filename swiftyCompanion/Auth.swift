//
//  Auth.swift
//  swiftyCompanion
//
//  Created by Maksym MATIUSHCHENKO on 8/13/19.
//  Copyright © 2019 Maksym MATIUSHCHENKO. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Auth: NSObject {
    
    private var token = String()
    private lazy var bearer = ["Authorization": "Bearer " + token]
    
    private var authURL = "https://api.intra.42.fr/oauth/token"
    private var tokenInfoURL: String { return authURL + "/info" }
    
    private var parameters = [
        "grant_type": "client_credentials",
        "client_id": "5d5ac8d676dba4a5fb3e9d492951e8976d9d95d2a86ebadbf3d77f569a2b37f1",
        "client_secret": "0c7adb3fe2c0398749fffcaebf0a9a450992a1acb975b42a5719fcd5f0c2e009",
        "scope": "public"
    ]
    
    func getToken() {
        if token.isEmpty {
        Alamofire.request(authURL, method: .post, parameters: parameters).validate().responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success(let value):
                let json = JSON(value)
                if let token = json["access_token"].string {
                    self.token = token
                    print("Generated a new token: ", self.token)
                }
                
            case .failure:
                var errorMessage = "Received an error requesting the token"
                var response = JSON()
                if let data = responseJSON.data {
                    do {
                        response = try JSON(data: data)
                    } catch (let error) {
                        print(error)
                    }
                    if let message = response["error_description"].string {
                        if !message.isEmpty {
                            errorMessage = message
                        }
                    }
                }
                print("Error: ", errorMessage)
            }
        }
        } else {
            print("Using the same token:", token)
            checkToken()
        }
    }
    
    func checkToken() {
        Alamofire.request(tokenInfoURL, method: .get, headers: bearer).validate().responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success(let value):
                let json = JSON(value)
                print("The token will expire in: ", json["expires_in_seconds"], " seconds")
            case .failure:
                print("Token invalid. Getting a new one.")
                self.getToken()
            }
        }
    }
    
    func searchLogin(_ login: String, completionHandler: @escaping (JSON?) -> Void ) {
        let loginURL = "https://api.intra.42.fr/v2/users/" + login.replacingOccurrences(of: " ", with: "")
        print(loginURL)
        print(token)
        Alamofire.request(loginURL, headers: bearer).validate().responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success(let value):
                print("User JSON -> ", JSON(value))
                completionHandler(JSON(value))
            case .failure(let error):
                completionHandler(nil)
                print("Users doesn't exist. ", error.localizedDescription)
            }
        }
    }
}
