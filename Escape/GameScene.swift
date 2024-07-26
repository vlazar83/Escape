//
//  GameScene.swift
//  Escape
//
//  Created by Lazar, Viktor on 25/07/2024.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player: SKNode!
    var ground: SKSpriteNode!
    var obstacleTimer: Timer?
    var isJumping : Bool = false
    
    var initialPosition: CGPoint!
    
    var knob: SKNode!
    var joystick: SKNode!
    var jumpButton: SKNode!
    var joystick_width : Double = 1.0
    
    override func didMove(to view: SKView) {
        
        knob = self.childNode(withName: "knob")
        player = self.childNode(withName: "player")
        joystick = self.childNode(withName: "joystick")
        jumpButton = self.childNode(withName: "jump_button")
        
        joystick_width = joystick.frame.width - knob.frame.width
        
        initialPosition = knob.position
        
        
//        physicsWorld.contactDelegate = self
//        
//        // Set up the background color
//        backgroundColor = .white
//        
//        let guide = view.safeAreaLayoutGuide
//        let height = guide.layoutFrame.size.height
//        
//        // Calculate the bottom CGPoint
//        let bottomPoint = CGPoint(x: frame.midX, y: -1.0 * ( guide.layoutFrame.size.height / 2.0 )  + 50.0 )
//        
//        // Set up the ground
//        ground = SKSpriteNode(color: .brown, size: CGSize(width: frame.width, height: 25))
//        ground.name = "ground"
//        ground.position = CGPoint(x: frame.midX, y: bottomPoint.y )
//        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
//        ground.physicsBody?.isDynamic = false
//        addChild(ground)
//        
//        // Set up the runner at the bottom of the screen
//        runner = SKSpriteNode(imageNamed: "kitten")
//        runner.position = CGPoint(x: frame.midX / 4, y: ground.position.y + ground.size.height / 2 + runner.size.height / 2)
//        runner.physicsBody = SKPhysicsBody(rectangleOf: runner.size)
//        runner.physicsBody?.allowsRotation = false
//        runner.physicsBody?.categoryBitMask = 1
//        runner.physicsBody?.contactTestBitMask = 1
//        addChild(runner)
//        
//        // Start spawning obstacles
//        obstacleTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(spawnObstacle), userInfo: nil, repeats: true)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Scroll the ground
//        ground.position.x -= 5
//        if ground.position.x <= -frame.width / 2 {
//            ground.position.x = frame.width / 2
//        }
        
//        // Move obstacles
//        for node in children {
//            if node.name == "obstacle" {
//                node.position.x -= 5
//                if node.position.x < -frame.width / 2 {
//                    node.removeFromParent()
//                }
//            }
//        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        for touch in touches {
//            let pointTouched = touch.location(in: self)
//            if knob.contains(pointTouched) {
//                knob.position.x = touch.location(in: self).x
//            }
//            
//        }
//        
        // Make the runner jump
//        let guide = view!.safeAreaLayoutGuide
//        let height = guide.layoutFrame.size.height
//       
//        if !isJumping {
//            isJumping = true
//            runner.physicsBody?.applyImpulse(CGVector(dx: 0, dy: ( guide.layoutFrame.size.height / 3.0 )))
//        }
//    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Ensure the runner has landed on the ground
//        if contact.bodyA.node == runner && contact.bodyB.node?.name == "ground" ||
//           contact.bodyB.node == runner && contact.bodyA.node?.name == "ground" {
//            isJumping = false
//        }
    }
    
    @objc func spawnObstacle() {
//        let obstacle = SKSpriteNode(color: .red, size: CGSize(width: 30, height: 60))
//        obstacle.position = CGPoint(x: frame.maxX, y: ground.size.height + obstacle.size.height / 2)
//        obstacle.name = "obstacle"
//        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
//        obstacle.physicsBody?.isDynamic = false
//        addChild(obstacle)
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
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
////        for touch in touches {
////            let location = touch.location(in: self)
////            let nodes = self.nodes(at: location)
////            
////            for node in nodes {
////                if node.name == "restart" {
////                    restartGame()
////                }
////            }
////        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if (jumpButton.contains(location)){
            let guide = view!.safeAreaLayoutGuide
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: ( guide.layoutFrame.size.height / 3.0 )))
        }
        
        // Check if the touch is on the button
        if knob.contains(location) {
            // Do nothing on touch begin
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let pointTouched = touch.location(in: self)
            if knob.contains(pointTouched) {

                
//                guard let touch = touches.first else { return }
                let location = touch.location(in: self)
                let previousLocation = touch.previousLocation(in: self)
                
                // Calculate the translation along the x-axis
                let translation = location.x - previousLocation.x
                
                // Calculate the new x position
                var newXKnobPosition = knob.position.x + translation
                
                // Constrain the new x position within the range [initialPosition.x - 50, initialPosition.x + 50]
                let minX = initialPosition.x - joystick_width / 2
                let maxX = initialPosition.x + joystick_width / 2
                
                let guide = view!.safeAreaLayoutGuide
//                let viewMinX = guide.layoutFrame.minX
//                let viewMaxX = guide.layoutFrame.maxX
                
                if newXKnobPosition < minX {
                    newXKnobPosition = minX
                    
                    if (player.position.x - 5 ) > guide.layoutFrame.width / -2 {
                        player.position.x -= 5
                    }
                    
                    
                } else if newXKnobPosition > maxX {
                    newXKnobPosition = maxX
                    
                    if (player.position.x + 5 ) < guide.layoutFrame.width / 2 {
                        player.position.x += 5
                    }
                    
        //            player.position.x += 5
                }


                // Update the button's position
                knob.position.x = newXKnobPosition
                
                
            }

        }
        

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
        
        // Check if the touch is on the button
//        if knob.contains(location) {
            // Animate the button back to the initial position
            let moveAction = SKAction.move(to: initialPosition, duration: 0.5)
            knob.run(moveAction)
//        }
    }
    
    func restartGame() {
        // Reload the scene
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}
