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
        
        
        // Create an event (static) parameter to represent the haptic's sharpness.
        let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness,
                                                        value: sharpness)
        
        
        var events : [CHHapticEvent] = []
        
        let hapticintensities = [0.948964, 0.852364, 0.439576, 1.88167, 0.76101, 1.23758, 0.801295, 1.58223, 0.922473, 1.70741, 1.42617, 0.406348, 1.28872, 1.07826, 1.1782, 0.812677, 1.36662, 1.25925, 0.856826, 0.89891, 0.594002, 0.720068, 0.683157, 0.981678, 1.32324, 0.946835, 0.823032, 1.19675, 0.742727, 1.17491, 0.828584, 0.875839, 0.551797, 1.21069, 0.729076, 1.37759, 0.841005, 0.826695, 0.616266, 1.08874, 0.876098, 1.37453, 1.16089, 1.13662, 0.773517, 1.04796, 1.0227, 0.881717, 1.41098, 1.10543, 0.819981, 0.135865, 1.78777, 0.737631, 0.897819, 0.664993, 1.31309, 0.973889, 1.02519, 1.03697, 1.59735, 1.04592, 1.32522, 0.816831, 0.93469, 1.17012, 0.918339, 1.41778, 0.951477, 0.776114, 0.391601, 0.913381, 1.63679, 0.788836, 1.00734, 1.7768, 1.59502, 1.40699, 1.38823, 0.299942, 0.875892, 1.18902, 0.792012, 0.982177, 0.981218, 1.02425, 0.791256, 1.18769, 0.792359, 0.80997, 0.854776, 0.828482, 1.03922, 0.771658, 1.48353, 0.877788, 1.42038, 1.11162, 0.857327, 0.778723, 0.864336, 0.94115, 1.23173, 0.90845, 1.14478, 0.717521, 0.364762, 0.779852, 1.39882, 1.31084, 0.836709, 0.897031, 0.752759, 1.15073, 0.430037, 0.573449, 0.835657, 0.317611, 0.685586, 1.00562, 0.971566, 0.588063, 1.41441, 1.2568, 0.867747, 0.92838, 0.844967, 1.2927, 1.09747, 0.630915, 0.958395, 1.10486, 1.01954, 0.427161, 0.393388, 1.24095, 0.882173, 0.832441, 0.144828, 0.458374, 1.0096, 0.80013, 0.602915, 0.590569, 0.560306, 0.5155, -0.0415619, 1.1381, 0.88321, 1.14369, 1.10934, 1.40738, 1.30613, 0.709706, 0.841332, 1.75321, 0.779101, 0.930631, 1.036, 1.25752, 0.876178, 0.655017, 0.999656, 0.552098, 1.4781, 1.39511, 1.36536, 1.21144, 0.530745, 1.47953, 0.897722, 0.734887, 0.967699, 1.12887, 1.77709, 0.811786, 1.50526, 1.17399, 1.17239, 1.55613, 0.641319, 0.629591, 0.896528, 1.3704, 0.976645, 1.08226, 1.41417, 1.12578, 0.886347, 1.68763, 0.685011, 0.897101, 1.29018, 1.03897, 0.98073, 0.657337, 0.735356, 0.925982, 1.0232, 0.723502, 0.850408, 1.65191, 1.20148, 0.976813, 1.23307, 1.39106, 1.13327, 1.17402, 0.949614, 0.912238, 0.785853, 0.995145, 0.753816, 1.10281, 1.31505, 1.35932, 1.10124, 0.526947, 1.09136, 0.951716, 0.573963, 0.582808, 1.65989, 1.23736, 0.469564, 0.818314, 1.06805, 1.12824, 0.717074, 1.18219, 0.86139, 0.770725, 1.38844, 1.16319, 0.772248, 0.845731, 0.291742, 0.792055, 1.33148, 1.04542, 1.01969, 1.44734, 0.657579, 0.554757, 0.961694, 1.28261, 1.15683, 0.530471, 0.694563, 1.30794, 1.19514, 0.675354, 1.11973, 1.15561, 1.05512, 1.1763, 1.07749, 1.06101, 1.19221, 1.07265, 0.769063, 1.11383, 0.665587, 0.999561, 1.14383, 1.43569, 1.35625, 0.96903, 1.00898, 1.02741, 0.72316, 1.38039, 0.906353, 1.58539, 0.629812, 0.831826, 1.0908, 0.499306, 1.29048, 0.963581, 1.12616, 0.924353, 0.730662, 1.47429, 1.64247, 0.134036, 1.12058, 0.657929, 1.48919, 0.981563, 0.566244, 1.29894, 1.10525, 1.34097, -0.0119179, 1.70295, 0.666875, 0.582978, 1.21212, 1.33771, 0.888248, 1.71911, 1.16174, 1.51791, 0.508507, 1.2125, 1.31118, 1.10345, 1.06467, 0.911013, 1.1326, 0.606252, 0.648637, 1.0392, 1.22914, 1.20506, 1.54416, 1.21919, 0.732698, 1.07458, 0.860505, 0.776796, 0.888804, 0.995198, 0.750593, 0.707941, 0.971612, 0.567961, 1.10483, 1.34354, 1.58239, 0.780004, 1.50029, 1.08253, 1.52814, 1.09984, 1.17827, 0.17123, 1.1024, 1.34196, 0.861556, 1.2983, 1.19722, 1.28829, 0.776015, 0.524859, 0.782244, 1.07955, 1.46049, 0.823694, 0.770554, 1.02861, -0.0717905, 1.51868, 0.930346, 1.21281, 1.01244, 0.356561, 1.07865, 1.11983, 0.739395, 0.782474, 0.982112, 0.995885, 0.751996, 0.789164, 0.446808, 1.64681, 1.34078, 0.406248, 1.01884, 0.724863, 1.02214, 0.934358, 0.826532, 1.99659, 1.74035, 1.60734, 1.21062, 0.603658, 0.459275, 1.20257, 1.00842, 0.820312, 1.05613, 1.14035, 1.04496, 0.851189, 0.677032, 0.850853, 1.19418, 1.28175, 0.38035, 0.414966, 1.25114, 0.768163, 1.47558, 0.930525, 0.91929, 1.22927, 0.745523, 0.96212, 0.848144, 1.1839, 1.15506, 0.730702, 0.668626, 0.819599, 0.823098, 1.60047, 0.770448, 0.894498, 1.28536, 0.668511, 1.09262, 0.888851, 0.824531, 0.672662, 0.911181, 1.34228, 0.974087, 0.923201, 1.37025, 1.02654, 1.69071, 1.58397, 0.730277, 0.776314, 1.14793, 0.463687, 1.58765, 0.933508, 1.26271, 0.729377, 1.57443, 1.54204, 0.746722, 0.772642, 0.985932, 1.36791, 0.931671, 1.29992, 0.972331, 0.800939, 1.24262, 0.788031, 0.953558, 1.22797, 1.15668, 1.1861, 1.18916, 1.36097, 0.861936, 0.669708, 0.869422, 1.14864, 0.702927, 1.47308, 0.58255, 1.40076, 0.824847, 1.08342, 1.07426, 1.33882, 0.767846, 0.725951, 1.57072, 1.21806, 1.15156, 0.711909, 1.11741, 0.920973, 0.827733, 1.08783, 0.688327, 0.748391, 0.550155, 1.58808, 1.2057, 1.45942, 0.537662, 1.4636, 1.34281, 0.93074, 0.471179, 0.662733, 1.26059, 0.507625, 0.662505, 0.993312, 0.208046, 0.711893, 0.806711, 0.504864, 0.969668, 0.565787, 1.39907, 0.551045, 1.10796, 1.66693, 0.971778, 1.3229, 0.910771, 1.34209, 1.43264, 1.09647, 1.5852, 0.382955, 0.332686, 0.823623, 0.911861, 0.90158, 0.690032, 1.63171, 0.92232, 1.019, 0.848007, 0.524815, 0.531837, 0.799067, 1.08328, 0.659093, 1.13215, 0.858501, 1.20703, 0.46735, 1.40159, 1.04488, 1.13708, 0.509814, 0.927945, 1.40703, 1.15991, 1.14714, 0.973393, 1.13321, 0.964314, 1.22874, 0.68788, 0.938942, 0.51679, 0.70753, 1.06239, 1.19741, 0.245496, 1.23744, 1.158, 1.50876, 1.2024, 0.878449, 1.06093, 0.63956, 1.22159, 1.5945, 0.926765, 0.876198, 0.951072, 1.02207, 0.712588, 1.34061, 1.90151, 0.492937, 1.33981, 1.6016, 0.614742, 0.663934, 1.41538, 0.847384, 1.00548, 1.17157, 0.791415, 0.720812, 0.709413, 1.16037, 0.935586, 1.39089, 0.880816, 1.27106, 1.26844, 0.592532, 1.22778, 1.18019, 1.14487, 1.2685, 1.02855, 1.38643, 0.74955, 0.811451, 1.20034, 0.477204, 0.461003, 0.650284, 1.27344, 1.05048, 1.67222, 0.95631, 1.14908, 0.650681, 0.808475, 0.955532];
        
//        let hapticintensities = [0.475765, 0.419452, 0.201278, 0.796853, 0.5399, 0.602695, 0.445914, 0.746526, 0.575234, 0.845279, 0.846709, 0.338906, 0.539009, 0.570219, 0.613528, 0.451692, 0.643681, 0.691731, 0.50086, 0.436019, 0.281577, 0.279835, 0.272238, 0.411145, 0.633665, 0.537617, 0.419601, 0.555813, 0.410131, 0.539222, 0.442602, 0.413541, 0.254519, 0.501081, 0.393168, 0.631404, 0.489325, 0.401634, 0.276706, 0.454449, 0.441194, 0.654452, 0.647021, 0.614754, 0.429539, 0.483469, 0.511439, 0.450011, 0.672019, 0.628561, 0.455105, 0.0590501, 0.689556, 0.496267, 0.430553, 0.309791, 0.57461, 0.536699, 0.51787, 0.522967, 0.793095, 0.645938, 0.691373, 0.484659, 0.448062, 0.560638, 0.492109, 0.689888, 0.558846, 0.403216, 0.164856, 0.323776, 0.7559, 0.522716, 0.488996, 0.862567, 0.941919, 0.851619, 0.797907, 0.270723, 0.319552, 0.533014, 0.431987, 0.457244, 0.476972, 0.506641, 0.404614, 0.546568, 0.430863, 0.375531, 0.382639, 0.378987, 0.476237, 0.389968, 0.683841, 0.530261, 0.695994, 0.635204, 0.474632, 0.373472, 0.38388, 0.434307, 0.590343, 0.499965, 0.560543, 0.391918, 0.147083, 0.253036, 0.613357, 0.71626, 0.50256, 0.433112, 0.355894, 0.516069, 0.247735, 0.186848, 0.308806, 0.119445, 0.200841, 0.40417, 0.470009, 0.296726, 0.60962, 0.687653, 0.507589, 0.45181, 0.406839, 0.604854, 0.597851, 0.357253, 0.410996, 0.524324, 0.527483, 0.236125, 0.0957935, 0.46415, 0.462295, 0.404002, 0.0539118, 0.0598174, 0.353114, 0.37681, 0.267921, 0.213813, 0.187849, 0.158663, -0.11732, 0.327441, 0.421398, 0.545288, 0.574481, 0.721317, 0.735346, 0.443647, 0.381877, 0.813899, 0.541231, 0.456041, 0.494991, 0.62678, 0.495668, 0.321651, 0.425412, 0.271269, 0.633442, 0.763537, 0.77504, 0.69546, 0.338813, 0.6448, 0.528795, 0.374213, 0.427541, 0.541583, 0.89352, 0.574097, 0.738363, 0.681249, 0.641254, 0.810079, 0.452197, 0.279254, 0.360347, 0.636358, 0.558636, 0.549741, 0.714066, 0.648826, 0.491552, 0.810584, 0.487614, 0.419264, 0.604068, 0.57263, 0.512738, 0.334851, 0.304385, 0.395235, 0.481188, 0.368598, 0.372838, 0.765802, 0.720676, 0.55985, 0.617643, 0.734246, 0.655256, 0.62846, 0.520177, 0.457996, 0.378689, 0.449441, 0.37216, 0.497097, 0.658586, 0.738712, 0.636619, 0.313993, 0.453726, 0.474714, 0.290323, 0.212338, 0.707464, 0.726775, 0.324669, 0.318046, 0.472384, 0.565358, 0.392791, 0.534364, 0.4598, 0.369746, 0.630936, 0.645819, 0.443193, 0.388491, 0.122415, 0.249211, 0.580138, 0.576202, 0.532879, 0.718693, 0.430534, 0.240019, 0.376116, 0.605073, 0.629053, 0.320443, 0.267287, 0.56314, 0.639227, 0.398251, 0.500444, 0.584649, 0.562625, 0.601881, 0.576058, 0.55451, 0.607897, 0.576862, 0.415146, 0.511086, 0.354121, 0.436117, 0.552587, 0.734706, 0.765148, 0.578507, 0.51696, 0.515678, 0.375155, 0.625485, 0.520469, 0.775777, 0.440593, 0.371419, 0.494509, 0.271551, 0.539574, 0.517959, 0.564445, 0.488909, 0.361546, 0.668134, 0.888888, 0.2415, 0.411929, 0.324659, 0.665822, 0.57468, 0.310572, 0.55567, 0.590204, 0.695872, 0.0947289, 0.643553, 0.440622, 0.262244, 0.501806, 0.682422, 0.52595, 0.832902, 0.720193, 0.814151, 0.382538, 0.525792, 0.672206, 0.620779, 0.567148, 0.476768, 0.54943, 0.336097, 0.258241, 0.429268, 0.598795, 0.644244, 0.810011, 0.726188, 0.444868, 0.493417, 0.43831, 0.368977, 0.394805, 0.463561, 0.374761, 0.308625, 0.414568, 0.274617, 0.45851, 0.663376, 0.849955, 0.530889, 0.720613, 0.634748, 0.791201, 0.661441, 0.630453, 0.151231, 0.387797, 0.645685, 0.505738, 0.629057, 0.648682, 0.692013, 0.462781, 0.242533, 0.291717, 0.470327, 0.722321, 0.512349, 0.376487, 0.460325, -0.0141837, 0.527613, 0.522164, 0.607096, 0.547133, 0.205433, 0.408862, 0.542034, 0.402121, 0.349036, 0.434512, 0.483761, 0.378832, 0.348102, 0.182884, 0.683246, 0.76653, 0.315236, 0.405778, 0.346831, 0.45417, 0.459284, 0.403355, 0.935789, 1.04602, 0.985565, 0.763202, 0.387804, 0.176892, 0.46842, 0.519236, 0.423481, 0.489808, 0.569392, 0.55232, 0.444582, 0.319041, 0.357387, 0.545814, 0.664625, 0.271508, 0.109045, 0.471784, 0.411735, 0.686997, 0.552982, 0.469422, 0.59121, 0.421233, 0.441492, 0.408901, 0.553681, 0.60405, 0.410956, 0.295653, 0.334647, 0.362857, 0.738652, 0.504108, 0.430236, 0.605253, 0.395426, 0.489649, 0.450908, 0.397795, 0.303921, 0.381033, 0.628701, 0.551795, 0.47322, 0.660038, 0.585299, 0.850651, 0.920864, 0.524848, 0.36954, 0.514497, 0.265683, 0.675189, 0.563136, 0.637143, 0.424025, 0.728752, 0.864772, 0.516236, 0.36821, 0.437742, 0.661669, 0.540622, 0.644709, 0.547298, 0.413898, 0.574272, 0.439544, 0.446108, 0.589286, 0.617929, 0.631286, 0.635342, 0.720052, 0.51863, 0.332678, 0.365925, 0.528561, 0.381885, 0.669293, 0.385087, 0.626117, 0.480699, 0.52089, 0.546507, 0.678745, 0.463663, 0.338073, 0.705727, 0.707031, 0.642156, 0.405992, 0.505679, 0.474854, 0.40565, 0.5033, 0.361784, 0.320257, 0.21981, 0.674073, 0.695922, 0.784989, 0.386105, 0.648377, 0.739027, 0.557044, 0.252985, 0.229961, 0.531007, 0.300854, 0.248615, 0.405449, 0.105007, 0.198828, 0.31044, 0.209113, 0.373296, 0.261615, 0.597467, 0.347127, 0.475381, 0.819456, 0.626179, 0.679447, 0.524251, 0.660902, 0.773159, 0.649415, 0.820339, 0.333219, 0.0855984, 0.253421, 0.388768, 0.424368, 0.325588, 0.731368, 0.577404, 0.520611, 0.430367, 0.244858, 0.174468, 0.284678, 0.474728, 0.343181, 0.494565, 0.443734, 0.574225, 0.282925, 0.590508, 0.580061, 0.590664, 0.298589, 0.371871, 0.657204, 0.653292, 0.620892, 0.526337, 0.566241, 0.510043, 0.607168, 0.398077, 0.41801, 0.244346, 0.258007, 0.446814, 0.590096, 0.183516, 0.466953, 0.588968, 0.782356, 0.707629, 0.507635, 0.517325, 0.336541, 0.534186, 0.811178, 0.595803, 0.454782, 0.449966, 0.495678, 0.365488, 0.603067, 0.984888, 0.458573, 0.60055, 0.835129, 0.456116, 0.291236, 0.611897, 0.497738, 0.489047, 0.575041, 0.436967, 0.33351, 0.294384, 0.503475, 0.487907, 0.677496, 0.52061, 0.62266, 0.678934, 0.373738, 0.539286, 0.61408, 0.615519, 0.666104, 0.575427, 0.703786, 0.462513, 0.377681, 0.54709, 0.283249, 0.145787, 0.199015, 0.531251, 0.560848, 0.839041, 0.619985, 0.594031, 0.365597, 0.344845, 0.42519]
        
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
        playHapticsFile(named: "AHAP/Inflate")
        

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
