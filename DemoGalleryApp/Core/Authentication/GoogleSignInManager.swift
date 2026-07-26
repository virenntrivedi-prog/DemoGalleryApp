//
//  GoogleSignInManager.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation
import UIKit
import GoogleSignIn

class GoogleSignInManager {
    
    static let shared = GoogleSignInManager()
        
    func signIn(
        presenting viewController: UIViewController,
        completion: @escaping (Result<GIDGoogleUser, Error>) -> Void
    ) {
        
        guard let clientID = Bundle.main.object(forInfoDictionaryKey: "GIDClientID") as? String else {
            return
        }
        
        let configuration = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.configuration = configuration
        
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user else { return }
            completion(.success(user))
        }
    }
    
    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    func restorePreviousSignIn(completion: @escaping (Bool) -> Void) {
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            completion(user != nil)
        }
    }
    
    func currentUser() -> User? {

        guard let googleUser = GIDSignIn.sharedInstance.currentUser else {
            return nil
        }

        return User(
            id: googleUser.userID ?? "",
            name: googleUser.profile?.name ?? "",
            email: googleUser.profile?.email ?? "",
            profileImage: googleUser.profile?.imageURL(withDimension: 200)?.absoluteString
        )
    }
    
}
