import UIKit
import AVFoundation

// https://developer.apple.com/documentation/avfoundation/streaming-depth-data-from-the-truedepth-camera#Overview
class CameraViewController: UIViewController {
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue", attributes: [], autoreleaseFrequency: .workItem)
    private let depthDataOutput = AVCaptureDepthDataOutput()
    private var cameraStream: AVCaptureDevice?
    private var previewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize AVCaptureVideoPreviewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Configure the session in the background
        sessionQueue.async { [unowned self] in
            configureSession()
            session.startRunning()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }

    private func configureSession() {
        session.beginConfiguration()

        // Set up video device input
        if let phoneCamera = AVCaptureDevice.default(.builtInTrueDepthCamera, for: .video, position: .front) {
            cameraStream = phoneCamera
            if let input = try? AVCaptureDeviceInput(device: phoneCamera), session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("Could not add video device input")
            }
        } else {
            print("No TrueDepth camera available")
        }

        // Add depth data output
        if session.canAddOutput(depthDataOutput) {
            session.addOutput(depthDataOutput)
            depthDataOutput.isFilteringEnabled = false
            if let connection = depthDataOutput.connection(with: .depthData) {
                connection.isEnabled = true
            } else {
                print("No AVCaptureConnection")
            }
        } else {
            print("Could not add depth data output")
        }

        // Configure depth data format
        guard let cameraStream = cameraStream else { return }
        let depthFormats = cameraStream.activeFormat.supportedDepthDataFormats
        let filtered = depthFormats.filter({
            CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat16
        })
        if let selectedFormat = filtered.max(by: { first, second in
            CMVideoFormatDescriptionGetDimensions(first.formatDescription).width < CMVideoFormatDescriptionGetDimensions(second.formatDescription).width
        }) {
            do {
                try cameraStream.lockForConfiguration()
                cameraStream.activeDepthDataFormat = selectedFormat
                cameraStream.unlockForConfiguration()
            } catch {
                print("Could not lock device for configuration: \(error)")
                setupResult = .configurationFailed
                session.commitConfiguration()
                return
            }
        } else {
            print("Could not find suitable depth format")
        }

        session.commitConfiguration()
    }
}