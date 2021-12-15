//
//  ContactPiece.swift
//  Router
//
//  Created by Sun on 2021/12/15.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit

public protocol ContactPiece: Piece {

    func contacts() -> UIViewController
}
