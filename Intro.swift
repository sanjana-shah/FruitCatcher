//
//  Intro.swift
//  FruitCatcher
//
//  Created by Alexandra Plukis on 11/8/19.
//  Copyright © 2019 ASU Swift Workshops. All rights reserved.
//

import Foundation
import SpriteKit

class Intro: SKScene {
    
    var playButton: SKLabelNode!
    
    // set up the scene to display the intro screen
    override func didMove(to view: SKView) {
        let r = CGFloat(54.0 / 255.0)
        let g = CGFloat(64.0 / 255.0)
        let b = CGFloat(18.0 / 255.0)
        let a = CGFloat(1.0)
        backgroundColor = SKColor(red: r, green: g, blue: b, alpha: a)
        createSceneContent()
    }
    
    // here we initialize all of the nodes used in the scene
    func createSceneContent() {
        //green color elements
        let r = CGFloat(54.0 / 255.0)
        let g = CGFloat(64.0 / 255.0)
        let b = CGFloat(18.0 / 255.0)
        let a = CGFloat(1.0)
        
        // the welcome label that welcomes the user to play the game
        let textNode = SKLabelNode(fontNamed: "Helvetica Bold")
        textNode.text = "push to play\nthe rain game!"
        textNode.numberOfLines = 3
        textNode.fontSize = CGFloat(frame.height * 0.05)
        textNode.horizontalAlignmentMode = .center
        textNode.position = CGPoint(x: (size.width / 2.0), y: (size.height / 2) + (size.height * 0.1))
        textNode.name = "Welcome Label"
        addChild(textNode)
        
        // the play button background
        let playRect = SKSpriteNode(color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), size: CGSize(width: (size.height * 0.1), height: (size.height * 0.08)))
        playRect.position = CGPoint(x: (size.width / 2.0), y: (size.height / 2) + (size.height * 0.01))
        playRect.name = "Play Rectangle"
        addChild(playRect)
        
        // the play button label
        playButton = SKLabelNode(fontNamed: "Helvetica Bold")
        playButton.text = "play!"
        textNode.fontSize = CGFloat(frame.height * 0.05)
        playButton.fontColor = UIColor(red: r, green: g, blue: b, alpha: a)
        playButton.position = CGPoint(x: size.width / 2.0, y: (size.height / 2))
        playButton.name = "Play Label"
        addChild(playButton)
        
    }

    
    // when the player presses the button, we want to start the game with a Game scene
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let events = event?.allTouches
        let touchEvent = events?.first
        let touchLocation = touchEvent?.location(in: self)
        let location = CGPoint(x: touchLocation!.x, y: touchLocation!.y)
        if playButton.contains(location) {
            if let view = view {
                let game = Game(size: size)
                let transition = SKTransition.fade(withDuration: 1.0)
                view.presentScene(game, transition: transition)
                }
            }
        }
        
}

