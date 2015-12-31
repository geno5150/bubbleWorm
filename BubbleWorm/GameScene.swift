//
//  GameScene.swift
//  BubbleWorm
//
//  Created by Geno Erickson on 12/28/15.
//  Copyright (c) 2015 SuctionPeach. All rights reserved.
//

import SpriteKit

var gameOver = false
var touchLocation = CGFloat()
var hero: Hero!
//var badGuy: BadGuy!
var badGuys: [BadGuy] = []
var endOfScreenRight = CGFloat()
var endOfScreenLeft = CGFloat()
var level = 1
var scoreLabel = SKLabelNode()
var score = 0
var refresh = SKSpriteNode(imageNamed: "reset")

var timer = NSTimer()
var countDownText = SKLabelNode(text: "5")

var countDown = 5

enum ColliderType: UInt32{
    case Hero = 1
    case BadGuy = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        /* Setup your scene here */
        endOfScreenLeft = (self.size.width/2) * CGFloat(-1)
        endOfScreenRight = self.size.width/2
        print(endOfScreenLeft)
        print(" :: ")
        print(endOfScreenRight)
        
        
        self.addBackground()
        self.addHero()
        self.addBadGuys()
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position.y = -(self.size.height/4)
        addChild(scoreLabel)
        addChild(refresh)
        addChild(countDownText)
        countDownText.hidden = false
        countDownText.fontColor = UIColor.blackColor()
        refresh.name = "refresh"
        
        refresh.hidden = true
        
        
        
    }
    
    func reloadGame(){
        hero.guy.position.y = 0
        hero.guy.position.x = 0
        score = 0
        scoreLabel.text = "0"
        level = 0
        for badGuy in badGuys{
            badGuy.guy.removeFromParent()
            
        }
        badGuys = []
        addBadGuys()
         timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
        
        
    }
    
    func updateTimer(){
        if countDown > 0{
            countDown--
            countDownText.text = String(countDown)
            
        }else{
            countDown = 5
            countDownText.text = String(countDown)
            countDownText.hidden = true
            refresh.hidden = true
            gameOver = false
            timer.invalidate()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        hero.emit = true
        gameOver = true
        refresh.hidden = false
        
        
    }
    
    func addBackground(){
        
        let bg = SKSpriteNode(imageNamed: "bg")
        addChild(bg)
    }
    
    func addHero(){
       let geno = SKSpriteNode(imageNamed: "hero")
        geno.physicsBody = SKPhysicsBody(circleOfRadius: geno.size.width/2)
        geno.physicsBody!.affectedByGravity = false
        geno.physicsBody!.categoryBitMask = ColliderType.Hero.rawValue
        geno.physicsBody!.contactTestBitMask = ColliderType.BadGuy.rawValue
        geno.physicsBody!.collisionBitMask   = ColliderType.BadGuy.rawValue
        let heroParticles = SKEmitterNode(fileNamed: "SparkParticle.sks")
        hero = Hero(guy: geno, particles: heroParticles!)
        geno.addChild(heroParticles!)
        addChild(geno)
        
    }
    func addBadGuys(){
       addBadGuy(named: "villain", speed: 1.0, yPos: CGFloat(self.size.height/4))
        addBadGuy(named: "villain", speed: 1.5, yPos: CGFloat(0))
        addBadGuy(named: "villain", speed: 5.0, yPos: CGFloat(-(self.size.height/4)))
        
        
    }
    
    func addBadGuy(named named: String, speed: Float, yPos:CGFloat){
        let badGuyNode = SKSpriteNode(imageNamed: named)
        badGuyNode.physicsBody = SKPhysicsBody(circleOfRadius: badGuyNode.size.width/2)
        badGuyNode.physicsBody!.affectedByGravity   = false
        badGuyNode.physicsBody!.categoryBitMask = ColliderType.BadGuy.rawValue
        badGuyNode.physicsBody!.contactTestBitMask  = ColliderType.Hero.rawValue
        badGuyNode.physicsBody!.collisionBitMask    = ColliderType.Hero.rawValue
        let badGuy = BadGuy(speed: speed, guy: badGuyNode)
        badGuys.append(badGuy)
        resetBadGuy(badGuyNode, yPos: hero.guy.position.y)
        print("reset: hero y: \(hero.guy.position.y)")
        badGuy.yPos = badGuyNode.position.y
        addChild(badGuyNode)
        
    }
    
    func resetBadGuy(badGuyNode: SKSpriteNode, yPos: CGFloat){
        badGuyNode.position.x = endOfScreenRight
        badGuyNode.position.y = yPos
    }
    
    override func update(currentTime: CFTimeInterval){
        if !gameOver{
            updateBadGuyPosition()
        }
        updateHeroEmitter()
    }
    
    func updateHeroEmitter(){
        if hero.emit && hero.emitFrameCount < hero.maxEmitFrameCount{
            hero.emitFrameCount++
            hero.particles.hidden = false
        }else{
            hero.emit = false
            hero.particles.hidden = true
            hero.emitFrameCount = 0
        }
        
    }
    
    
    func updateBadGuyPosition(){
        for badGuy in badGuys{
            //print("random Frame: \(badGuy.randomFrame)")
            if !badGuy.moving{
                
                badGuy.currentFrame++
                if badGuy.currentFrame > badGuy.randomFrame{
                    badGuy.moving=true
                }
            }else{
                    
                    badGuy.guy.position.y = CGFloat(Double(badGuy.guy.position.y) + sin(badGuy.angle) * badGuy.range)
                    badGuy.angle += hero.speed
                    //print("BG angle: \(badGuy.angle)")
                    if badGuy.guy.position.x > endOfScreenLeft{
                        badGuy.guy.position.x -= CGFloat(badGuy.speed)
                        //print("bg x: \(badGuy.guy.position.x)")
                    }else{
                        badGuy.guy.position.x = endOfScreenRight
                        badGuy.guy.position.y = hero.guy.position.y
                        badGuy.currentFrame = 0
                        badGuy.setRandomFrame()
                        badGuy.moving = false
                        badGuy.range += 0.1
                        updateScore()
                    }
                
            }
        }
    }
    
   
    func updateScore(){
        score += level
        scoreLabel.text = String(score)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch: AnyObject! in touches {
            
            if !gameOver{
                
               touchLocation  = (touch.locationInView(self.view!).y * -1) + (self.size.height/2)
            }else{
                let location = touch.locationInNode(self)
                let spriteNode = nodeAtPoint(location)
               // var sprite: SKNode!
                
                        if spriteNode.name != nil{
                            if spriteNode.name == "refresh"{
                                reloadGame()
                    
                        }
                    }
                }
            }
        
        let moveAction = SKAction.moveToY(touchLocation, duration: 0.5)
        moveAction.timingMode = SKActionTimingMode.EaseOut
        hero.guy.runAction(moveAction)
        
        
    }
   
    
}
