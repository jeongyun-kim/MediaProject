//
//  LocalNotification.swift
//  MediaProject
//
//  Created by 김정윤 on 6/22/24.
//

import UIKit

class LocalNotificationCenter {
    private init() { }
    static let noti = LocalNotificationCenter()
    
    func sendNotifiacation() {

        NetworkService.shared.fetchMovieData { data, error  in
            guard let data = data else { return }
            guard let movie = data.results.first else { return }
            
            let content = UNMutableNotificationContent()
            content.title = "오늘의 영화 알림"
            content.body = "\(movie.title)이(가) 급상승 중이에요!"
            
            // 오후 12시마다 알림주기 
            var dateComponents = DateComponents()
            dateComponents.hour = 12
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: "\(Date())", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
        }
    }
    
    fileprivate let a = "a"
}
