import Cocoa

class MainWindowController: NSWindowController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    
    //MARK: - Properties
    
    let speechSynth = NSSpeechSynthesizer()
    var isStarted = false {
        didSet {
            updateButtons()
        }
    }
    
    //MARK: - NSWindowController
    
    override var windowNibName: String? {
        return "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        updateButtons()
        speechSynth.delegate = self
    }
    
    //MARK: - Actions
    
    @IBAction func speakAction(sender: NSButton) {
        let string = textField.stringValue
        if string.isEmpty {
            println("String from \(textField) is empty")
        } else {
            speechSynth.startSpeakingString(string)
            isStarted = true
        }
    
    }
    
    @IBAction func stopAction(sender: NSButton) {
        speechSynth.stopSpeaking()
    }
    
    //MARK: - Private
    
    func updateButtons() {
        if isStarted {
            stopButton.enabled = true
            speakButton.enabled = false
        } else {
            stopButton.enabled = false
            speakButton.enabled = true
        }
    }
    
}

extension MainWindowController : NSSpeechSynthesizerDelegate {
    
    func speechSynthesizer(sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        isStarted = false
    }
    
}

extension MainWindowController : NSWindowDelegate {
    
    func windowShouldClose(sender: AnyObject) -> Bool {
        return !isStarted
    }
    
}
