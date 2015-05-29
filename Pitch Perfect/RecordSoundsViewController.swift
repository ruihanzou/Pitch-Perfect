//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Ruihan Zou on 5/23/15.
//  Copyright (c) 2015 Ruihan Zou. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var tapToRecord: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    let tapToRecordText = "Tap to record"
    let recordingInProgress = "Recording..."
    let resume = "Resume"
    
    //@IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true
        //Hide the pause button
        pauseButton.hidden = true
        //Hide the resume button
        resumeButton.hidden = true
        //SHOW the record button
        recordButton.hidden = false
        //Change the tapToRecord text
        tapToRecord.text = tapToRecordText
        
    }

    @IBAction func recordAudio(sender: UIButton) {
        //TODO: HIDE record button
        recordButton.hidden = true
        
        //TODO: SHOW pause button
        pauseButton.hidden = false
        
        //TODO: Change TEXT "Tap to Record"
        tapToRecord.text = recordingInProgress
        
        //TODO: Show the STOP button
        stopButton.hidden = false
        
        //TODO: Record the user's voice
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        // Setup audio session
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // Initialize and prepare the recorder
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            //TODO: Step 1 - Save the recorded audio
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            //TODO: Step 2 - Move to the next scene aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not sucessful")
            recordButton.hidden = false
            tapToRecord.hidden = false
            stopButton.hidden =  true
            pauseButton.hidden = true
        }
       
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording" && sender is RecordedAudio) {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
             playSoundsVC.receivedAudio = data
        }
    }
    @IBAction func stopAudio(sender: UIButton) {
        //TODO: Stop recording
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
    }

    @IBAction func pauseAudio(sender: UIButton) {
         //TODO: pause the audio recording
        audioRecorder.pause()
        tapToRecord.text = resume 
        pauseButton.hidden = true
        resumeButton.hidden = false
        
    }
    @IBAction func resumeAudio(sender: UIButton) {
        //TODO: resume the audio recording
        audioRecorder.record()
        resumeButton.hidden = true
        pauseButton.hidden = false
        tapToRecord.text = recordingInProgress
    }
}

