
//  ViewController.swift
//  SmartSight
//  Created by Sidhant Chadha on 8/16/18.
//  Copyright © 2018 AMoDynamics, Inc. All rights reserved.

import UIKit
import AVKit
import Vision
import AVFoundation
import AudioToolbox
import ChameleonFramework

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var cameraView: UIImageView!

    
    @IBAction func contactButton(_ sender: Any) {
        performSegue(withIdentifier: "contactSegue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    
    
    @IBOutlet weak var logoDisp: UIImageView!

  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(gradientStyle: UIGradientStyle.topToBottom, withFrame: view.frame, andColors:[FlatGrayDark(), FlatWhite()])
        navigationController?.navigationBar.barTintColor = FlatGray()
        navigationController?.navigationBar.tintColor = FlatBlack()
        setupInputOutputLayer()
        
    }
    
    //To pause detection whenever user is not on active camera screen
    func setupInputOutputLayer() {
        
        //Create instance of AVCaptureSession
        let captureSession = AVCaptureSession()
        
        //Set input/capture quality
        captureSession.sessionPreset = .photo
        
        //Define source for input
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        //Transfer input from sensor to the capture session
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        //Start flow of data from input sensor to the CaptureSession
        captureSession.startRunning()
        
        //Bind live input(from sensor) to the view
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = cameraView.frame
        
        
        //Setup output frames from input video
        let dataOutput = AVCaptureVideoDataOutput()
        
        //Setup buffer-frame delegate and queue for invoking callbacks
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        
        //Provide output frame to the capture session for processing
        captureSession.addOutput(dataOutput)
    }
    
    
    
    //Process each individual frame received and compare against pre-set model//
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        //Setup reference to frame/image received in memory
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        //Setup model to compare the output frames. Models are interchangable based on use
        //Using MobileNet model for prediction in this case
        
        guard let model = try? VNCoreMLModel(for: MobileNet().model ) else { return }
        
        //Initiate frame prediction against pre-set model
        let startPrediction = VNCoreMLRequest(model: model) { (completePrediction, err) in
            
            //Setup collection type for prediction results
            guard let predictionResults = completePrediction.results as? [VNClassificationObservation] else { return }
            
            //Capture the first prediction result
            guard let firstPrediction = predictionResults.first else { return }
            
            //Store reference to predicted object
            let predictedObject = firstPrediction.identifier
            //Convert prediction confidence into accuracy percentage//
            let accuracyPercentage = String(format: "%.2f", firstPrediction.confidence*100)
            //Print prediction result to console for testing
            print(predictedObject,accuracyPercentage)
            
            //Switch back to main thread
            DispatchQueue.main.async {
                self.resultLabel.text = "\(predictedObject)"
                self.accuracyLabel.text = "\(accuracyPercentage)%"
               // if self.resultLabel.text == "water bottle" {
                   // AudioServicesPlaySystemSound(1304)
                if Double(accuracyPercentage)! > 35.00 {
                    let utterance = AVSpeechUtterance(string: self.resultLabel.text!)
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    utterance.rate = 0.5
                    
                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
               }
            }
         
        }
        
        //Handle multiple comparisons on single frame/image
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([startPrediction])
    }
    
}

