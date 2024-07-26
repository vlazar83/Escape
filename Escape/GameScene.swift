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
    
    enum MovesDirection {
        case stand
        case right
        case left
    }
    
    var playerMovesDirection = MovesDirection.stand
    
    override func didMove(to view: SKView) {
        
        knob = self.childNode(withName: "knob")
        player = self.childNode(withName: "player")
        joystick = self.childNode(withName: "joystick")
        jumpButton = self.childNode(withName: "jump_button")
        
        joystick_width = joystick.frame.width - knob.frame.width
        
        initialPosition = knob.position
        
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
    
    
    func gameOver() {
        // Stop spawning obstacles
        obstacleTimer?.invalidate()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if (jumpButton.contains(location)){
            let guide = view!.safeAreaLayoutGuide
            
            switch playerMovesDirection {
            case .stand:
                player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: ( guide.layoutFrame.size.height / 3.0 )))
            case .right:
                if (player.position.x + 20 ) < guide.layoutFrame.width / 2 {
                    player.physicsBody?.applyImpulse(CGVector(dx: 20, dy: ( guide.layoutFrame.size.height / 3.0 )))
                } else {
                    var diffx = ( guide.layoutFrame.width / 2 ) - player.position.x - 2
                    player.physicsBody?.applyImpulse(CGVector(dx: diffx, dy: ( guide.layoutFrame.size.height / 3.0 )))
                }
            case .left:
                if (player.position.x - 20 ) < guide.layoutFrame.width / -2 {
                    var diffx = ( guide.layoutFrame.width / -2 ) - player.position.x + 2
                    player.physicsBody?.applyImpulse(CGVector(dx: diffx, dy: ( guide.layoutFrame.size.height / 3.0 )))
                    
                } else {
                    player.physicsBody?.applyImpulse(CGVector(dx: -20, dy: ( guide.layoutFrame.size.height / 3.0 )))
                }
            }
            
        }
        
        // Check if the touch is on the button
        if knob.contains(location) {
            // Do nothing on touch begin
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let pointTouched = touch.location(in: self)

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

                if newXKnobPosition < minX {
                    newXKnobPosition = minX
                    
                    if (player.position.x - 5 ) > guide.layoutFrame.width / -2 {
                        player.position.x -= 5
                        playerMovesDirection = MovesDirection.left
                    }
                    
                    
                } else if newXKnobPosition > maxX {
                    newXKnobPosition = maxX
                    
                    if (player.position.x + 5 ) < guide.layoutFrame.width / 2 {
                        player.position.x += 5
                        playerMovesDirection = MovesDirection.right
                    }
                    
                }


                // Update the button's position
                knob.position.x = newXKnobPosition
                
                
            }
        

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
            // Animate the button back to the initial position
            let moveAction = SKAction.move(to: initialPosition, duration: 0.5)
            knob.run(moveAction)
            playerMovesDirection = MovesDirection.stand
    }
    
    func restartGame() {
        // Reload the scene
        if let scene = GameScene(fileNamed: "GameScene") {
            scene.scaleMode = .aspectFill
            view?.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
        }
    }
}
