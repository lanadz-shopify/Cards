//
//  Int.swift
//  PlayingCard
//
//  Created by Svitlana Dzyuban on 29/6/18.
//  Copyright © 2018 Lana Dzyuban. All rights reserved.
//
import UIKit
import Foundation

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(-self)))
        } else {
            return 0
        }
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return CGFloat(arc4random_uniform(UInt32(-self)))
        } else {
            return 0
        }
    }
}
