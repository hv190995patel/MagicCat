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
    
    var cat1 = SKSpriteNode(imageNamed: "cat")
    var cat2 = SKSpriteNode(imageNamed: "cat")
    var player = SKSpriteNode(imageNamed: "player")
    
    
    
    //MARK:for drawing stroke
    var mouseStartingPosition:CGPoint = CGPoint(x: 0, y: 0)
    var lineNode = SKShapeNode()
    var line1Node = SKShapeNode()
    var line2Node = SKShapeNode()
    var line3Node = SKShapeNode()
    
    var livesNode = SKLabelNode()
    var scoreNode = SKLabelNode()
    
    var restartNode = SKLabelNode()
    //GAME STATES
        //drawing circles for extra life
        var circleShown = false
    
       //for line-1 -> RED
        var line1_x = -50
        var line1_x1 = -26
        var angel_cat = 0.0
        var moveToLine1X = 408.206
        var moveToLine1Y = 0.0
        var addLine1X = 350.0
        var addLine1Y = 0.0
    
        //for line-2 -> BLUE
        var line2_x = 40
        var line2_x1 = 16
        var angle_cat1 = 90.0
        var moveToLine2X = -422.193
        var moveToLine2Y = 80.0
        var addLine2X = -422.193
        var addLine2Y = 0.0
    
        //for line 3 -->blue
        var line3_x = 140
        var line3_x1 = 16
        var angle_random = 90.0
    
        //for total catNodes of level-1
        var nodes_level1 = 2;
    
        var randomX = 0
        var randomY = 0
    
        //let randomfunc = [line1,line2]
        //total  lives
        var lives = 2
        var score = 0
    
    //    randomIndex
    override func didMove(to view: SKView) {
        if(lives == 0) {
            
        } else {
           
            // initialize delegate
            self.physicsWorld.contactDelegate = self
            
            
            //configure drawing line
            self.lineNode.lineWidth = 8
            self.lineNode.lineCap = .round
            self.lineNode.strokeColor = UIColor.green
            addChild(lineNode)
            
            //configre lives
            self.livesNode.text = "Lives:\(lives)"
            self.livesNode.position.x = -539
            self.livesNode.position.y = 321
            self.livesNode.fontSize = 50
            self.livesNode.fontColor = UIColor.red
            self.livesNode.fontName = "AvenirNext-Bold"
            addChild(livesNode)
            
            //configre score
            self.scoreNode.text = "Score:\(score)"
            self.scoreNode.position.x = -539
            self.scoreNode.position.y = 225.361
            self.scoreNode.fontSize = 50
            self.scoreNode.fontColor = UIColor.red
            self.scoreNode.fontName = "AvenirNext-Bold"
            addChild(scoreNode)
            
            //configre score
            self.restartNode.text = "RESTART"
            self.restartNode.position.x = 560
            self.restartNode.position.y = 327
            self.restartNode.fontSize = 50
            self.restartNode.fontColor = UIColor.red
            self.restartNode.fontName = "AvenirNext-Bold"
            addChild(restartNode)
            
           
            //configre line-1
            line1()
            //configre line-2
            line2()
            //            //spawn cats every 3 seconds
            //            //spawncats()
            
            //        run(SKAction.sequence([
            //            SKAction.run() {[weak self] in self?.spawncats()},
            //            SKAction.wait(forDuration: 5)
            //            ]))
            //line3()
            
            //add music
//            let playSound = SKAction.playSoundFileNamed("hauntedhouse", waitForCompletion: false)
//            run(playSound)
            
        }
        
        
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let playSound = SKAction.playSoundFileNamed("hauntedhouse", waitForCompletion: false)
        run(playSound)
        
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let mouseposition = touch.location(in: self)
        print("Finger starting position: \(mouseposition)")
        self.mouseStartingPosition = mouseposition
        circleposition(mouseposition:mouseposition)
        
        if(restartNode.contains(mouseposition)){
            print("restart button is pressed")
            perform(#selector(GameScene.restartGame),with: nil, afterDelay: 1)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let mouseposition = touch.location(in: self)
        print("Finger Moved position: \(mouseposition)")
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
        let drawingEndingPosition = mouseLocation
        // 2. get the difference between finger start & end
        let diffX = drawingEndingPosition.x - self.mouseStartingPosition.x
        let diffY = drawingEndingPosition.y - self.mouseStartingPosition.y
        
        if(diffX == 0.0 && diffY == 0.0){
            let direction = CGVector(dx: diffX, dy: diffY)
            return
        }
        else {
            //3.find angle between original coordinates and ending coordinates
            var angle = atan2(diffY,diffX)
            
            var finalangle = angle * 60
            print("angle is:\(finalangle)")
            // 4. draw a line based on that coordinates
           
            let direction = CGVector(dx: diffX, dy: diffY)
            //horizontal angle for horizontal line if angle is nearer to 180 and 0 ...finalangle will be consider as 0.
            if((finalangle >= 0.0 && finalangle <= 15.0) ||
                (finalangle <= 0.0 && finalangle >= -15.0)) {
                print("Stright Horizontal Line Drawn")
                finalangle = 0
            }else if((finalangle <= 190.0 && finalangle >= 170.0) ||
                (finalangle >= -190.0 && finalangle <= -170.0)){
                print("Stright Horizontal Line Drawn")
                finalangle = 0
            }
                //vertical angle for vertical line if angle is nearer to 90 and -90 ...finalangle will be consider as 90.
            else if(finalangle >= 90 && finalangle <= 100) ||
                (finalangle <= 90 && finalangle >= 80){
                print("Staright Vertical Line Drawn")
                finalangle = 90
            }else if(finalangle <= -90 && finalangle >= -100) || (finalangle >= -90 && finalangle <= -80) {
                print("Staright Vertical Line Drawn")
                finalangle = 90
            }else {
                print("Angle out range")
            }
            print("Final Angle Drawn is: \(finalangle)")
            print("Cat Angle \(angel_cat)")
            // 5. remove the line form the drawing
            self.lineNode.path = nil
            
            //check if catangle and finalangle matches
            if(angel_cat == Double(finalangle)) {
                //remove line and cat from parent if angle are same
                self.line1Node.path = nil
                print("Red Line cleared")
                self.childNode(withName: "cat2")?.removeFromParent()
                self.score = score + 10
                self.scoreNode.text = "score:\(score)"
                nodes_level1 = nodes_level1 - 1
            }
            else if(angle_cat1 == Double(finalangle)) {
                self.line2Node.path = nil
                print("Blue Line cleared")
                self.childNode(withName: "cat1")?.removeFromParent()
                self.score = score + 10
                self.scoreNode.text = "score:\(score)"
                nodes_level1 = nodes_level1 - 1
            }
            //check for total nodes of the scene
            print("nodes_level1: \(nodes_level1)")
            totalnodes()
        }
        
    }
    func totalnodes(){
        //if totalnodes euqals to 0 then change the level
        if(nodes_level1 == 0) {
            let message = SKLabelNode(text:"LEVEL COMPLETE!")
            message.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
            message.fontColor = UIColor.red
            message.fontSize = 100
            message.fontName = "AvenirNext-Bold"
            addChild(message)
            print("Next Level")
            
            //redirect to next level from the restart function
            perform(#selector(GameScene.nextLevel), with: nil,afterDelay:2)
            
        }
    }
    @objc func nextLevel() {
        let scene = GameScene(fileNamed:"Level2")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
    
     func gameOver() {
        let GameOvermessage = SKLabelNode(text:"GAMEOVER!")
        GameOvermessage.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        GameOvermessage.fontColor = UIColor.magenta
        GameOvermessage.fontSize = 100
        GameOvermessage.fontName = "AvenirNext-Bold"
        addChild(GameOvermessage)
        
        perform(#selector(GameScene.restartGame), with: nil,afterDelay: 0)
        
    }
    
    @objc func restartGame() {
        let scene = GameScene(fileNamed:"GameScene")
        let  transition = SKTransition.flipVertical(withDuration: 2)
        scene!.scaleMode = .aspectFill
        view!.presentScene(scene!,transition:transition)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeA = contact.bodyA.node
        let nodeB = contact.bodyB.node
        //self.physicsWorld.gravity = CGVector(dx: -0.138, dy: 125)
        
        if(lives == 0) {
            print("Game Over")
            //redirect to next level from the restart function
            gameOver()
       
        } else {
            
            
            
            if(nodeA?.name == "player") {
                print("Player hit: \(nodeB?.name)")
                if(nodeB?.name == "cat1" || nodeB?.name == "cat2") {
                    detectCollision()
                    
                }
                
            } else if(nodeB?.name == "player") {
                print("Player hit: \(nodeA?.name)")
                
                if(nodeA?.name == "cat1" || nodeA?.name == "cat2") {
                    //start at origin
                    detectCollision()
                }
            }
            
            if(nodeA?.name == "restart") {
                print("Restart Pressed")
            } else if(nodeB?.name == "restart") {
                print("Restrt Pressed")
            }
        }
        
        
    }
    
    func detectCollision() {
        
        
        
        //delete cat-1
        self.childNode(withName: "cat1")?.removeFromParent()
        
        //for line-1
        let path = UIBezierPath()
        path.move(to: CGPoint(x: moveToLine1X, y: moveToLine1Y))
        path.addLine(to: CGPoint(x:addLine1X, y:addLine1Y))
        self.line1Node.path = path.cgPath
        
        let path2 = UIBezierPath()
        path2.move(to: CGPoint(x:moveToLine2X , y: moveToLine2Y))
        path2.addLine(to: CGPoint(x: addLine2X, y: addLine2Y))
        self.line2Node.path = path2.cgPath
        
        cat1.position = CGPoint(x: CGFloat(-422.193), y: CGFloat(-80.956))
        
        //hitbox for randomCAT
        let bodysize = CGSize(width: cat1.size.width, height: cat1.size.height)
        cat1.physicsBody = SKPhysicsBody(rectangleOf: bodysize)
        cat1.physicsBody?.isDynamic = false
        cat1.name = "cat1"
        addChild(cat1)
        
        let Cat1Movement1 = SKAction.move(to: CGPoint(x: -20, y: 0), duration: 20)
        cat1.run(Cat1Movement1)
        let Cat1Movement2 = SKAction.move(to: CGPoint(x: -10, y: 0), duration: 20)
        cat1.run(Cat1Movement2)
        
        
        
        self.childNode(withName: "cat2")?.removeFromParent()
        
        cat2.position = CGPoint(x: CGFloat(408.206), y: CGFloat(-98.531))
        
        //hitbox for randomCAT
        let cat2hitbox = CGSize(width: cat2.size.width, height: cat2.size.height)
        cat2.physicsBody = SKPhysicsBody(rectangleOf: cat2hitbox)
        cat2.physicsBody?.isDynamic = false
        cat2.name = "cat2"
        addChild(cat2)
        
        
        
        let Cat2Movement1 = SKAction.move(to: CGPoint(x: -26, y: 0), duration: 20)
        cat2.run(Cat2Movement1)
        let Cat2Movement2 = SKAction.move(to: CGPoint(x: 20, y: 0), duration: 20)
        cat2.run(Cat2Movement2)
        lives = lives - 1
        self.livesNode.text = "Lives:\(lives)"
        print("total :\(lives)")
        
        if(lives == 1) {
            print("DID BEGIN lIVES")
            getLives()
        }
    }
    
    func line1() {
        print("line 1 function is called!!!")
        self.line1Node.lineWidth = 8
        self.line1Node.lineCap = .round
        self.line1Node.strokeColor = UIColor.red
        self.line1Node.name = "line1Node"
        addChild(line1Node)
        
        //draw the animation of line-1
        let moveAction = SKAction.moveBy(x: CGFloat(line1_x), y: 0, duration: 2.5)
        let moveAction1 = SKAction.moveBy(x: CGFloat(line1_x1), y: 0, duration:2.5)
        
        let sequence:SKAction = SKAction.sequence([moveAction, moveAction1])
        
        line1Node.run(SKAction.repeatForever(sequence))
        //draw a line
        let path = UIBezierPath()
        path.move(to: CGPoint(x: moveToLine1X, y: moveToLine1Y))
        path.addLine(to: CGPoint(x:addLine1X, y:addLine1Y))
        self.line1Node.path = path.cgPath
        
        
        //self.line2Node.path = path.cgPath
    }
    
    func line2() {
        print("line 2 function is called!!!")
        self.line2Node.lineWidth = 8
        self.line2Node.lineCap = .round
        self.line2Node.strokeColor = UIColor.blue
        self.line2Node.name = "line2Node"
        addChild(line2Node)
        //draw the animation of line-2
        let moveAction_line2 = SKAction.moveBy(x: (CGFloat(line2_x)), y:0 , duration: 2.5)
        
        let moveAction1_line2 = SKAction.moveBy(x: (CGFloat(line2_x1)), y:0 , duration: 2.5)
        
        let sequence1:SKAction = SKAction.sequence([moveAction_line2, moveAction1_line2])
        
        line2Node.run(SKAction.repeatForever(sequence1))
        
        //draw a line
        let path = UIBezierPath()
        path.move(to: CGPoint(x:moveToLine2X , y: moveToLine2Y))
        path.addLine(to: CGPoint(x: addLine2X, y: addLine2Y))
        self.line2Node.path = path.cgPath
        
    }
    
    func circleposition(mouseposition: CGPoint){
        var circle = SKShapeNode(circleOfRadius: 20)
        circle.position = mouseposition
        circle.name = "circle"
        circle.strokeColor = SKColor.red
        circle.glowWidth = 1.0
        circle.fillColor = SKColor.clear
        self.addChild(circle)
        
    }
    func spawncats(){
        var cat = SKSpriteNode(imageNamed: "cat")
        
        randomX = Int(arc4random_uniform(UInt32(size.width)))
        randomY = Int(arc4random_uniform(UInt32(size.height)))
        cat.position = CGPoint(x: CGFloat(randomX), y: CGFloat(randomY))
        
        //hitbox for randomCAT
        let bodysize = CGSize(width: cat.size.width, height: cat.size.height)
        cat.physicsBody = SKPhysicsBody(rectangleOf: bodysize)
        cat.physicsBody?.isDynamic = false
        cat.name = "randomcat"
        
        addChild(cat)
        //line3()
        print("randomX\(randomX)")
        print("randomy\(randomY)")
        let CatMovement = SKAction.move(to: CGPoint(x: -0.138, y: -125), duration: 20)
        cat.run(CatMovement)
        
    }
    
    func line3(){
        self.line3Node.lineWidth = 8
        self.line3Node.lineCap = .round
        self.line3Node.strokeColor = UIColor.blue
        addChild(line3Node)
        //draw the animation of line-2
        let moveAction_line3 = SKAction.moveBy(x: (CGFloat(line3_x)), y:0 , duration: 2.5)
        
        let moveAction1_line3 = SKAction.moveBy(x: (CGFloat(line3_x1)), y:0 , duration: 2.5)
        
        let sequence1:SKAction = SKAction.sequence([moveAction_line3, moveAction1_line3])
        
        line3Node.run(SKAction.repeatForever(sequence1))
        //draw a line
        let path = UIBezierPath()
        path.move(to: CGPoint(x:randomX , y: randomY))
        path.addLine(to: CGPoint(x: 0, y: randomY))
        self.line3Node.path = path.cgPath
        
    }
    
    func getLives() {
        
            randomX = Int(arc4random_uniform(UInt32(size.width)))
            randomY = Int(arc4random_uniform(UInt32(size.height)))
            
            
            var circle = SKShapeNode(circleOfRadius: 20)
            print("Circle Drawn")
            circle.position.x = CGFloat(randomX)
            circle.position.y = CGFloat(randomY + 200)
            circle.name = "circle"
            circle.strokeColor = SKColor.red
            circle.glowWidth = 1.0
            circle.fillColor = SKColor.clear
            circle.zPosition = 1
            self.addChild(circle)
            let CircleMovement = SKAction.move(to: CGPoint(x: self.player.position.x, y: self.player.position.y), duration: 8)
            circle.run(CircleMovement)
            
            var cat = SKSpriteNode(imageNamed: "cat")
            
        
            cat.position = CGPoint(x: CGFloat(randomX), y: CGFloat(randomY))
            
            //hitbox for randomCAT
            let bodysize = CGSize(width: cat.size.width, height: cat.size.height)
            cat.physicsBody = SKPhysicsBody(rectangleOf: bodysize)
            cat.physicsBody?.isDynamic = false
            cat.name = "randomcat"
            
            addChild(cat)
        
            //line3()
            print("randomX\(randomX)")
            print("randomy\(randomY)")
            let CatMovement = SKAction.move(to: CGPoint(x: self.player.position.x, y: self.player.position.y), duration: 8)
            cat.run(CatMovement)
        
    }
    
    
}
