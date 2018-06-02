import UIKit
import SpriteKit

class SwipeNode: SKNode {
    
    var emitterNode: SKEmitterNode {
        let emitterNode: SKEmitterNode = SKEmitterNode()
        emitterNode.particleTexture = SKTexture(imageNamed: "spark.png")
        emitterNode.particleBirthRate = 3000
        
        emitterNode.particleLifetime = 0.2
        emitterNode.particleLifetimeRange = 0
        
        emitterNode.particlePositionRange = CGVector.zero
        
        emitterNode.particleSpeed = 0.0
        emitterNode.particleSpeedRange = 0.0
        
        emitterNode.particleAlpha = 0.8
        emitterNode.particleAlphaRange = 0.2
        emitterNode.particleAlphaSpeed = -0.45
        
        emitterNode.particleScale = 0.5
        emitterNode.particleScaleRange = 0.001
        emitterNode.particleScaleSpeed = -1
        
        emitterNode.particleRotation = 0
        emitterNode.particleRotationRange = 0
        emitterNode.particleRotationSpeed = 0
        
        emitterNode.particleColorBlendFactor = 1
        emitterNode.particleColorBlendFactorRange = 0
        emitterNode.particleColorBlendFactorSpeed = 0
        
        emitterNode.particleBlendMode = .add
        emitterNode.zPosition = 2
        
        return emitterNode
    }
    
    // MARK: - Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(position:CGPoint, target:SKNode, color:UIColor) {
        super.init()
        
        name = "swipe"
        self.position = position
        
        let tip:SKSpriteNode = SKSpriteNode(color: color, size: CGSize(width: 40, height: 40))
        tip.zRotation = 0.785398163
        tip.zPosition = 10
        addChild(tip)
        
        let emitter: SKEmitterNode = emitterNode
        emitter.particleColor = color
        emitter.targetNode = target
        tip.addChild(emitter)
        
        setScale(0.6)
    }
    
    // MARK: - Physics
    
    func enablePhysics(categoryBitMask: UInt32, contactTestBitmask: UInt32, collisionBitmask: UInt32) {
        physicsBody = SKPhysicsBody(circleOfRadius: 16)
        physicsBody?.categoryBitMask = categoryBitMask
        physicsBody?.contactTestBitMask = contactTestBitmask
        physicsBody?.collisionBitMask = collisionBitmask
        physicsBody?.isDynamic = false
    }
}

