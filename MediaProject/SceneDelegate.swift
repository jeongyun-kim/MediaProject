//
//  SceneDelegate.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        // SceneDelegate의 프로퍼티에 설정
        window = UIWindow(windowScene: windowScene)
        let mainView = UINavigationController(rootViewController: MainViewController())
        // 처음 보여질 화면(=탭바)을 root로 설정하고 보여주기
        window?.rootViewController = mainView
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        // 앱이 백그라운드로 진입했을 때, 예약된 알림을 받아올 수 있는 상태인지 확인하기
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            switch setting.authorizationStatus {
            case .notDetermined:
                print("권한 선택 X(한 번 허용)")
            case .denied:
                print("권한 X")
            case .authorized:
                print("권한 O")
                LocalNotificationCenter.noti.sendNotifiacation()
            case .provisional:
                print("임시 중단")
            case .ephemeral:
                print("앱 클립에 대해 부분 동의 (?)")
            @unknown default:
                break
            }
        }
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

