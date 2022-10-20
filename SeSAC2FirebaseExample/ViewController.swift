//
//  ViewController.swift
//  SeSAC2FirebaseExample
//
//  Created by 권민서 on 2022/10/05.
//

import UIKit
import FirebaseAnalytics

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Analytics.logEvent("rejack", parameters: [
//            "name": "고래밥",
//            "full_text": "안녕하세요",
//        ])
//
//        Analytics.setDefaultEventParameters([
//            "level_name": "Caverns01",
//            "level_difficulty": 4
//        ])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("ViewController ViewWillAppear")
    }
    
    @IBAction func profileButtonClicked(_ sender: UIButton) {
        present(ProfileViewController(), animated: true)
    }
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        navigationController?.pushViewController(SettingViewController(), animated: true)
    }
    
    
    @IBAction func crashButtonClicked(_ sender: UIButton) {
    }
    
}

class ProfileViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("ProfileViewController ViewWillAppear")
    }
    
}

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("SettingViewController ViewWillAppear")
    }
    
}




extension UIViewController {
    
    var topViewController: UIViewController? {
        return self.topViewContriller(currentViewController: self)
    }
    
    //최상위 뷰컨트롤러를 판단해주는 메서드 유저가 바라보고 있는 최상단의 컨트롤러
    func topViewContriller(currentViewController: UIViewController) -> UIViewController {
        if let tabBarController = currentViewController as? UITabBarController, let selectedViewController = tabBarController.selectedViewController {
            
            return self.topViewContriller(currentViewController: selectedViewController)
            
        }else if let navigationController = currentViewController as? UINavigationController, let visibleViewController = navigationController.visibleViewController {
            
            return self.topViewContriller(currentViewController: visibleViewController)
            
        }else if let presentedViewController = currentViewController.presentedViewController {
            
            return self.topViewContriller(currentViewController: presentedViewController)
            
        }else {
            
            return currentViewController
            
        }
        
    }
    
}

extension UIViewController {
    
    //class vs static
    class func swizzleMethod() {
        
        let origin = #selector(viewWillAppear)
        let change = #selector(changeViewWillAppear)
        
        guard let originMethod = class_getInstanceMethod(UIViewController.self, origin), let changeMethod = class_getInstanceMethod(UIViewController.self, change) else {
            print("함수를 찾을 수 없거나 오류 발생")
            return
        }
        
        //2가지 매서드 바꿔줌
        method_exchangeImplementations(originMethod, changeMethod)
        
    }
    
    @objc func changeViewWillAppear() {
        print("Change ViewWillAppear SUCCEED")
    }
    
}
