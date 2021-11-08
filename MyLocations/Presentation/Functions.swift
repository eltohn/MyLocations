//
//  Functions.swift
//  MyLocations
//
//  Created by Elbek Shaykulov on 08/11/21.
//

import Foundation

//MARK:- NOTIFICATION
let dataSaveFailedNotification = Notification.Name(rawValue: "DataSaveFailedNotification")
func fatalCoreDataError(_ error: Error) {
    print("*** Fatal error: \(error)")
    NotificationCenter.default.post(name: dataSaveFailedNotification, object: nil)
}
