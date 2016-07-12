//
//  ViewController.swift
//  watson-speaks
//
//  Created by behnam hajian on 2016-06-27.
//  Copyright © 2016 behnam hajian. All rights reserved.
//

import UIKit
import TextToSpeechV1
import AVFoundation
import SpeechToTextV1

class ViewController: UIViewController {

    var player: AVAudioPlayer?
    // the capture session must not fall out of scope while in use
    var captureSession: AVCaptureSession?
    @IBOutlet weak var mytext: UITextField!
    var recorder: AVAudioRecorder!
    
    @IBOutlet weak var transcribedLabel: UILabel!
    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let document = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let fileName = "speechToTextRecording.wav"
        let filePath = NSURL(fileURLWithPath: document + "/" + fileName)
        let session = AVAudioSession.sharedInstance()
        var settings = [String: AnyObject] ()
        settings[AVSampleRateKey] = NSNumber(float: 44100.0)
        settings[AVNumberOfChannelsKey] = NSNumber(int: 1)
        do{
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            recorder = try AVAudioRecorder(URL: filePath, settings: settings)
        } catch{
            
        }
        
        guard let recorder = recorder else {
            return
        }
    }
    
    
    
    @IBAction func sayIt(sender: AnyObject) {
        let tts = TextToSpeech(username: "7317c9cc-30bb-4297-bd5b-6f07784497ac", password: "lami8dTC00N6")
        
        tts.synthesize(mytext.text!,
                       voice: SynthesisVoice.GB_Kate,
                       audioFormat: AudioFormat.WAV,
                       failure: { error in
                        print("error was generated \(error)")
        }) { data in
            
            do {
                self.player = try AVAudioPlayer(data: data)
                self.player!.play()
            } catch {
                print("Couldn't create player.")
            }
            
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func Listen(sender: UIButton) {
        if (!recorder.recording) {
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setActive(true)
                recorder.record()
                sender.alpha = 1
            } catch {
                
            }
        } else {
            do {
                recorder.stop()
                sender.alpha = 0.5
                let session = AVAudioSession.sharedInstance()
                try session.setActive(false)
                let username = "87bb86cb-61a5-4742-afec-26a7f23c592e"
                let password = "FxxzwmJ5Dgrj"
                let speechToText = SpeechToText(username: username, password: password)
                let settings = TranscriptionSettings(contentType: .WAV)
                let failure = { (error: NSError) in print(error) }
                speechToText.transcribe(recorder.url, settings: settings, failure: failure){
                    result in if let Transcription = result.last?.alternatives.last?.transcript{
                        self.transcribedLabel.text = Transcription
                    }
                }
            } catch {}
        }
    }

}

