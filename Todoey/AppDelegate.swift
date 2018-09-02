//
//  AppDelegate.swift
//  Todoey
//
//  Created by David Bowles on 18/07/2018.
//  Copyright © 2018 David Bowles. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
       
        
        do {
           _ = try Realm()

        } catch {
            print("Error  initialisng realm erro is \(error)")
        }
        
        return true
        
    }


    
    

}

