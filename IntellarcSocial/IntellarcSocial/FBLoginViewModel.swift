//
//  FBLoginViewModel.swift
//  IntellarcSocial
//
//  Created by jayant patidar on 24/05/19.
//  Copyright © 2019 IntellArc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import FBSDKLoginKit

class FBLoginViewModel: NSObject {
    let disposeBag = DisposeBag()
    
    let name    :  PublishSubject<String> = PublishSubject()
    let email   :  PublishSubject<String> = PublishSubject()
    let id      :  PublishSubject<String> = PublishSubject()
    let picture :  PublishSubject<UIImage> = PublishSubject()
    
    var parentView = UIView()
    
    
    var loginButtonPressed = PublishSubject<Void>()
    var logoutButtonPressed = PublishSubject<Void>()
    
    override init() {
        super.init()
    }
    

    func loginWithFacebook(fromController: UIViewController) {
        parentView = UIApplication.shared.keyWindow!
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email","public_profile"], from: fromController) { (result, error) in
            
            if (error == nil)
            {
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                print(fbloginresult.grantedPermissions)
                if(fbloginresult.isCancelled) {
                    //Show Cancel alert
                    print("Cancel Alert")
                } else if(fbloginresult.grantedPermissions.contains("email")) {
                    self.returnUserData()
                }
                
            }else{
                print("\n\n Error: \(String(describing: error))")
            }
        }
    }
    
    private func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture,birthday,hometown"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil)
            {
                print("\n\n Error: \(String(describing: error))")
            }
            else
            {
                let resultDic = result as! [String: AnyObject]//NSDictionary
                //let fbId = resultDic["id"] as? String ?? ""
                let url = ((resultDic["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String ?? ""
                print("Image url = \(url)")
                let strEmail = resultDic["email"] as? String ?? "email not get"
                let strName = resultDic["name"] as? String ?? ""
                let id = resultDic["id"] as? String ?? ""
                let model = User()//.init(name: strName, email: strEmail, image: url)
                self.name.onNext(strName)
                self.email.onNext(strEmail)
                do {
                    let data = try Data(contentsOf: URL(string: url)!)
                    let image : UIImage = UIImage(data: data)!
                    self.picture.onNext(image)
                }catch{
                    
                }
                
                self.id.onNext(id)
                print(model)
            }
        })
    }
}



