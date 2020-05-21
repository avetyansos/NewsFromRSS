//
//  Storyaboard+Instantiate.swift
//  SmartClickAITest
//
//  Created by Sos Avetyan on 5/21/20.
//  Copyright © 2020 Sos Avetyan. All rights reserved.
//

import Foundation
import UIKit

protocol StringConvertible {
    var rawValue: String { get }
}

protocol Storyboardable: class {
    static var storyboardName: StringConvertible { get }
}

extension Storyboardable {
    static func instantiateFromStoryboard() -> Self {
        return instantiateFromStoryboardHelper()
    }

    private static func instantiateFromStoryboardHelper<T>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}

// MARK: - String extension
extension String: StringConvertible {
    var rawValue: String {
        return self
    }
}
