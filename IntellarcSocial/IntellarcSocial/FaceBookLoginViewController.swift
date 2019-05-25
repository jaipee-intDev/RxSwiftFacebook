//
//  ViewController.swift
//  IntellarcSocial
//
//  Created by jayant patidar on 24/05/19.
//  Copyright © 2019 IntellArc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKLoginKit

class FaceBookLoginViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    let disposeBag = DisposeBag()
    var viewModel = FBLoginViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupBindings()
    }
    
    @IBAction func loginButtonAction(sender: Any!) {
        viewModel.loginWithFacebook(fromController: self)
    }
}

extension FaceBookLoginViewController {
    func setupBindings() {
        self.viewModel.email.asObservable()
        .bind(to: self.emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.name.asObservable()
            .bind(to: self.nameLabel.rx.text)
            .disposed(by: disposeBag)
        
        self.viewModel.picture.asObservable()
            .bind(to: self.imageView.rx.image)
            .disposed(by: disposeBag)
    }
}
