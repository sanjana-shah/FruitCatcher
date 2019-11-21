//
//  ViewController.swift
//  FruitCatcher
//
//  Created by Alexandra Plukis on 11/8/19.
//  Copyright © 2019 ASU Swift Workshops. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        
        let size = CGSize(width: view.frame.width, height: view.frame.height)
        
        let intro = Intro(size: size)
        
        if let view = view as? SKView {
            view.presentScene(intro)
        }
        // Do any additional setup after loading the view.
    }
    
}

