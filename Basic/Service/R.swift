//
//  R.swift
//  Basic
//
//  Created by pineone on 2021/12/13.
//

import UIKit

struct R {
    struct Color {
        struct Base {}
    }
    
    struct String {
        struct Home {}
    }
    
    struct Image {
        struct Navi {}
    }
}

extension R.Image.Navi {
    static let btnCommonBefore = UIImage(named: "BtnCommonBefore")
    static let btnClose = UIImage(named: "btnClose")
    static let btnCommonSettingsNor = UIImage(named: "btnCommonSettingsNor")
    static let btnCommonMoreNor = UIImage(named: "btnCommonMoreNor")
    static let delNor = UIImage(named: "delNor")
}

extension R.Color {
    /// #00000, rgb 0 0 0
    static let white_1000 = UIColor(named: "white_1000")
    static let white_1005 = UIColor(named: "white_1005")
    /// #3DACF7 61 172 247
    static let blue = UIColor(61, 172, 247)
}
