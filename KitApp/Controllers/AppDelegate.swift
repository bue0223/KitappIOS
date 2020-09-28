//
//  AppDelegate.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 6/29/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //var reachability: Reachability = Reachability() ?? <#default value#>
        FirebaseApp.configure()
        window?.makeKeyAndVisible()
        
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        if #available(iOS 13.0, *) {
            let container = NSPersistentCloudKitContainer(name: "KitApp")
            container.loadPersistentStores(completionHandler: {
                (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            
            let description = NSPersistentStoreDescription()

            description.shouldInferMappingModelAutomatically = true
            description.shouldMigrateStoreAutomatically = true

            container.persistentStoreDescriptions = [description]
            
            return container
        } else {
            let container = NSPersistentContainer(name: "KitApp")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {

                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            let description = NSPersistentStoreDescription()

            description.shouldInferMappingModelAutomatically = true
            description.shouldMigrateStoreAutomatically = true

            container.persistentStoreDescriptions = [description]
            
            return container
        }
    }()
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
