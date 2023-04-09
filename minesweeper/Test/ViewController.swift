//
//  ViewController.swift
//  Test
//
//  Created by Sam on 2023. 03. 09..
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saver = MinesweeperView(
            frame: view.frame,
            //frame: NSRect(x: 0, y: 0, width: 2000, height: 1000),
            isPreview: true
        )
        view.addSubview(saver)
        
        Timer.scheduledTimer(
            withTimeInterval: 1.0/30,
            repeats: true)
        { [weak self] _ in
            saver.animateOneFrame()
        }
        //self.saver = saver

    }

}

