import Cocoa

class MainWindowController: NSWindowController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    //MARK: - Properties
    
    let speechSynth = NSSpeechSynthesizer()
    var voices = NSSpeechSynthesizer.availableVoices() as! [String]
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
        for voice in voices {
            println(voiceNameForIdentifier(voice)!)
        }
        selectDefaultVoice()
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
    
    func voiceNameForIdentifier(identifier: String) -> String? {
        if let attributes = NSSpeechSynthesizer.attributesForVoice(identifier) {
            return attributes[NSVoiceName] as? String
        } else {
            return nil
        }
    }
    
    func selectDefaultVoice() {
        let defaultVoice = NSSpeechSynthesizer.defaultVoice()
        if let defaultRow = find(voices, defaultVoice) {
            let indices = NSIndexSet(index: defaultRow)
            tableView.selectRowIndexes(indices, byExtendingSelection: false)
            tableView.scrollRowToVisible(defaultRow)
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

extension MainWindowController: NSTableViewDataSource, NSTableViewDelegate {
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return voices.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        let voice = voices[row]
        let voiceName = voiceNameForIdentifier(voice)
        return voiceName
    }
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        let row = tableView.selectedRow
        if row == -1 {
            speechSynth.setVoice(nil)
        } else {
            let voice = voices[row]
            speechSynth.setVoice(voice)
        }
    }
    
}
