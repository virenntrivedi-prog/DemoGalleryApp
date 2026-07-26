//
//  LoginViewModel.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation
import GoogleSignIn
import UIKit

class LoginViewModel {
    
    var onLoginSuccess:((User) -> Void)?
    var onError: ((String) -> Void)?
    
    func signIn(from viewController: UIViewController) {
        
        GoogleSignInManager.shared.signIn(presenting: viewController) { result in
            
            switch result {
                
            case .success(let googleUser):
                
                let user = User(
                    id: googleUser.userID ?? "",
                    name: googleUser.profile?.name ?? "",
                    email: googleUser.profile?.email ?? "",
                    profileImage: googleUser.profile?.imageURL(withDimension: 200)?.absoluteString
                )
                
                DispatchQueue.main.async {
                    self.onLoginSuccess?(user)
                }
                
            case .failure(let error):
                
                DispatchQueue.main.async {
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}
