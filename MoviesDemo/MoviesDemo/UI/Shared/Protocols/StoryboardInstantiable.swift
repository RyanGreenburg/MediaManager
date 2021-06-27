//
//  StoryboardInstantiable.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/14/21.
//

import UIKit

protocol StoryboardInstantiable {
    static func instantiate() -> Self
}

extension StoryboardInstantiable where Self: UIViewController {
    static func instantiate() -> Self {
        
        let fullName = NSStringFromClass(self)

        let className = fullName.components(separatedBy: ".")[1]

        let storyboard = UIStoryboard(name: className, bundle: Bundle.main)

        return storyboard.instantiateInitialViewController() as! Self
    }
}
