//
//  UIImage+SVG.swift
//  WeChat
//
//  Created by Sun on 2021/12/25.
//  Copyright © 2021 TheBoring. All rights reserved.
//

import UIKit
import SVGKit

extension UIImage {
    
    static func svgImage(named: String, fillColor: UIColor? = nil) -> UIImage? {
        if let bundle = Bundle.main.path(forResource: "SVG", ofType: "bundle"),
            let url = Bundle(path: bundle)?.url(forResource: named, withExtension: "svg") {
            let image = SVGKImage(contentsOf: url)
            if let color = fillColor {
                image?.fill(color: color)
            }
            return image?.uiImage.withRenderingMode(.alwaysOriginal)
        }
        return nil
    }
    
    static func image(from color: UIColor, transparent: Bool = true, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        let rect = CGRect(origin: .zero, size: size)
        let path = UIBezierPath(rect: rect)
        UIGraphicsBeginImageContextWithOptions(rect.size, !transparent, UIScreen.main.scale)
        
        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            context.addPath(path.cgPath)
            context.setFillColor(color.cgColor)
            context.fillPath()
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return image
    }
}
