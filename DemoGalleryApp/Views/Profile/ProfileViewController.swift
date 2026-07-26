//
//  ProfileViewController.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    private let viewModel = ProfileViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        
        viewModel.loadUser()
    }
    
    private func configureUI() {
        
        title = "Profile"
        
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .systemGray3
        
        btnLogout.configuration = .filled()
        btnLogout.configuration?.title = "Logout"
        btnLogout.configuration?.baseBackgroundColor = .systemRed
    }
    
    private func bindViewModel() {
        
        viewModel.onUserLoaded = { [weak self] in
            self?.updateUI()
        }
        
        viewModel.onLogout = { [weak self] in
            self?.navigateToLogin()
        }
    }
    
    private func updateUI() {
        
        guard let user = viewModel.user else { return }
        
        lblName.text = user.name
        lblEmail.text = user.email
        
        if let urlString = user.profileImage,
           let url = URL(string: urlString) {
            
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(systemName: "person.crop.circle.fill")
            )
        }
    }
    
    @IBAction func logoutTapped(_ sender: UIButton) {
        
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            
            self.viewModel.logout()
            
        })
        
        present(alert, animated: true)
    }
    
    private func navigateToLogin() {
        
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        
        navigationController?.setViewControllers([vc], animated: false)
    }
    
}
