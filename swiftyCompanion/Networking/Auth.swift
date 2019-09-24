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
import Locksmith

class Auth: NSObject {
    
    private let userAccount = "myAccount"
    private var token = String()
    private var bearer: [String: String] { return ["Authorization": "Bearer " + token] }
    
    private var authURL = "https://api.intra.42.fr/oauth/token"
    private var tokenInfoURL: String { return authURL + "/info" }
    
    private var parameters = [
        "grant_type": "client_credentials",
        "client_id": "5d5ac8d676dba4a5fb3e9d492951e8976d9d95d2a86ebadbf3d77f569a2b37f1",
        "client_secret": "0c7adb3fe2c0398749fffcaebf0a9a450992a1acb975b42a5719fcd5f0c2e009",
        "scope": "public"
    ]

    func checkIfTokenStoredInKeyChain() {
        let userData = Locksmith.loadDataForUserAccount(userAccount: userAccount)
        if let value = userData?["token"] as? String {
            token = value
        } else {
            token = ""
        }
    }
    
    func getToken() {
        
        checkIfTokenStoredInKeyChain()
        if token.isEmpty {
            Alamofire.request(authURL, method: .post, parameters: parameters).validate().responseJSON { (responseJSON) in
                switch responseJSON.result {
                case .success(let value):
                    let json = JSON(value)
                    if let value = json["access_token"].string {
                        self.token = value
                        do {
                            try Locksmith.saveData(data: ["token": value], forUserAccount: self.userAccount)
                        } catch {
                            print("Unable to save token in KeyChain")
                        }
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
                print("Token is invalid. Will get a new one.")
                do {
                    try Locksmith.deleteDataForUserAccount(userAccount: self.userAccount)
                } catch {
                    print("Couldn't delete data for user \(self.userAccount) from KeyChain. Error: ", error)
                }
                print("Invalid token was deleted from KeyChain")
                self.getToken()
            }
        }
    }
    
    func searchLogin(_ login: String, completionHandler: @escaping (JSON?, String?) -> Void ) {
        let loginURL = "https://api.intra.42.fr/v2/users/" + login
        print("Login URL -> ", loginURL)
        print("Token: -> ", token)
        Alamofire.request(loginURL, headers: bearer).validate().responseJSON { (responseJSON) in
            switch responseJSON.result {
            case .success(let value):
                completionHandler(JSON(value), nil)
            case .failure:
                var errorMessage: String?
                var response = JSON()
                if let data = responseJSON.data {
                    do {
                        response = try JSON(data: data)
                    } catch (let error) {
                        print("Error creating a JSON object", error)
                    }
                    debugPrint(response)
                    errorMessage = response["message"].string
                }
                completionHandler(nil, errorMessage)
            }
        }
    }
}
