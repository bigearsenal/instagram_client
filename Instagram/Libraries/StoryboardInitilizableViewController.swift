//
//  StoryboardInitilizableViewController.swift
//  github
//
//  Created by Chung Tran on 26/03/2019.
//  Copyright © 2019 Chung Tran. All rights reserved.
//

import UIKit

protocol StoryboardInitializableViewController {
    static var storyboardName: String {get}
    static var storyboardIdentifier: String {get}
}

extension StoryboardInitializableViewController where Self: UIViewController {
    private static func stringFromSwiftClass(_ swiftClass: AnyClass) -> String {
        return NSStringFromClass(swiftClass).components(separatedBy: ".").last!// NSClassFromString(executableName + "." + className)
    }
    static func fromStoryboard() -> Self {
        let vc = UIStoryboard(name: storyboardName, bundle: Bundle.main).instantiateViewController(withIdentifier: storyboardIdentifier)
        return vc as! Self
    }
    
    // Default storyboardIdentifier is its class name
    static var storyboardIdentifier: String {
        return stringFromSwiftClass(Self.self)
    }
    
    // Default storyboardName is 'main'
    static var storyboardName: String {
        return "Main"
    }
}
