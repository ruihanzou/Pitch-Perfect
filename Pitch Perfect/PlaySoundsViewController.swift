//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ruihan Zou on 5/24/15.
//  Copyright (c) 2015 Ruihan Zou. All rights reserved.
//

import UIKit
import AVFoundation
class PlaySoundsViewController: UIViewController {
    
    var audioPlayer: AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    //Declared globally within PlaySoundsViewController
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!
    
    func play(sp: Float, frombegin: Bool) {
        audioPlayer.stop()
        audioPlayer.rate = sp;
        if frombegin {
           audioPlayer.currentTime = 0.0
        }
        
        audioPlayer.play()
    }
    
    func stopAllAudio() {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if (receivedAudio != nil ) {
            audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
            audioPlayer.enableRate = true
        }
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playSlowAudio(sender: UIButton) {
        //Play audio sloooooowly here.
        audioEngine.stop()
        audioEngine.reset()
        play(0.5, frombegin: true)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        audioEngine.stop()
        audioEngine.reset()
        play(2.0, frombegin: true)
    }
    @IBAction func stopAudio(sender: UIButton) {
        stopAllAudio()
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func playAudioWithVariableEcho(delyTime: NSTimeInterval, feedback: Float){
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var delay = AVAudioUnitDelay()
        delay.delayTime = delyTime
        delay.feedback = feedback
        audioEngine.attachNode(delay)
        
        audioEngine.connect(audioPlayerNode, to: delay, format: nil)
        audioEngine.connect(delay, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    

    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    @IBAction func playReverbAudio(sender: UIButton) {
        stopAllAudio()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(.Cathedral)
        reverbEffect.wetDryMix = 50
        audioEngine.attachNode(reverbEffect)
        
        audioEngine.connect(audioPlayerNode, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudioWithVariableEcho(1.0, feedback: 80.0)
    }
}
