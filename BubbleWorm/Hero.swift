//
//  Hero.swift
//  BubbleWorm
//
//  Created by Geno Erickson on 12/28/15.
//  Copyright © 2015 SuctionPeach. All rights reserved.
//

import Foundation
import SpriteKit

class Hero {
    
    var guy: SKSpriteNode!
    var speed = 0.1
    var emit = false
    var emitFrameCount = 0
    var maxEmitFrameCount = 30
    var particles:SKEmitterNode
    
    
    init( guy: SKSpriteNode, particles: SKEmitterNode)  {
        self.guy = guy
        self.particles = particles
    }
}
