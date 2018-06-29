//
//  ViewController.swift
//  PlayingCard
//
//  Created by Svitlana Dzyuban on 28/6/18.
//  Copyright © 2018 Lana Dzyuban. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var deck = PlayingCardDeck()

        for _ in 1...40 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
    }
}
