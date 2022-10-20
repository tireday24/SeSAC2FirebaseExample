//
//  AppDelegate.swift
//  SeSAC2FirebaseExample
//
//  Created by 권민서 on 2022/10/05.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let config = Realm.Configuration(schemaVersion: 2) { migtation, oldScemaVersion in
            
            if oldScemaVersion < 1 {//DetailTodo, List 추가
                
            }
            
            if oldScemaVersion < 2 {//EmbeddedObject 추가

            }

//            if oldScemaVersion < 3 {//DetailTodo에 deadline 추가
//
//            }
            
        }
        
        Realm.Configuration.defaultConfiguration = config
        
        //렘마이그레이션 호출 함수
        //aboutRealmMigration()
        
        UIViewController.swizzleMethod()
        
        FirebaseApp.configure()
        
        //원격 알림 시스템에 앱을 등록
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
          )
        } else {
          let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        //메세지 대리자 설정
        Messaging.messaging().delegate = self
        
        //현재 등록된 토큰 가져오기
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//          }
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    //func swizzling(옵션)
    func application(application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      Messaging.messaging().apnsToken = deviceToken
    }
    
    //foreground에서의 알림 수신: 로컬/푸시 동일
    //카카오톡: 유저와의 채팅방, 푸쉬마다 설정, 화면마다 설정 가능
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //Setting 화면에 있다면 포그라운드 푸시 띄우지 마라! 채팅 회사에서 많이 사용
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        if viewController is SettingViewController {
            //세팅 뷰 컨에서 올릴것만 올림
            completionHandler([])
        }else {
            //.banner, .list: iOS14+
            completionHandler([.badge, .sound, .banner, .list])
        }
    }
    
    //푸시 클릭: 호두과자 장바구니 담는 화면까지 전환
    //유저가 푸시를 클릭했을 때만 수신 확인 가능
    
    //특정 푸시를 클릭하면 특정 상세 화면으로 화면 전환 >
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("사용자가 푸시를 클릭했습니다")
        
        print(response.notification.request.content.body)
        print(response.notification.request.content.userInfo)
        
        let userInfo = response.notification.request.content.userInfo
        
        if userInfo[AnyHashable("sesac")] as? String == "project" {
            print("SESAC PROJECT")
        }else {
            print("NOTHING")
        }
        
        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        
        print(viewController)
        
        //오직 뷰컨에서 작동하게 하는 코드
        if viewController is ViewController {
            viewController.navigationController?.pushViewController(SettingViewController(), animated: true)
        }
        
        //만약에 최상단의 뷰컨이 프로필뷰컨일때
        if viewController is ProfileViewController {
            viewController.dismiss(animated: true)
        }
        
        
    }
    
    
}

extension AppDelegate {
    
    func aboutRealmMigration() {
        //deleteRealmMigrationNeeded: 마이그레이션이 필요한 경우 기존 렘 삭제(Realm Browser 닫고 다시 열기!) 출시하기 전에 삭제 꼭 하기
//        let config = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
        
        let config = Realm.Configuration(schemaVersion: 6) { migration, oldSchemaVersion in
            
            //컬럼, 테이블 단순 추가 삭제의 경우엔 별도 코드 필요 X
            //else if 안쓴 이유 각각의 버전을 다 타야함 나머지는 패스하기 때문에
            if oldSchemaVersion < 1 {
                
            }
            
            if oldSchemaVersion < 2 {
                
            }
            
            if oldSchemaVersion < 3 {
                //프로퍼티 명 바꾼다면 어떤 테이블에 누구를 어떻게 바꿀거냐
                migration.renameProperty(onType: Todo.className(), from: "importance", to: "favorite")
            }
            
            if oldSchemaVersion < 4 {
                //Realm 합치기
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    //oldObject -> 합쳐진 것, newObject
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    //userDescription에 내용 포함하겠다
                    new["userDescription"] = "안녕하세요 \(old["title"]!)의 중요도는 \(old["favorite"]!)입니다"
                }
            }
            
            if oldSchemaVersion < 5 {
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    new["count"] = 100
                }
            }
            
            if oldSchemaVersion < 6 {
                //테이블 여러개라면 타입 부분에
                migration.enumerateObjects(ofType: Todo.className()) { oldObject, newObject in
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    //타입 변환 new optional, old optional
                    new["favorite"] = old["favorite"]
                    
                    //new required, old optional
                    new["favorite"] = old["favorite"] ?? 0.0
                    
                    //조건문으로 분기 처리 가능
//                    if old["favorite"] < 4 {
//                        new["favorite"] = 5.5
//                    }
                    
                }
            }
        
            
            
        }
        
        //모든 스키마 버전 Realm부터 속성을 반영하겠다
        Realm.Configuration.defaultConfiguration = config
    }
}

extension AppDelegate: MessagingDelegate {
    
    //토큰 갱신 모니터링: 토큰 정보가 언제 바뀔까?(옵션)
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict: [String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(
        name: Notification.Name("FCMToken"),
        object: nil,
        userInfo: dataDict
      )
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

