import UIKit
import AVFoundation
import Metal
import os.log

class CameraViewController: UIViewController {

    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.example.skanit", category: "CameraViewController")

    private var captureSession: AVCaptureSession!
    private let sessionQueue = DispatchQueue(label: "session queue", attributes: [], autoreleaseFrequency: .workItem)

    private var videoDataOutput: AVCaptureVideoDataOutput!
    private var textureCache: CVMetalTextureCache?

    private var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CVMetalTextureCacheCreate(nil, nil, MTLCreateSystemDefaultDevice()!, nil, &textureCache)

        setupCaptureSession()
    }

    private func setupCaptureSession() {
        captureSession = AVCaptureSession()
        
        sessionQueue.async {
            self.configureSession()
        }
    }

    private func configureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .back) else {
            logger.error("TrueDepth camera is not available on this device")
            return
        }

        do {
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            captureSession.beginConfiguration()
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
            } else {
                logger.error("Could not add video device input to the session")
                captureSession.commitConfiguration()
                return
            }

            videoDataOutput = AVCaptureVideoDataOutput()
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
            
            if captureSession.canAddOutput(videoDataOutput) {
                captureSession.addOutput(videoDataOutput)
            } else {
                logger.error("Could not add video data output to the session")
                captureSession.commitConfiguration()
                return
            }

            captureSession.commitConfiguration()
            
            self.captureSession.startRunning()
            self.logger.info("Capture session started.")
            
            DispatchQueue.main.async {
                self.setupPreviewLayer()
            }
            
        } catch {
            logger.error("Error setting up capture session: \(error.localizedDescription)")
            captureSession.commitConfiguration()
            return
        }
    }

    private func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        logger.info("Preview layer setup completed successfully.")
    }

}
