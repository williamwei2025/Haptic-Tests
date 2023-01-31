/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The view controller for the HapticSampler app.
*/

import UIKit
import CoreHaptics
import AVFoundation

class ViewController: UIViewController {
    
    // A haptic engine manages the connection to the haptic server.
    var engine: CHHapticEngine?
    
    // Maintain a variable to check for Core Haptics compatibility on device.
    lazy var supportsHaptics: Bool = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.supportsHaptics
    }()
    
    // Set the status bar white to show up on a black background.
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Create the engine before doing anything else.
        createEngine()
    }
    
    /// - Tag: CreateEngine
    func createEngine() {
        // Create and configure a haptic engine.
        do {
            // Associate the haptic engine with the default audio session
            // to ensure the correct behavior when playing audio-based haptics.
            let audioSession = AVAudioSession.sharedInstance()
            engine = try CHHapticEngine(audioSession: audioSession)
        } catch let error {
            print("Engine Creation Error: \(error)")
        }
        
        guard let engine = engine else {
            print("Failed to create engine!")
            return
        }
        
        // The stopped handler alerts you of engine stoppage due to external causes.
        engine.stoppedHandler = { reason in
            print("The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt:
                print("Audio session interrupt")
            case .applicationSuspended:
                print("Application suspended")
            case .idleTimeout:
                print("Idle timeout")
            case .systemError:
                print("System error")
            case .notifyWhenFinished:
                print("Playback finished")
            case .gameControllerDisconnect:
                print("Controller disconnected.")
            case .engineDestroyed:
                print("Engine destroyed.")
            @unknown default:
                print("Unknown error")
            }
        }
 
        // The reset handler provides an opportunity for your app to restart the engine in case of failure.
        engine.resetHandler = {
            // Try restarting the engine.
            print("The engine reset --> Restarting now!")
            do {
                try self.engine?.start()
            } catch {
                print("Failed to restart the engine: \(error)")
            }
        }
    }
    
    /// - Tag: PlayAHAP
    func playHapticsFile(named filename: String) {
        
        // If the device doesn't support Core Haptics, abort.
        if !supportsHaptics {
            return
        }
        
        // Express the path to the AHAP file before attempting to load it.
        guard let path = Bundle.main.path(forResource: filename, ofType: "ahap") else {
            return
        }
        
        do {
            // Start the engine in case it's idle.
            try engine?.start()
            
            // Tell the engine to play a pattern.
            try engine?.playPattern(from: URL(fileURLWithPath: path))
            
        } catch { // Engine startup errors
            print("An error occured playing \(filename): \(error).")
        }
    }
    
    private func playHapticTransient(time: TimeInterval,
                                     intensity: Float,
                                     sharpness: Float,
                                     frequency: Int) {
        
        // Abort if the device doesn't support haptics.
        if !supportsHaptics {
            return
        }
        
        // Flash the pad background to indicate that the timer fired.
        //self.flashBackground(in: self.transientPalette)
        
        // Create an event (static) parameter to represent the haptic's intensity.
        let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                        value: intensity)
        
        // Create an event (static) parameter to represent the haptic's sharpness.
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                        value: sharpness)
        
        
        var events : [CHHapticEvent] = []
        
        var freq = 1.0 / Double(frequency)
        for i in 0..<frequency
        {
            events.append( CHHapticEvent(eventType: .hapticTransient,
                                         parameters: [intensityParameter, sharpnessParameter],
                                         relativeTime: Double(i)*freq))
        }
        
        // Create an event to represent the transient haptic pattern.
        
        
//        let event = CHHapticEvent(eventType: .hapticTransient,
//                                  parameters: [intensityParameter, sharpnessParameter],
//                                  relativeTime: 0)
        
        // Create a pattern from the haptic event.
        do {
            
            // Start the engine in case it's idle.
            try engine?.start()
            
            let pattern = try CHHapticPattern(events: events, parameters: [])
            
            // Create a player to play the haptic pattern.
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: CHHapticTimeImmediate) // Play now.
        } catch let error {
            print("Error creating a haptic transient pattern: \(error)")
        }
    }

    @IBAction func buttonBackgroundRegular(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.937, green: 0.937, blue: 0.937, alpha: 1)
    }
    
    @IBAction func buttonBackgroundHighlight(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.837, green: 0.837, blue: 0.837, alpha: 1)
    }
    
    // Respond to presses from each button, created in Interface Builder.
    @IBAction func playAHAP1(sender: UIButton) {
        playHapticsFile(named: "AHAP/Inflate")
        

    }
    
    @IBAction func playAHAP2(sender: UIButton) {
        //playHapticsFile(named: "AHAP/Heartbeats")
        playHapticTransient(time: 0, intensity: 1, sharpness: 0.5, frequency: 50)
    }
    
    @IBAction func playAHAP3(sender: UIButton) {
        playHapticsFile(named: "AHAP/Oscillate")
    }
    
    @IBAction func playAHAP4(sender: UIButton) {
        //playHapticsFile(named: "AHAP/Inflate")
        playHapticTransient(time: 0, intensity: 1, sharpness: 0.5, frequency: 100)
    }
    
    @IBAction func playAHAP5(sender: UIButton) {
         playHapticsFile(named: "AHAP/Rumble")
    }
    
    @IBAction func playAHAP6(sender: UIButton) {
        //playHapticsFile(named: "AHAP/Rumble")
        playHapticTransient(time: 0, intensity: 1, sharpness: 0.5, frequency: 250)
    }
    
    @IBAction func playAHAP7(sender: UIButton) {
         playHapticsFile(named: "AHAP/Sparkle")
    }
    
    @IBAction func playAHAP8(sender: UIButton) {
        //playHapticsFile(named: "AHAP/Drums")
        playHapticTransient(time: 0, intensity: 1, sharpness: 0.5, frequency: 500)
    }

}
