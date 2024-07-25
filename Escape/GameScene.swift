//
//  GameScene.swift
//  Escape
//
//  Created by Lazar, Viktor on 25/07/2024.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var runner: SKSpriteNode!
    var ground: SKSpriteNode!
    var obstacleTimer: Timer?
    var isJumping : Bool = false
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        // Set up the background color
        backgroundColor = .white
        
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        
        // Calculate the bottom CGPoint
        let bottomPoint = CGPoint(x: frame.midX, y: -1.0 * ( guide.layoutFrame.size.height / 2.0 )  + 50.0 )
        
        // Set up the ground
        ground = SKSpriteNode(color: .brown, size: CGSize(width: frame.width, height: 25))
        ground.name = "ground"
        ground.position = CGPoint(x: frame.midX, y: bottomPoint.y )
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        addChild(ground)
        
        // Set up the runner at the bottom of the screen
        runner = SKSpriteNode(imageNamed: "kitten")
        runner.position = CGPoint(x: frame.midX / 4, y: ground.position.y + ground.size.height / 2 + runner.size.height / 2)
        runner.physicsBody = SKPhysicsBody(rectangleOf: runner.size)
        runner.physicsBody?.allowsRotation = false
        runner.physicsBody?.categoryBitMask = 1
        runner.physicsBody?.contactTestBitMask = 1
        addChild(runner)
        
        // Start spawning obstacles
        obstacleTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(spawnObstacle), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Scroll the ground
//        ground.position.x -= 5
//        if ground.position.x <= -frame.width / 2 {
//            ground.position.x = frame.width / 2
//        }
        
        // Move obstacles
        for node in children {
            if node.name == "obstacle" {
                node.position.x -= 5
                if node.position.x < -frame.width / 2 {
                    node.removeFromParent()
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Make the runner jump
        let guide = view!.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
       
        if !isJumping {
            isJumping = true
            runner.physicsBody?.applyImpulse(CGVector(dx: 0, dy: ( guide.layoutFrame.size.height / 3.0 )))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Ensure the runner has landed on the ground
        if contact.bodyA.node == runner && contact.bodyB.node?.name == "ground" ||
           contact.bodyB.node == runner && contact.bodyA.node?.name == "ground" {
            isJumping = false
        }
    }
    
    @objc func spawnObstacle() {
        let obstacle = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 60))
        obstacle.position = CGPoint(x: frame.maxX, y: ground.size.height + obstacle.size.height / 2)
        obstacle.name = "obstacle"
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = false
        addChild(obstacle)
    }
    
//    func didBegin(_ contact: SKPhysicsContact) {
//        if contact.bodyA.node == runner || contact.bodyB.node == runner {
//            // Game over logic here
//            gameOver()
//        }
//    }
    
    func gameOver() {
        // Stop spawning obstacles
        obstacleTimer?.invalidate()
        
//        // Show game over message
//        let gameOverLabel = SKLabelNode(text: "Game Over")
//        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
//        gameOverLabel.fontSize = 40
//        gameOverLabel.fontColor = .red
//        addChild(gameOverLabel)
//        
//        // Add a restart button
//        let restartLabel = SKLabelNode(text: "Tap to Restart")
//        restartLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
//        restartLabel.fontSize = 20
//        restartLabel.fontColor = .black
//        restartLabel.name = "restart"
//        addChild(restartLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            
            for node in nodes {
                if node.name == "restart" {
                    restartGame()
                }
            }
        }
    }
    
    func restartGame() {
        // Reload the scene
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}
