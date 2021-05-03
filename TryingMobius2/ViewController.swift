//
//  ViewController.swift
//  TryingMobius2
//
//  Created by Angela Garrovillas on 4/18/21.
//  Copyright © 2021 Angela Garrovillas. All rights reserved.
//

import UIKit
import MobiusCore
import AVFoundation



private func beep() {
    AudioServicesPlayAlertSound(SystemSoundID(1322))
}

class ViewController: UIViewController {
    
    typealias CounterModel = Int
    
    enum CounterEvent {
        case increment
        case decrement
    }
    
    enum CounterEffect {
        case playSound
    }
    
    func update(model: CounterModel, event: CounterEvent) -> Next<CounterModel, CounterEffect> {
        switch event {
        case .increment:
            return .next(model + 1)
        case .decrement:
            if model == 0 {
                return .dispatchEffects([.playSound])
            } else {
                return .next(model - 1)
            }
        }
    }

    let effectHandler = EffectRouter<CounterEffect, CounterEvent>()
        .routeCase(CounterEffect.playSound).to { beep() }
        .asConnectable

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        
        let application = Mobius.loop(update: update, effectHandler: effectHandler)
        .start(from: 0)
        
        application.dispatchEvent(.increment) // Model is now 1
        application.dispatchEvent(.decrement) // Model is now 0
        application.dispatchEvent(.decrement) // Sound effect plays! Model is still 0
    }


}

