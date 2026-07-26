//
//  ProfileViewModel.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import Foundation

class ProfileViewModel {

    private(set) var user: User?

    var onUserLoaded: (() -> Void)?
    var onLogout: (() -> Void)?

    func loadUser() {
        user = GoogleSignInManager.shared.currentUser()
        onUserLoaded?()
    }

    func logout() {
        GoogleSignInManager.shared.signOut()
        onLogout?()
    }
}
