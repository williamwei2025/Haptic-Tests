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
            print(audioSession)
            engine = try CHHapticEngine(audioSession: audioSession)
            print(engine)
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
            
            print("a hi")
            // Tell the engine to play a pattern.
            try engine?.playPattern(from: URL(fileURLWithPath: path))
            
        } catch { // Engine startup errors
            print("An error occured playing \(filename): \(error).")
        }
    }
    
    func playWavFile(filename: String) {
        // Ensure the file exists
        guard let url = Bundle.main.url(forResource: filename, withExtension: "wav") else {
            print("File not found: \(filename).wav")
            return
        }

        do {
            // Create an AVAudioPlayer instance with the file URL
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            print("w hi")

            // Play the audio file
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch let error {
            print("Error playing WAV file: \(error.localizedDescription)")
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
        
        
        // Create an event (static) parameter to represent the haptic's sharpness.
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                        value: sharpness)
        
        
        var events : [CHHapticEvent] = []
        
        let hapticintensities = [0.948964, 0.852364, 0.439576, 1.88167, 0.76101, 1.23758, 0.801295, 1.58223, 0.922473, 1.70741, 1.42617, 0.406348, 1.28872, 1.07826, 1.1782, 0.812677, 1.36662, 1.25925, 0.856826, 0.89891, 0.594002, 0.720068, 0.683157, 0.981678, 1.32324, 0.946835, 0.823032, 1.19675, 0.742727, 1.17491, 0.828584, 0.875839, 0.551797, 1.21069, 0.729076, 1.37759, 0.841005, 0.826695, 0.616266, 1.08874, 0.876098, 1.37453, 1.16089, 1.13662, 0.773517, 1.04796, 1.0227, 0.881717, 1.41098, 1.10543, 0.819981, 0.135865, 1.78777, 0.737631, 0.897819, 0.664993, 1.31309, 0.973889, 1.02519, 1.03697, 1.59735, 1.04592, 1.32522, 0.816831, 0.93469, 1.17012, 0.918339, 1.41778, 0.951477, 0.776114, 0.391601, 0.913381, 1.63679, 0.788836, 1.00734, 1.7768, 1.59502, 1.40699, 1.38823, 0.299942, 0.875892, 1.18902, 0.792012, 0.982177, 0.981218, 1.02425, 0.791256, 1.18769, 0.792359, 0.80997, 0.854776, 0.828482, 1.03922, 0.771658, 1.48353, 0.877788, 1.42038, 1.11162, 0.857327, 0.778723, 0.864336, 0.94115, 1.23173, 0.90845, 1.14478, 0.717521, 0.364762, 0.779852, 1.39882, 1.31084, 0.836709, 0.897031, 0.752759, 1.15073, 0.430037, 0.573449, 0.835657, 0.317611, 0.685586, 1.00562, 0.971566, 0.588063, 1.41441, 1.2568, 0.867747, 0.92838, 0.844967, 1.2927, 1.09747, 0.630915, 0.958395, 1.10486, 1.01954, 0.427161, 0.393388, 1.24095, 0.882173, 0.832441, 0.144828, 0.458374, 1.0096, 0.80013, 0.602915, 0.590569, 0.560306, 0.5155, -0.0415619, 1.1381, 0.88321, 1.14369, 1.10934, 1.40738, 1.30613, 0.709706, 0.841332, 1.75321, 0.779101, 0.930631, 1.036, 1.25752, 0.876178, 0.655017, 0.999656, 0.552098, 1.4781, 1.39511, 1.36536, 1.21144, 0.530745, 1.47953, 0.897722, 0.734887, 0.967699, 1.12887, 1.77709, 0.811786, 1.50526, 1.17399, 1.17239, 1.55613, 0.641319, 0.629591, 0.896528, 1.3704, 0.976645, 1.08226, 1.41417, 1.12578, 0.886347, 1.68763, 0.685011, 0.897101, 1.29018, 1.03897, 0.98073, 0.657337, 0.735356, 0.925982, 1.0232, 0.723502, 0.850408, 1.65191, 1.20148, 0.976813, 1.23307, 1.39106, 1.13327, 1.17402, 0.949614, 0.912238, 0.785853, 0.995145, 0.753816, 1.10281, 1.31505, 1.35932, 1.10124, 0.526947, 1.09136, 0.951716, 0.573963, 0.582808, 1.65989, 1.23736, 0.469564, 0.818314, 1.06805, 1.12824, 0.717074, 1.18219, 0.86139, 0.770725, 1.38844, 1.16319, 0.772248, 0.845731, 0.291742, 0.792055, 1.33148, 1.04542, 1.01969, 1.44734, 0.657579, 0.554757, 0.961694, 1.28261, 1.15683, 0.530471, 0.694563, 1.30794, 1.19514, 0.675354, 1.11973, 1.15561, 1.05512, 1.1763, 1.07749, 1.06101, 1.19221, 1.07265, 0.769063, 1.11383, 0.665587, 0.999561, 1.14383, 1.43569, 1.35625, 0.96903, 1.00898, 1.02741, 0.72316, 1.38039, 0.906353, 1.58539, 0.629812, 0.831826, 1.0908, 0.499306, 1.29048, 0.963581, 1.12616, 0.924353, 0.730662, 1.47429, 1.64247, 0.134036, 1.12058, 0.657929, 1.48919, 0.981563, 0.566244, 1.29894, 1.10525, 1.34097, -0.0119179, 1.70295, 0.666875, 0.582978, 1.21212, 1.33771, 0.888248, 1.71911, 1.16174, 1.51791, 0.508507, 1.2125, 1.31118, 1.10345, 1.06467, 0.911013, 1.1326, 0.606252, 0.648637, 1.0392, 1.22914, 1.20506, 1.54416, 1.21919, 0.732698, 1.07458, 0.860505, 0.776796, 0.888804, 0.995198, 0.750593, 0.707941, 0.971612, 0.567961, 1.10483, 1.34354, 1.58239, 0.780004, 1.50029, 1.08253, 1.52814, 1.09984, 1.17827, 0.17123, 1.1024, 1.34196, 0.861556, 1.2983, 1.19722, 1.28829, 0.776015, 0.524859, 0.782244, 1.07955, 1.46049, 0.823694, 0.770554, 1.02861, -0.0717905, 1.51868, 0.930346, 1.21281, 1.01244, 0.356561, 1.07865, 1.11983, 0.739395, 0.782474, 0.982112, 0.995885, 0.751996, 0.789164, 0.446808, 1.64681, 1.34078, 0.406248, 1.01884, 0.724863, 1.02214, 0.934358, 0.826532, 1.99659, 1.74035, 1.60734, 1.21062, 0.603658, 0.459275, 1.20257, 1.00842, 0.820312, 1.05613, 1.14035, 1.04496, 0.851189, 0.677032, 0.850853, 1.19418, 1.28175, 0.38035, 0.414966, 1.25114, 0.768163, 1.47558, 0.930525, 0.91929, 1.22927, 0.745523, 0.96212, 0.848144, 1.1839, 1.15506, 0.730702, 0.668626, 0.819599, 0.823098, 1.60047, 0.770448, 0.894498, 1.28536, 0.668511, 1.09262, 0.888851, 0.824531, 0.672662, 0.911181, 1.34228, 0.974087, 0.923201, 1.37025, 1.02654, 1.69071, 1.58397, 0.730277, 0.776314, 1.14793, 0.463687, 1.58765, 0.933508, 1.26271, 0.729377, 1.57443, 1.54204, 0.746722, 0.772642, 0.985932, 1.36791, 0.931671, 1.29992, 0.972331, 0.800939, 1.24262, 0.788031, 0.953558, 1.22797, 1.15668, 1.1861, 1.18916, 1.36097, 0.861936, 0.669708, 0.869422, 1.14864, 0.702927, 1.47308, 0.58255, 1.40076, 0.824847, 1.08342, 1.07426, 1.33882, 0.767846, 0.725951, 1.57072, 1.21806, 1.15156, 0.711909, 1.11741, 0.920973, 0.827733, 1.08783, 0.688327, 0.748391, 0.550155, 1.58808, 1.2057, 1.45942, 0.537662, 1.4636, 1.34281, 0.93074, 0.471179, 0.662733, 1.26059, 0.507625, 0.662505, 0.993312, 0.208046, 0.711893, 0.806711, 0.504864, 0.969668, 0.565787, 1.39907, 0.551045, 1.10796, 1.66693, 0.971778, 1.3229, 0.910771, 1.34209, 1.43264, 1.09647, 1.5852, 0.382955, 0.332686, 0.823623, 0.911861, 0.90158, 0.690032, 1.63171, 0.92232, 1.019, 0.848007, 0.524815, 0.531837, 0.799067, 1.08328, 0.659093, 1.13215, 0.858501, 1.20703, 0.46735, 1.40159, 1.04488, 1.13708, 0.509814, 0.927945, 1.40703, 1.15991, 1.14714, 0.973393, 1.13321, 0.964314, 1.22874, 0.68788, 0.938942, 0.51679, 0.70753, 1.06239, 1.19741, 0.245496, 1.23744, 1.158, 1.50876, 1.2024, 0.878449, 1.06093, 0.63956, 1.22159, 1.5945, 0.926765, 0.876198, 0.951072, 1.02207, 0.712588, 1.34061, 1.90151, 0.492937, 1.33981, 1.6016, 0.614742, 0.663934, 1.41538, 0.847384, 1.00548, 1.17157, 0.791415, 0.720812, 0.709413, 1.16037, 0.935586, 1.39089, 0.880816, 1.27106, 1.26844, 0.592532, 1.22778, 1.18019, 1.14487, 1.2685, 1.02855, 1.38643, 0.74955, 0.811451, 1.20034, 0.477204, 0.461003, 0.650284, 1.27344, 1.05048, 1.67222, 0.95631, 1.14908, 0.650681, 0.808475, 0.955532];
        

        var freq = 1.0 / Double(frequency)
        for i in 0..<frequency
        {
            let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity,
                                                            value: Float(hapticintensities[i]))
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
        //playHapticsFile(named: "AHAP/Inflate")
        playHapticsFile(named: "AHAP/Heartbeats")
        playWavFile(filename: "AHAP/accelSilk 1")

    }
    
    @IBAction func playAHAP2(sender: UIButton) {
        //playHapticsFile(named: "AHAP/Heartbeats")
        playHapticTransient(time: 0, intensity: 1, sharpness: 1, frequency: 300)
    }
    
    @IBAction func playAHAP3(sender: UIButton) {
        playHapticsFile(named: "AHAP/Oscillate")
    }
    
    @IBAction func playAHAP4(sender: UIButton) {
        //playHapticsFile(named: "AHAP/Inflate")
        playHapticTransient(time: 0, intensity: 1, sharpness: 1, frequency: 300)
    }
    
    @IBAction func playAHAP5(sender: UIButton) {
         playHapticsFile(named: "AHAP/Rumble")
    }
    
    @IBAction func playAHAP6(sender: UIButton) {
        //playHapticsFile(named: "AHAP/Rumble")
        playHapticTransient(time: 0, intensity: 1, sharpness: 1, frequency: 300)
    }
    
    @IBAction func playAHAP7(sender: UIButton) {
         playHapticsFile(named: "AHAP/Sparkle")
    }
    
    @IBAction func playAHAP8(sender: UIButton) {
        //playHapticsFile(named: "AHAP/Drums")
        playHapticTransient(time: 0, intensity: 1, sharpness: 1, frequency: 500)
    }

}
