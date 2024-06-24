//
//  LocalNotification.swift
//  MediaProject
//
//  Created by 김정윤 on 6/22/24.
//

import UIKit

class LocalNotification {
    static let noti = LocalNotification()
    
    func sendNotifiacation() {
        NetworkService.shared.fetchMovieData { result in
            guard let movie = result.results.first else { return }
            
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
