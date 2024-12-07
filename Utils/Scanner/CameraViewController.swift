import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    private let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "session queue", attributes: [], autoreleaseFrequency: .workItem)
    private let depthDataOutput = AVCaptureDepthDataOutput()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var cameraStream: AVCaptureDevice?
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var outputSynchronizer: AVCaptureDataOutputSynchronizer!
    private let dataOutputQueue = DispatchQueue(label: "data output queue")
    private let visualizationQueue = DispatchQueue(label: "visualization queue")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
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

        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
        } else {
            print("Could not add video data output")
        }

        guard let cameraStream = cameraStream else { return }
        let depthFormats = cameraStream.activeFormat.supportedDepthDataFormats
        let filtered = depthFormats.filter({
            CMFormatDescriptionGetMediaSubType($0.formatDescription) == kCVPixelFormatType_DepthFloat32
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
            }
        } else {
            print("Could not find suitable depth format")
        }

        session.commitConfiguration()
        
        outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: [videoDataOutput, depthDataOutput])
        outputSynchronizer!.setDelegate(self, queue: dataOutputQueue)
    }

    private func visualizeDepth(_ depthData: AVDepthData) {
        visualizationQueue.async {
            let depthMap = depthData.depthDataMap
            depthMap.normalize()
        }
    }
}

extension CameraViewController: AVCaptureDataOutputSynchronizerDelegate {
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        guard let syncedDepthData = synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData else {
            return
        }

        var depthData = syncedDepthData.depthData
        depthData = depthData.converting(toDepthDataType: kCVPixelFormatType_DisparityFloat32)
        visualizeDepth(depthData)
    }
}