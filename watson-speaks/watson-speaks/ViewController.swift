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
    
    // Do any additional setup after loading the view, typically from a nib.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let tts = TextToSpeech(username: "7317c9cc-30bb-4297-bd5b-6f07784497ac", password: "lami8dTC00N6")
        
        tts.synthesize("Hello Behnam. What do you want me to say",
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
    
    

    @IBAction func Listen(sender: AnyObject) {
       //  create capture session
        print("testing:" )
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else {
                    return
                }
        
                // set microphone as a capture session input
                let microphoneDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeAudio)
                let microphoneInput = try? AVCaptureDeviceInput(device: microphoneDevice)
                if captureSession.canAddInput(microphoneInput) {
                    captureSession.addInput(microphoneInput)
                }
        
                // create Speech to Text object
                let username = "87bb86cb-61a5-4742-afec-26a7f23c592e"
                let password = "FxxzwmJ5Dgrj"
                let speechToText = SpeechToText(username: username, password: password)
        
                // define transcription settings
                var settings = TranscriptionSettings(contentType: .L16(rate: 44100, channels: 1))
                settings.continuous = true
                settings.interimResults = true
        
                // create output for capture session
                let failure = { (error: NSError) in print(error) }
                let output = speechToText.createTranscriptionOutput(settings, failure: failure) { results in
                    if let transcription = results.last?.alternatives.last?.transcript {
                        print(transcription)
                    }
                }
        
                if let output = output {
                    let transcriptionOutput = output.0
                    let stopStreaming = output.1
        
                    // set Speech to Text as a capture session output
                    if captureSession.canAddOutput(transcriptionOutput) {
                        captureSession.addOutput(transcriptionOutput)
                    }
                    
                    // add any custom capture session outputs here
                    
                    // start capture session to stream audio
                    captureSession.startRunning()
                }
    }

}

