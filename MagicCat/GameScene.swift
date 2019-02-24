//
//  GameScene.swift
//  MagicCat
//
//  Created by Hiten Patel on 2019-02-23.
//  Copyright © 2019 MAD. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    
    
    //MARK:for line stroke
    var mouseStartingPosition:CGPoint = CGPoint(x: 0, y: 0)
    var lineNode = SKShapeNode()
    var line1Node = SKShapeNode()
    var line2Node = SKShapeNode()
    
    //for line-1 -> RED
    var line1_x = -50
    var line1_x1 = -26
    var angel_cat = 0.0
    
    //for line-2 -> BLUE
    var line2_x = 40
    var line2_x1 = 16
    var angle_cat1 = 90.0
    
    //for level-1
    var nodes_level1 = 2;
    
    override func didMove(to view: SKView) {
        
        // initialize delegate
        self.physicsWorld.contactDelegate = self
        
        //configre line
        self.lineNode.lineWidth = 8
        self.lineNode.lineCap = .round
        self.lineNode.strokeColor = UIColor.green
        addChild(lineNode)
        
        
        
        //configre line-1
        self.line1Node.lineWidth = 8
        self.line1Node.lineCap = .round
        self.line1Node.strokeColor = UIColor.red
        addChild(line1Node)
        
        //draw the animation of line-1
        let moveAction = SKAction.moveBy(x: CGFloat(line1_x), y: 0, duration: 2.5)
        let moveAction1 = SKAction.moveBy(x: CGFloat(line1_x1), y: 0, duration:2.5)
        
        let sequence:SKAction = SKAction.sequence([moveAction, moveAction1])
        
        line1Node.run(SKAction.repeatForever(sequence))
         line1()
        
        
//        let angel1 = atan2(CGFloat(line1_x1-line1_x),0.0)
//        var angel1_final = angel1 * 60
        
//        print("angel1:\(angel1 * 60)")
        
       
        
        //configre line-2
        self.line2Node.lineWidth = 8
        self.line2Node.lineCap = .round
        self.line2Node.strokeColor = UIColor.blue
        addChild(line2Node)
        
        line2()
        
        //draw the animation of line-2
        let moveAction_line2 = SKAction.moveBy(x: (CGFloat(line2_x)), y:0 , duration: 2.5)
        
        let moveAction1_line2 = SKAction.moveBy(x: (CGFloat(line2_x1)), y:0 , duration: 2.5)
        
        let sequence1:SKAction = SKAction.sequence([moveAction_line2, moveAction1_line2])
        
        line2Node.run(SKAction.repeatForever(sequence1))
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
       
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let mouseposition = touch.location(in: self)
        
        print("Finger starting position: \(mouseposition)")
        
            self.mouseStartingPosition = mouseposition
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let mouseposition = touch.location(in: self)
        print("Finger Moved position: \(mouseposition)")
        
       // self.orange?.position = mouseposition
        
        //draw a line
        let path = UIBezierPath()
        path.move(to: self.mouseStartingPosition)
        path.addLine(to: mouseposition)
        self.lineNode.path = path.cgPath
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let mouseLocation = touch.location(in: self)
        print("Finger ending position: \(mouseLocation)")
        
        // 1. get the ending position of the finger
        let orangeEndingPosition = mouseLocation
        
        // 2. get the difference between finger start & end
        let diffX = orangeEndingPosition.x - self.mouseStartingPosition.x
        
        let diffY = orangeEndingPosition.y - self.mouseStartingPosition.y
        
        var angel = atan2(diffY,diffX)
        var finalangle = angel * 60
        print("angel is:\(finalangle)")
        
        // 3. throw the orange based on that direction
        
        let direction = CGVector(dx: diffX, dy: diffY)
        
        
        //for line-1
        if((finalangle >= 0.0 && finalangle <= 15.0) ||
            (finalangle <= 0.0 && finalangle >= -15.0)) {
            print("Stright Horizontal Line Drawn")
            finalangle = 0
            }
        else if((finalangle <= 190.0 && finalangle >= 170.0) ||
                (finalangle >= -190.0 && finalangle <= -170.0)){
                print("Stright Horizontal Line Drawn")
                finalangle = 0
            }
            
        //for line-2
            
        else if(finalangle >= 90 && finalangle <= 100) ||
            (finalangle <= 90 && finalangle >= 80){
            print("Staright Vertical Line Drawn")
            finalangle = 90
        }
        else if(finalangle <= -90 && finalangle >= -100) || (finalangle >= -90 && finalangle <= -80) {
            print("Staright Vertical Line Drawn")
            finalangle = 90
        }
        
        else {
            print("Angle out range")
        }
        print("Final Angle Drawn is: \(finalangle)")
        
        //        self.orange?.physicsBody?.isDynamic = true
        
        //        self.orange?.physicsBody?.applyImpulse(direction)
        
        // 5. remove the line form the drawing
        self.lineNode.path = nil
        
        print("Cat Angle \(angel_cat)")
        
        if(angel_cat == Double(finalangle)) {
            self.line1Node.path = nil
            print("Red Line cleared")
            self.childNode(withName: "cat2")?.removeFromParent()
            nodes_level1 = nodes_level1 - 1
        
            
        } else if(angle_cat1 == Double(finalangle)) {
             self.line2Node.path = nil
             print("Blue Line cleared")
            self.childNode(withName: "cat1")?.removeFromParent()
            nodes_level1 = nodes_level1 - 1
        }
        
        
        
        print("nodes_level1: \(nodes_level1)")
        if(nodes_level1 == 0) {
            let message = SKLabelNode(text:"LEVEL COMPLETE!")
            message.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
            message.fontColor = UIColor.red
            message.fontSize = 100
            message.fontName = "AvenirNext-Bold"
            addChild(message)
            print("Next Level")
            
            //redirect to next level from the restart function
            perform(#selector(GameScene.restartGame), with: nil,afterDelay:3)
            
        }
        
    }
    @objc func restartGame() {
        let scene = GameScene(fileNamed:"Level2")
        scene!.scaleMode = scaleMode
        view!.presentScene(scene)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        
        if(nodeA?.name == "player") {
            print("Player hit: \(nodeB?.name)")
        } else if(nodeB?.name == "player") {
            print("Player hit: \(nodeA?.name)")
        }
    }
    
    
    func line1() {
        //draw a line
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 408.206, y: 0))
        path.addLine(to: CGPoint(x:350, y:0))
        self.line1Node.path = path.cgPath
    }
    
    func line2() {
        //draw a line
        let path = UIBezierPath()
        path.move(to: CGPoint(x:-422.193 , y: -80.956))
        path.addLine(to: CGPoint(x: -425.0, y: -400))
        self.line2Node.path = path.cgPath
    }
}
