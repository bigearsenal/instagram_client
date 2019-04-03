//
//  InstagramAPI.swift
//  Instagram
//
//  Created by Chung Tran on 03/04/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import Unbox
import RxAlamofire

final class InstagramAPI {
    // MARK: - Variables
    private let endpoint = "https://api.instagram.com"
    static let clientID = "56daf9a296664108b2f88e0357c96d5f"
    static let clientSecret = "b2558a171f9c4f34af67eec23ec06911"
    static let redirectURL = "https://bigears.info"
    
    // MARK: - Singleton
    static let standard = InstagramAPI()
    private init() {}
    
    // MARK: - Aunthentication
    enum LoginError: Error {
        case invalidLoginResponse
    }
    
    lazy var loggedIn = BehaviorRelay<Bool>(value: AuthStorage.token == nil ? false: true)
    
    func loginWithCode(_ code: String) -> Completable {
        return Completable.create {completable in
            let params = [
                "client_id": InstagramAPI.clientID,
                "client_secret": InstagramAPI.clientSecret,
                "grant_type": "authorization_code",
                "code": code,
                "redirect_uri": InstagramAPI.redirectURL
            ]
            Alamofire.request("\(self.endpoint)/oauth/access_token", method: .post, parameters: params)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let value):
                        if let dict = value as? [String: AnyObject],
                            let token = dict["access_token"] as? String {
                            AuthStorage.token = token
                            completable(.completed)
                            self.loggedIn.accept(true)
                            return
                        }
                        
                        // handle token failed
                        completable(.error(LoginError.invalidLoginResponse))
                        break
                    case .failure(let error):
                        // Handle error
                        completable(.error(error))
                        break
                    }
            }
            
            return Disposables.create()
        }
        
    }
    
    // MARK: - Helpers
    enum InstagramAPIError: Error {
        case invalidToken
    }
    func requestWithToken(router: String, method: HTTPMethod, parameters: [String: String]?) -> Observable<(HTTPURLResponse, Any)> {
        guard let token = AuthStorage.token else {return Observable.error(InstagramAPIError.invalidToken)}
        var query = "?access_token=\(token)"
        if router.contains("?") {query = "&access_token=\(token)"}
        return RxAlamofire.requestJSON(method, "\(endpoint)\(router)\(query)", parameters: parameters)
    }
}
