//
//  GameScene.swift
//  tvOS_App
//
//  Created by Apple on 1/28/16.
//  Copyright (c) 2016 PumpkinSpiceGirls. All rights reserved.
//

import SpriteKit
import GameController

class GameScene: SKScene {
    
    var enemy : Enemy!
    var player : Player!
    var debugPlayer : SKLabelNode!
    var debugEnemy : SKLabelNode!
    var debugText : SKLabelNode!
    var lastLocation : CGPoint = CGPointMake(0, 0)
    var controller : GCController!
    var enemy1Idl : SKSpriteNode!
    var enemy1Atk : SKSpriteNode!
    var enemy2Idl : SKSpriteNode!
    var enemy2Atk : SKSpriteNode!
    var sword : SKSpriteNode!
    var currentEnemy : Int = 0
    
    var playerBar : [SKSpriteNode] = []
    var enemyBar : [SKSpriteNode] = []
    
    
    var GameState : GameStateEnum! {
        didSet
        {
            self.removeAllChildren();
            self.removeAllActions();
            switch(GameState)
            {
            case .Some(.Menu):
                let background = SKSpriteNode(imageNamed: "tv_main_menu_noText");
                background.size = size;
                background.position = CGPointMake(size.width / 2, size.height / 2);
                background.zPosition = -5;
                self.addChild(background);
                
                let menuText = SKSpriteNode(imageNamed: "Title");
                menuText.size = CGSize(width: size.width/1.5, height: 200);
                menuText.position = CGPointMake(size.width / 2, size.height - 250);
                menuText.zPosition = -4;
                self.addChild(menuText);
                break;
            case .Some(.Running):
                let background = SKSpriteNode(imageNamed: "tv_background_2", normalMapped: true)
                background.size = size
                background.position = CGPointMake(size.width/2, size.height/2)
                background.zPosition = -5;
                self.addChild(background);
                
                enemy1Idl = SKSpriteNode(imageNamed: "enemy_idle", normalMapped: true)
                enemy1Idl.size = CGSize(width: 300, height: 300)
                enemy1Idl.position = CGPointMake(size.width/2, size.height/2)
                enemy1Idl.zPosition = 2
                
                enemy1Atk = SKSpriteNode(imageNamed: "enemy_attack", normalMapped: true)
                enemy1Atk.size = CGSize(width: 300, height: 300)
                enemy1Atk.position = CGPointMake(size.width/2, size.height/2)
                enemy1Atk.zPosition = 2
                
                enemy2Idl = SKSpriteNode(imageNamed: "enemy_2_idle", normalMapped: true)
                enemy2Idl.size = CGSize(width: 300, height: 300)
                enemy2Idl.position = CGPointMake(size.width/2 + 800, size.height/2 + 800)
                enemy2Idl.zPosition = 2
                
                enemy2Atk = SKSpriteNode(imageNamed: "enemy_2_attack", normalMapped: true)
                enemy2Atk.size = CGSize(width: 300, height: 300)
                enemy2Atk.position = CGPointMake(size.width/2 + 800, size.height/2 + 800)
                enemy2Atk.zPosition = 2
                
                sword = SKSpriteNode(imageNamed: "swordFixed", normalMapped: true)
                sword.size = CGSize(width: 253/4, height: 3200/4)
                //sword.anchorPoint = CGPoint(x:size.width/2, y:size.height/2)
                sword.position = CGPointMake(size.width/2, size.height/2)
                sword.zPosition = 3
                
                let playerData = PlayerData(health: 10, attackStrength: 1, attackAngle: Angle(value: 0.0));
                player = Player(data: playerData);
                let enemyData = EnemyData(health: 5, attack: 1, attackInterval: 2.0, weaknessAngle: Angle(value: 0.0), marginOfError: Angle(value: M_PI/2), imageName: "enemy");
                enemy = Enemy(data: enemyData, position: CGPointMake(size.width / 2, size.height / 2), scene: self);
                
                currentEnemy = 0
                
                debugPlayer = SKLabelNode(fontNamed:"Chalkduster")
                debugPlayer.text = "Player Health: " + String(playerData.health)
                    + " Player Attack Strength: " + String(playerData.attackStrength)
                    + " Player Attack Angle: " + String(playerData.attackAngle.Value)
                debugPlayer.fontSize = 10
                debugPlayer.position = CGPoint(x:150, y:650)
                
                debugEnemy = SKLabelNode(fontNamed:"Chalkduster")
                debugEnemy.text = "Enemy Health: " + String(enemyData.health)
                    + " Enemy Attack: " + String(enemyData.attack)
                    + " Enemy Attack Interval: " + String(enemyData.attackInterval)
                    + " Enemy Weakness Angle: " + String(enemyData.weaknessAngle.Value)
                    + " Enemy Margin of Error: " + String(enemyData.marginOfError.Value)
                debugEnemy.fontSize = 10
                debugEnemy.position = CGPoint(x:370, y:640)
                
                debugText = SKLabelNode(fontNamed:"Chalkduster")
                debugText.text = "Debug"
                debugText.fontSize = 10
                debugText.position = CGPoint(x:100, y: 630)
                
                self.addChild(debugPlayer)
                self.addChild(debugEnemy)
                self.addChild(debugText)
                self.addChild(enemy1Idl)
                enemy1Idl.hidden = true
                self.addChild(enemy1Atk)
                enemy1Atk.hidden = true
                self.addChild(enemy2Idl)
                enemy2Idl.hidden = false
                self.addChild(enemy2Atk)
                enemy2Atk.hidden = true
                self.addChild(sword)
                
                //Enemy attacks
                self.runAction(SKAction.repeatActionForever(SKAction.sequence(
                    [SKAction.waitForDuration(enemyData.attackInterval),
                        SKAction.runBlock(){self.player.damage(enemyData.attack)}])))
                
                self.runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(){self.enemy1Idl.hidden = false},
                    SKAction.waitForDuration(enemyData.attackInterval - 0.45),
                    SKAction.runBlock(){self.enemy1Idl.hidden = true},
                    SKAction.runBlock(){self.enemy1Atk.hidden = false},
                    SKAction.waitForDuration(0.45),
                    SKAction.runBlock(){self.enemy1Atk.hidden = true},
                    SKAction.runBlock(){self.enemy1Idl.hidden = false}])))
                
                self.runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.runBlock(){self.enemy2Idl.hidden = false},
                    SKAction.waitForDuration(enemyData.attackInterval - 0.45),
                    SKAction.runBlock(){self.enemy2Idl.hidden = true},
                    SKAction.runBlock(){self.enemy2Atk.hidden = false},
                    SKAction.waitForDuration(0.45),
                    SKAction.runBlock(){self.enemy2Atk.hidden = true},
                    SKAction.runBlock(){self.enemy2Idl.hidden = false}])))
                
                //Enemy rotates
                self.runAction(SKAction.repeatActionForever(SKAction.sequence([
                    SKAction.waitForDuration(0.01),
                    SKAction.runBlock(){self.enemy.weaknessAngle = self.enemy.weaknessAngle + Angle(value: M_PI/500)}])))
                
                // set up helath bars
                // player health
                for i in 0 ..< player.health {
                    let playerHeart = SKSpriteNode(imageNamed: "player_heart", normalMapped: true)
                    playerHeart.size = CGSize(width: 50, height: 50)
                    playerHeart.position = CGPointMake(50 + 50 * CGFloat(i), size.height - 125)
                    playerHeart.zPosition = 2
                    playerBar.append(playerHeart)
                    self.addChild(playerBar[i])
                }
                // enemy health 
                for i in 0 ..< enemy.health {
                    let enemyHeart = SKSpriteNode(imageNamed: "enemy_heart", normalMapped: true)
                    enemyHeart.size = CGSize(width: 50, height: 50)
                    enemyHeart.position = CGPointMake(size.width - 50 - (50 * CGFloat(i)), size.height - 125)
                    enemyHeart.zPosition = 2
                    enemyBar.append(enemyHeart)
                    self.addChild(enemyBar[i])
                }
                
                break;
            case .Some(.GameOver):
                let background = SKSpriteNode(imageNamed: "tv_defeat");
                background.size = size;
                background.position = CGPointMake(size.width / 2, size.height / 2);
                background.zPosition = -5;
                self.addChild(background);
                
                let menuText = SKSpriteNode(imageNamed: "text_overran");
                menuText.size = CGSize(width: size.width/1.5, height: 200);
                menuText.position = CGPointMake(size.width / 2, size.height - 250);
                menuText.zPosition = -4;
                self.addChild(menuText);
                
                let gameScore = SKLabelNode(fontNamed: "Chalkduster")
                gameScore.text = "Final Score: " + String(currentEnemy) + " Enemies Killed"
                gameScore.fontSize = 50
                gameScore.position = CGPoint(x: size.width/2, y: size.height/2)
                self.addChild(gameScore)
                
                break;
            case .Some(.Paused):
                break;
            default:
                break;
            }
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        //Set up VGC
        self.GameState = .Menu;
        
        VgcManager.startAs(.Central, appIdentifier: "PSGiOSRITChallenge", includesPeerToPeer: true);
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "controllerDidConnect:", name: VgcControllerDidConnectNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "controllerDidDisconnect:", name: VgcControllerDidDisconnectNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedPeripheralSetup:", name: VgcPeripheralSetupNotification, object: nil);
        
        //Register select events
        let tapSelect = UITapGestureRecognizer()
        tapSelect.addTarget(self, action: "pressedSelect")
        tapSelect.allowedPressTypes = [NSNumber (integer: UIPressType.Select.rawValue)]
        self.view!.addGestureRecognizer(tapSelect)
        
        GCController.startWirelessControllerDiscoveryWithCompletionHandler({()->Void in })
        
        NSNotificationCenter.defaultCenter().addObserverForName(GCControllerDidConnectNotification, object: nil, queue: nil)
        { note in
            self.controller = GCController.controllers().first!
            
            self.controller.microGamepad?.valueChangedHandler = { (gamepad, element) -> Void in
                if element == self.controller.microGamepad?.dpad {
                    let xPosition = (self.controller.microGamepad?.dpad.left.value)! - (self.controller.microGamepad?.dpad.right.value)!
                    self.movedDPad(xPosition);
                }
            }
        }
    }
    
    func movedDPad(xPosition: Float)
    {
        switch(self.GameState)
        {
        case .Some(.Menu):
            //Do nothing
            break;
        case .Some(.Running):
            self.player.attackAngle = Angle(value: M_PI * Double(xPosition));
            break;
        case .Some(.GameOver):
            //Do nothing
            break;
        case .Some(.Paused):
            //Do nothing
            break;
        default:
            break;
        }
        
    }
    
    func pressedSelect()
    {
        switch(self.GameState)
        {
        case .Some(.Menu):
            self.GameState = .Running;
            break;
        case .Some(.Running):
            if ( player.attackAngle > enemy.weaknessAngle - enemy.marginOfError && player.attackAngle < enemy.weaknessAngle + enemy.marginOfError)
            {
                debugText.text = "successful attack"
                enemy.damage(player.attackStrength)
            }
            else
            {
                debugText.text = "Missed attack"
            }
            break;
        case .Some(.GameOver):
            self.GameState = .Menu;
            break;
        default:
            //Do nothing?
            break;
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        switch(self.GameState)
        {
        case .Some(.Menu):
            //Do nothing
            break;
        case .Some(.Running):
            debugEnemy.text = "Enemy Health: " + String(enemy.health)
                + " Enemy Attack: " + String(enemy.attack)
                + " Enemy Attack Interval: " + String(enemy.attackInterval)
                + " Enemy Weakness Angle: " + String(enemy.weaknessAngle.Value)
                + " Enemy Margin of Error: " + String(enemy.marginOfError.Value)
            debugPlayer.text = "Player Health: " + String(player.health)
                + " Player Attack Strength: " + String(player.attackStrength)
                + " Player Attack Angle: " + String(player.attackAngle.Value)
            
            debugText.text = "\(currentEnemy)"
            
            let rotation = CGFloat(self.enemy.weaknessAngle.Value);
            self.enemy1Idl.zRotation = rotation + CGFloat(M_PI/2);
            self.enemy1Atk.zRotation = rotation + CGFloat(5 * M_PI/12);
            self.enemy2Idl.zRotation = rotation - CGFloat(M_PI/12);
            self.enemy2Atk.zRotation = rotation;
            self.sword.zRotation = CGFloat(self.player.attackAngle.Value) - CGFloat(M_PI/2);
            
            // update health bars
            // player health
            for i in 0 ..< 10{
                playerBar[i].hidden = true;
            }
            for i in 0 ..< player.health {
                playerBar[i].hidden = false
            }
            // enemy health 
            for i in 0 ..< 5{
                enemyBar[i].hidden = true
            }
            for i in 0 ..< enemy.health {
                enemyBar[i].hidden = false
            }
            
            if ( enemy.health == 0)
            {
                enemy.health = 5
                enemy.marginOfError = (enemy.marginOfError == Angle(value: M_PI/2)) ? Angle(value: M_PI/5) : Angle(value: M_PI/2)
                currentEnemy += 1;
                let enemy1Pos = enemy1Atk.position;
                let enemy2Pos = enemy2Atk.position;
                
                enemy1Idl.position = enemy2Pos;
                enemy1Atk.position = enemy2Pos;
                
                enemy2Idl.position = enemy1Pos;
                enemy2Atk.position = enemy1Pos;
            }
            
            if !player.isAlive
            {
                self.GameState = .GameOver;
            }
        case .Some(.GameOver):
            break;
        case .Some(.Paused):
            break;
        default:
            break;
        }
    }
    
    @objc func controllerDidConnect(notification: NSNotification)
    {
        if VgcManager.appRole == .EnhancementBridge { return }
        
        guard let controller : VgcController = notification.object as? VgcController else {
            print("Got nil controller in controllerDidConnect");
            return;
        }
        
        //if controller.deviceInfo.controllerType == .MFiHardware { return }
        
        VgcManager.peripheralSetup = VgcPeripheralSetup();
        VgcManager.peripheralSetup.motionActive = false;
        VgcManager.peripheralSetup.enableMotionAttitude = true;
        VgcManager.peripheralSetup.enableMotionGravity = true;
        VgcManager.peripheralSetup.enableMotionRotationRate = true;
        VgcManager.peripheralSetup.enableMotionUserAcceleration = true;
        VgcManager.peripheralSetup.sendToController(controller);
        
        controller.extendedGamepad?.dpad.valueChangedHandler = { (dpad, xValue, yValue) in
            self.movedDPad(xValue);
            print("dpad changed! x: \(xValue), y: \(yValue)");
        }
        
        controller.extendedGamepad?.leftThumbstick.valueChangedHandler = { (dpad, xValue, yValue) in
            self.movedDPad(xValue);
            print("left thumbstick changed! x: \(xValue), y: \(yValue)");
        }
        
        controller.extendedGamepad?.rightThumbstick.valueChangedHandler = { (dpad, xValue, yValue) in
            self.movedDPad(xValue);
            print("right thumbstick changed! x: \(xValue), y: \(yValue)");
        }
        
        controller.extendedGamepad?.buttonA.valueChangedHandler = { (input, value, pressed) in
            if (pressed)
            {
                self.pressedSelect();
            }
            print("A button changed: value: \(value), pressed: \(pressed)");
        }
        
    }
    
    @objc func controllerDidDisconnect(notification: NSNotification)
    {
        //Set up actions for controller disconnects
    }
    
    @objc func receivedPeripheralSetup(notification: NSNotification)
    {
        print("Peripheral setup!");
    }
}
