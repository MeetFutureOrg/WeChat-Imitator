//
//  Reusable.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit

// MARK: Protocol definition

/// Make your `UITableViewCell` and `UICollectionViewCell` subclasses
/// conform to this protocol when they are *not* NIB-based but only code-based
/// to be able to dequeue them in a type-safe manner
protocol Reusable: AnyObject {
  /// The reuse identifier to use when registering and later dequeuing a reusable cell
  static var reuseIdentifier: String { get }
}

// MARK: - Default implementation

extension Reusable {
  /// By default, use the name of the class as String for its reuseIdentifier
  static var reuseIdentifier: String {
    return String(describing: self)
  }
}
