//
//  LoginViewController.swift
//  DemoGalleryApp
//
//  Created by Viren Trivedi on 25/07/26.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var imgLogoShadowLayer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var googleButton: UIButton!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        bindViewModel()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        GoogleSignInManager.shared.restorePreviousSignIn { [weak self] success in
            
            if success {
                DispatchQueue.main.async {
                    self?.navigateToGallery(false)
                }
            }
        }
    }
    
    func configureUI() {
        imgLogo.layer.cornerRadius = 20
        
        imgLogoShadowLayer.layer.cornerRadius = 20
        imgLogoShadowLayer.layer.shadowColor = UIColor.gray.cgColor
        imgLogoShadowLayer.layer.shadowOpacity = 0.4
        imgLogoShadowLayer.layer.shadowOffset = CGSize(width: 0, height: 3)
        imgLogoShadowLayer.layer.shadowRadius = 6
        
        googleButton.setBackgroundImage(
            UIImage(named: "google_login"),
            for: .normal
        )
        googleButton.setTitle("", for: .normal)
        googleButton.clipsToBounds = true
        googleButton.layer.cornerRadius = 12
        googleButton.imageView?.contentMode = .scaleAspectFill
    }
    
    func bindViewModel() {
        viewModel.onLoginSuccess = { [weak self] user in
            print(user.name)
            print(user.email)
            self?.navigateToGallery(true)
        }
        
        viewModel.onError = { error in
            print(error)
        }
    }
    
    private func navigateToGallery(_ animated: Bool) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "GalleryViewController") as! GalleryViewController
        
        navigationController?.setViewControllers([vc], animated: animated)
    }
    
    @IBAction func actionGoogleButton(_ sender: UIButton) {
        viewModel.signIn(from: self)
    }
    
}
