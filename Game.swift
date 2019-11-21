//
//  Game.swift
//  FruitCatcher
//
//  Created by Alexandra Plukis on 11/8/19.
//  Copyright © 2019 ASU Swift Workshops. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit


class Game: SKScene, SKPhysicsContactDelegate {
    
    // setting up variables that multiple functions need to access
    var points: Int = 0
    var basket: SKSpriteNode!
    var ground: SKSpriteNode!
    var pointsLabel: SKLabelNode!
    var randomSourse = GKLinearCongruentialRandomSource.sharedRandom()
    var fruitTextures: [SKTexture] = []
    
    // the set up for the entire game happens here
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        //setColors()
        createSceneContent()
    }
    
    // initializing all of the nodes used in the game
    func createSceneContent() {
        backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        ground = SKSpriteNode(color: UIColor(red: (54.0 / 255.0), green: (64.0 / 255.0), blue: (18.0 / 255.0), alpha: 1.0), size: CGSize(width: frame.width, height: frame.height * 0.05))
        let groundBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.position = CGPoint(x: frame.width / 2.0, y: 0.0)
        groundBody.isDynamic = false
        groundBody.affectedByGravity = false
        ground.physicsBody = groundBody
        ground.name = "Ground"
        addChild(ground)
        
        // the baset that catches all of the water drops
        let basketTexture = SKTexture(imageNamed: "basket.png")
        basket = SKSpriteNode(texture: basketTexture)
        basket.position = CGPoint(x: frame.midX, y: frame.minY + 0.05 * frame.height)
        let basketBody = SKPhysicsBody(rectangleOf: basket.size)
        basketBody.isDynamic = false
        basketBody.affectedByGravity = false
        basketBody.usesPreciseCollisionDetection = true
        basket.physicsBody = basketBody
        basket.name = "Basket"
        addChild(basket)
        let xConstraint = SKConstraint.positionX(SKRange(lowerLimit: basket.size.width / 2, upperLimit: frame.width - (basket.size.width / 2)))
        basket.constraints = [xConstraint]
        
        // next five textures are for the falling droplets so they look like fruit, they are all saved in fruitTextures
        let appleTexture = SKTexture(imageNamed: "Apple Photo.png")
        let bananaTexture = SKTexture(imageNamed: "Banana Photo.png")
        let grapeTexture = SKTexture(imageNamed: "Grape Photo.png")
        let peachTexture = SKTexture(imageNamed: "Peach Photo.png")
        let pineappleTexture = SKTexture(imageNamed: "Pineapple Photo.png")
        
        fruitTextures = [appleTexture, bananaTexture, grapeTexture, peachTexture, pineappleTexture]
        
    
        // points label
        pointsLabel = SKLabelNode(fontNamed: "Helvetica Bold")
        pointsLabel.numberOfLines = 3
        pointsLabel.text = "\(points)"
        pointsLabel.fontColor = UIColor.black
        pointsLabel.fontSize = CGFloat(frame.height * 0.04)
        pointsLabel.position = CGPoint(x: frame.maxX - (size.width * 0.1), y: frame.maxY - (size.height * 0.1))
        pointsLabel.name = "Points Label"
        addChild(pointsLabel)
    }
     
    // continually update the scene to add randomly falling raindrops
    override func update(_ currentTime: TimeInterval) {
        let choice = randomSourse.nextUniform()
        if (choice < 0.02) {
            let x = CGFloat(randomSourse.nextUniform()) * frame.width
            let y = frame.height
            addFruit(at: CGPoint(x: x, y: y))
        }
    }
   
    // add falling fruit to the scene that will collide with everything
    func addFruit(at location: CGPoint) {
        let random = Int(randomSourse.nextUniform() * 10.0)
        let fruitChoice = random % fruitTextures.count
        let fruitTexture = fruitTextures[fruitChoice]
        let fruit = SKSpriteNode(texture: fruitTexture)
        fruit.position = location
        let fruitBody = SKPhysicsBody(rectangleOf: fruit.size)
        
        fruitBody.isDynamic = true
        fruitBody.affectedByGravity = false
        fruitBody.contactTestBitMask = 0xffffffff // hit EVERYTHING
        fruit.physicsBody = fruitBody
        fruit.run(SKAction.move(to: CGPoint(x: fruit.position.x, y: 10.0), duration: TimeInterval(floatLiteral: 2.0)))
        fruit.name = "Fruit"
        addChild(fruit)
        
        
    }



    // if a physics contact begins, decide which collision it was and then 
    // create the necessary results
    func didBegin(_ contact: SKPhysicsContact) { // called whenever two physics bodies hit each other 
        // the two bodies are bodyA and bodyB
        guard let nodeA = contact.bodyA.node, let nodeB = contact.bodyB.node else { return }
        guard let nameA = nodeA.name, let nameB = nodeB.name else { return }
        
        if (nameA == "Basket" && nameB == "Fruit") {
            nodeB.run(SKAction.removeFromParent())
            pointsLabel.text = String(points + 2)
            points += 2
            evaluatePoints()
        } 
        else if (nameB == "Basket" && nameA == "Fruit") {
            nodeA.run(SKAction.removeFromParent())
            pointsLabel.text = String(points + 2)
            points += 2
            evaluatePoints()
        } 
        else if (nameA == "Ground" && nameB == "Fruit") { // symmetric case of above if statement
            nodeB.run(SKAction.removeFromParent())
            pointsLabel.text = String(points - 1)
            points -= 1
            evaluatePoints()
        }
        else if (nameB == "Ground" && nameA == "Fruit") { // symmetric case of above if statement
            nodeA.run(SKAction.removeFromParent())
            pointsLabel.text = String(points - 1)
            points -= 1
            evaluatePoints()
        }
        
    }
//    
    // evaluate points to decide if we should keep playing or move to the winning intro screen
    func evaluatePoints() {
        if (points >= 20) {
            if let view = view {
                let intro = Intro(size: size)
                let transition = SKTransition.fade(withDuration: 3.0)
                view.presentScene(intro, transition: transition)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let increment = CGFloat(frame.width * 0.01)
        let duration = 0.09
        let events = event?.allTouches
        let touchEvent = events?.first
        let touchLocation = touchEvent?.location(in: self)
        let location = CGPoint(x: touchLocation!.x, y: touchLocation!.y)
        if (location.x > frame.midX) {
            let action = SKAction.moveBy(x: increment, y: 0, duration: duration)
            action.timingMode = .easeInEaseOut
            basket.run(action)
        }
        else {
            let action = SKAction.moveBy(x: -increment, y: 0, duration: duration)
            action.timingMode = .easeInEaseOut
            basket.run(action)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let increment = CGFloat(frame.width * 0.01)
        let duration = 0.09
        let events = event?.allTouches
        let touchEvent = events?.first
        let touchLocation = touchEvent?.location(in: self)
        let location = CGPoint(x: touchLocation!.x, y: touchLocation!.y)
        if (location.x > frame.midX) {
            let action = SKAction.moveBy(x: increment, y: 0, duration: duration)
            action.timingMode = .easeInEaseOut
            basket.run(action)
        }
        else {
            let action = SKAction.moveBy(x: -increment, y: 0, duration: duration)
            action.timingMode = .easeInEaseOut
            basket.run(action)
        }
    } 
}


