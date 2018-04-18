//
//  CountingScene.swift
//  draganddrop1
//
//  Created by oqbrennw on 2/5/18.
//  Copyright © 2018 oqbrennw. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation

/// Describes object for collision type
struct ColliderType{
    /// Object causing the collision
    static let Object:UInt32 = 1
    /// Bucket that recieves the collision
    static let Bucket:UInt32 = 2
}

/// A list of static objects
private let staticImages = ["pig"]
/// A list of movable objects
private let movableImages = ["apple"]
/// Object that allows device to speek to user
//private let speaker = AVSpeechSynthesizer()

/// Module that renders a level’s current state and maintains its corresponding game logic
class CountingScene: SKScene, SKPhysicsContactDelegate, AVSpeechSynthesizerDelegate {

    /// Sprite that presents the current score
    let scoreText = SKLabelNode(fontNamed: "Arial")
    /// Variable that keeps track of the current store
    var score = 0
    /// The sprite that is currently being touched (if any)
    var selectedNode = SKSpriteNode()
    
    var question = SKLabelNode(fontNamed: "Arial")
    var victory = SKLabelNode(fontNamed: "Arial")
    
    var contactFlag = false
    
    weak var game_delegate:GameViewController?
    
    let button = SKSpriteNode(imageNamed: "turtle")
    
    
    let numApples = arc4random_uniform(1)+2

    
    /// Initialize the scene by NSCoder
    ///
    /// - Parameter coder: coder used to initialize the scene
    required init?(coder aDecorder: NSCoder){
        fatalError("init(coder: has not been implemented")
    }
    
    /// Initialize the scene by size
    ///
    /// - Parameter size: size used to initialize the scene
    override init(size: CGSize) {
        super.init(size: size)
        
    }
    
    /// Called when scene is presented
    ///
    /// - Parameter view: The SKView rendering the scene
    override func didMove(to view: SKView) {
        speakString(text: "Level One")
        self.physicsWorld.contactDelegate = self
        self.backgroundColor = SKColor.cyan
        
        print("height:"+String(describing: size.height))
        scoreText.fontSize = size.height/7.5
        scoreText.text = String(score)
        scoreText.fontColor = SKColor.black
        scoreText.name = "score"
        
        
        //let numApples = arc4random_uniform(11)+1;
        var imageNames = [String]()
        
        //let questionTextSpoken = "Please put " + String(numApples) + "apples into the bucket"
        let questionTextWriten = "Feed the pig " + String(numApples) + " apples"
        question.text = questionTextWriten
        question.fontSize = 64
        question.fontColor = .white
        question.horizontalAlignmentMode = .center
        question.verticalAlignmentMode = .center
        question.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.9)
        question.isAccessibilityElement = true
        question.accessibilityLabel = questionTextWriten
        question.name = "question"
        //question.accessibilityLabel = questionTextSpoken
        
        
        for i in 0..<staticImages.count{
            imageNames.append(staticImages[i])
        }
        for _ in 0..<numApples{
            imageNames.append("apple")
        }
        var objectOffsetX = 1.5*((Double(numApples)/4.0)+1.2);
        var objectOffsetY = 5.0;
        let offsetFractionRight = CGFloat(5.45/7.0)
        scoreText.position = CGPoint(x: size.width * offsetFractionRight, y: size.height/4)
        self.addChild(scoreText)
        button.position = CGPoint(x: (size.width * 0.08), y: size.height * 0.95)
        button.name = "menu"
        button.isAccessibilityElement = true
        button.accessibilityLabel = "back to menu"
        
        
        //let imageNames = ["bucket2","apple","apple","apple","apple","apple"]
        for i in (0..<imageNames.count) {
            let imageName = imageNames[i]

            let sprite = SKSpriteNode(imageNamed: imageName)
            sprite.isAccessibilityElement = true
            sprite.name = imageName
            
            
            if !staticImages.contains(imageName){
                sprite.accessibilityLabel = "apple"
                sprite.size = CGSize(width: 90.0, height: 90.0)
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width/4,
                                                                       sprite.size.height/4))
                sprite.physicsBody?.affectedByGravity = false
                sprite.physicsBody?.categoryBitMask = ColliderType.Object
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.contactTestBitMask = 0
                let offsetFractionObject = CGFloat(objectOffsetX)/10
                sprite.position = CGPoint(x: size.width * offsetFractionObject, y: (size.height/(1.25))-(1.1*(sprite.size.height)*CGFloat(objectOffsetY)))
            }
            else{
                sprite.accessibilityLabel = "pig"
                sprite.zPosition = -1
                sprite.size = CGSize(width: 210.0, height: 210.0)
                sprite.physicsBody = SKPhysicsBody(circleOfRadius: max(sprite.size.width/4,
                                                                       sprite.size.height/4))
                sprite.physicsBody?.affectedByGravity = false
                sprite.physicsBody?.categoryBitMask = ColliderType.Bucket
                sprite.physicsBody?.collisionBitMask = 0
                sprite.physicsBody?.contactTestBitMask = ColliderType.Object
                
                sprite.physicsBody?.affectedByGravity = false
                sprite.position = CGPoint(x: size.width * offsetFractionRight, y: (size.height / 2))
            }
            objectOffsetY -= 1.5;
            if i%4 == 0 {
                objectOffsetX -= 1.5
                objectOffsetY = 5.0
            }
            self.addChild(sprite)
           
            
        }
        //let offsetFraction = (CGFloat(imageNames.count) + 1.0)/(CGFloat(imageNames.count+1) + 1.0)
        self.addChild(button)
        self.addChild(question)
    }
    
    /// Called when screen is touched
    ///
    /// - Parameters:
    ///   - touches: Set of touches submitted by event
    ///   - event: UIEvent triggering the fucntion
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(_:positionInScene)
            if (touchedNode is SKSpriteNode){
                if(touchedNode.name == "menu") {
                    self.removeAllActions()
                    self.removeAllChildren()
                    //(scene!.view!.window?.rootViewController as! UINavigationController).dismiss(animated: false, completion: nil)
                    self.game_delegate?.backToLevel()
                }
                else {
                    onSpriteTouch(touchedNode: touchedNode as! SKSpriteNode)
                }
            }
        }
    }
    
    /// Called when contact between two objects is initiated
    ///
    /// - Parameter contact: The object that refers to the contact caused by the two objects
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            
            speakString(text: "On pig")
            print("On pig")
            contactFlag = true
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ColliderType.Bucket && contact.bodyB.categoryBitMask == ColliderType.Object) {
            
            speakString(text: "Off pig")
            print("Off pig")
            contactFlag = false
        }
    }
    
    
    /// Update 
    func incrementScore(){
        score += 1
        scoreText.text = String(score)
        print("Added apple")
        print(score.description + " apples")
        if(score == 1){
            speakString(text: score.description + " apple")
        } else {
            speakString(text: score.description + " apples")
        }
        contactFlag = false
//        selectedNode.isHidden = true
        selectedNode.isAccessibilityElement = false
        selectedNode.isUserInteractionEnabled = false
        selectedNode.removeFromParent()
        print(score)
        if(score == numApples){
            onVictory()
        }
    }
    
    func onVictory(){
        var backButton = SKSpriteNode()
        for child in self.children {
            if child.name == "apple" || child.name == "pig" || child.name == "score" || child.name == "question" {
//                child.isHidden = true
                child.isAccessibilityElement = false
                child.isUserInteractionEnabled = false
                child.removeFromParent()
            } else if child.name == "menu" {
                backButton = child as! SKSpriteNode
//                child.isHidden = true
//                child.isAccessibilityElement = false
//                child.isUserInteractionEnabled = false
                child.removeFromParent()
            }
        }
        victory.text = "Good Job!"
        victory.fontSize = 180
        victory.fontColor = .white
        victory.horizontalAlignmentMode = .center
        victory.verticalAlignmentMode = .center
        victory.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        victory.isAccessibilityElement = true
        victory.accessibilityLabel = "Good Job!"
        speakString(text: "Good Job!")
        self.addChild(victory)
        self.addChild(backButton)
    }
    
    
    
    
    /// Converts degrees to radians
    ///
    /// - Parameter degree: value in degrees
    /// - Returns: converted value in radians
    func degToRad(degree: Double) -> CGFloat {
        return CGFloat(Double(degree) / 180.0 * Double.pi)
    }
    
    /// Clears out wobble action from selected node and makes touched node wobble
    ///
    /// - Parameter touchedNode: sprite being touched
    func onSpriteTouch(touchedNode: SKSpriteNode) {
        selectedNode.run(SKAction.rotate(toAngle: 0.0, duration: 0.1))
        selectedNode.removeAllActions()
        selectedNode = touchedNode
        if movableImages.contains(touchedNode.name!) && !touchedNode.hasActions() {
            let sequence = SKAction.sequence([SKAction.rotate(toAngle: degToRad(degree: -2.0), duration: 0.1),
                                              SKAction.rotate(toAngle: 0.0, duration: 0.1),
                                              SKAction.rotate(toAngle: degToRad(degree: 2.0), duration: 0.1)])
            selectedNode.run(SKAction.repeatForever(sequence))
        }
    }
    
    /// Handles single finger drag on device
    ///
    /// - Parameters:
    ///   - touches: Set of touches that caused event
    ///   - event: UIEvent that triggered function
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            //Drag sprite to new position if it is being touched
            let nodePosition = selectedNode.position
            let currentPosition = touch.location(in: self)
            let previousPosition = touch.previousLocation(in: self)
            let translation = CGPoint(x: currentPosition.x - previousPosition.x, y: currentPosition.y - previousPosition.y)
            if  ((self.atPoint(currentPosition).isEqual(selectedNode) || self.atPoint(previousPosition).isEqual(selectedNode)
                ) && movableImages.contains(selectedNode.name!)){
                selectedNode.position = CGPoint(x: nodePosition.x + translation.x, y: nodePosition.y + translation.y)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(contactFlag){
            incrementScore()
        }
    }
    
    /// Prompts text to be spoken out by device
    ///
    /// - Parameter text: text to be spoken
    func speakString(text: String) {
        //let Utterance = AVSpeechUtterance(string: text)
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, text)
        
        //speaker.speak(Utterance)
    }
    
    deinit {
        print("Deinit CountingScene")
    }
    
}

