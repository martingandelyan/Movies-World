//
//  SplashScreenView.swift
//  MoviesFromTheWorld
//
//  Created by Martin on 24.12.25.
//

import UIKit

class SplashScreenViewController: UIViewController {
    private var splashImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSplashLogo()
        goToMainTabBarAfterDelay()
        // Do any additional setup after loading the view.
    }
    
    private func setupSplashLogo() {
        splashImageView = UIImageView(image: UIImage(named: "SplashLogo"))
        splashImageView.contentMode = .scaleAspectFit
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashImageView)
        
        NSLayoutConstraint.activate([
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.heightAnchor.constraint(equalToConstant: 200),
            splashImageView.widthAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    private func goToMainTabBarAfterDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.goToMainTabBar()
        }
    }
    
    private func goToMainTabBar() {
        UIView.animate(withDuration: 0.6) {
            self.splashImageView.alpha = 0
            self.splashImageView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController = MainTabBarViewController()
            }
        }
    }
}
