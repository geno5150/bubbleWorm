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

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
   
        
        
        self.addBackground()
        self.addHero()
        
    }
    
    func addBackground(){
        
        let bg = SKSpriteNode(imageNamed: "bg")
        addChild(bg)
    }
    
    func addHero(){
       let geno = SKSpriteNode(imageNamed: "hero")
        hero = Hero(guy: geno)
        addChild(geno)
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            
            if !gameOver{
                
               touchLocation  = (touch.locationInView(self.view!).y * -1) + (self.size.height/2)
            }
        }
        let moveAction = SKAction.moveToY(touchLocation, duration: 0.5)
        moveAction.timingMode = SKActionTimingMode.EaseOut
        hero.guy.runAction(moveAction)
        
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
