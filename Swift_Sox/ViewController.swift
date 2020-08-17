//
//  ViewController.swift
//  Swift_Sox
//
//  Created by Modi on 2020/8/17.
//  Copyright © 2020 Modi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        testSox()
    }
    
    fileprivate func testSox() {
        let input = ""
        let output = ""
        let rate = "1.2"
        if SoxTools.changeAudioSpeed(input, to: output, rate: rate) {
            print("sox change audio rete success.")
        }
    }
    
}

