//
//  ViewController.swift
//  PlayingCard
//
//  Created by Svitlana Dzyuban on 28/6/18.
//  Copyright © 2018 Lana Dzyuban. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var deck = PlayingCardDeck()

    //    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
    //        switch sender.state {
    //        case .ended:
    //            playingCardView.isFacedUp = !playingCardView.isFacedUp
    //        default:
    //            break
    //        }
    //    }

    @IBOutlet var playingCardsViews: [PlayingCardView]!
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehaviour = CardBehaviour(in: animator)
    //@IBOutlet weak var playingCardView: PlayingCardView! {
    //        didSet {
    //            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
    //            swipe.direction = [.left,.right]
    //            playingCardView.addGestureRecognizer(swipe)
    //            let pinch = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecognizedBy:)))
    //            playingCardView.addGestureRecognizer(pinch)
    //        }
    //    }

    //    @objc private func nextCard() {
    //        if let card = deck.draw() {
    //            playingCardView.rank = card.rank.order
    //            playingCardView.suit = card.suit.rawValue
    //        }
    //
    //    }
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        for _ in 0...((playingCardsViews.count+1)/2) {
            if let card = deck.draw() {
                cards += [card, card]
            }
        }
        for cardView in playingCardsViews {
            cardView.isFacedUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehaviour.addItem(cardView)
        }
    }

    private var faceUpCardViews: [PlayingCardView] {
        return playingCardsViews.filter { $0.isFacedUp && !$0.isHidden }
    }

    private var faceUpCardViewsMatched: Bool {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit  == faceUpCardViews[1].suit
    }

    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView {
                cardBehaviour.removeItem(chosenCardView)
                UIView.transition(
                    with: chosenCardView,
                    duration: 0.6,
                    options: [.transitionFlipFromRight],

                    animations: {
                        chosenCardView.isFacedUp = !chosenCardView.isFacedUp
                },

                    completion: { finished in
                        if self.faceUpCardViewsMatched {
                            UIViewPropertyAnimator.runningPropertyAnimator(
                                withDuration: 0.6,
                                delay: 0,
                                options: [],
                                animations: {
                                    self.faceUpCardViews.forEach{
                                        $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                    }
                            },
                                completion: { position in
                                    UIViewPropertyAnimator.runningPropertyAnimator(
                                        withDuration: 0.75,
                                        delay: 0,
                                        options: [],
                                        animations: {
                                            self.faceUpCardViews.forEach{
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                $0.alpha = 0
                                            }
                                    },
                                        completion: { position in
                                            self.faceUpCardViews.forEach{
                                                $0.isHidden = true
                                                $0.alpha = 1
                                                $0.transform = .identity
                                            }
                                    }
                                    )
                            }
                            )
                        } else if self.faceUpCardViews.count >= 2 {
                            self.faceUpCardViews.forEach { cardView in
                                UIView.transition(
                                    with: cardView,
                                    duration: 0.6,
                                    options: [.transitionFlipFromRight],
                                    animations: {
                                        cardView.isFacedUp = false
                                },
                                    completion: { finished in
                                        self.cardBehaviour.addItem(cardView)
                                }
                                )
                            }
                        } else {
                            if !chosenCardView.isFacedUp {
                                self.cardBehaviour.addItem(chosenCardView)
                            }
                        }
                }
                )
            }
        default:
            break
        }
    }
}
