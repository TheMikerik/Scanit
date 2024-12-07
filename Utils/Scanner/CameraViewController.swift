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
            }
        } else {
            print("Could not find suitable depth format")
        }

        session.commitConfiguration()
        
        outputSynchronizer = AVCaptureDataOutputSynchronizer(dataOutputs: [videoDataOutput, depthDataOutput])
        outputSynchronizer!.setDelegate(self, queue: dataOutputQueue)
    }
}

extension CameraViewController: AVCaptureDataOutputSynchronizerDelegate {
    func dataOutputSynchronizer(_ synchronizer: AVCaptureDataOutputSynchronizer, didOutput synchronizedDataCollection: AVCaptureSynchronizedDataCollection) {
        if let syncedDepthData = synchronizedDataCollection.synchronizedData(for: depthDataOutput) as? AVCaptureSynchronizedDepthData {
            var depthData = syncedDepthData.depthData

            depthData = depthData.converting(
                toDepthDataType: kCVPixelFormatType_DisparityFloat32
            )


            visualizeDepth(depthData)
        }
    }
    
    private func visualizeDepth(_ depthData: AVDepthData) {
        let depthMap = depthData.depthDataMap
        let normalizedMap = normalizeDepthMap(depthMap)


    }

    private func normalizeDepthMap(_ depthMap: CVPixelBuffer) -> [Float] {
        CVPixelBufferLockBaseAddress(depthMap, CVPixelBufferLockFlags.readOnly)
        
        let width = CVPixelBufferGetWidth(depthMap)
        let height = CVPixelBufferGetHeight(depthMap)
        // This may be unsafe, maybe it will cause problems later idk
        let mapBuffer = CVPixelBufferGetBaseAddress(depthMap)!.assumingMemoryBound(to: Float32.self)
        
        var normalizedDepthMap: [Float] = []

        let firstPixel = mapBuffer[0]
        var minDepth: Float = firstPixel
        var maxDepth: Float = firstPixel

        for y in 0..<height {
            for x in 0..<width {
                let pixel = mapBuffer[y * width + x]
                if pixel < minDepth {
                    minDepth = pixel
                }
                if pixel > maxDepth {
                    maxDepth = pixel
                }
            }
        }

        let range = maxDepth - minDepth

        for y in 0..<height {
            for x in 0..<width {
                let pixel = mapBuffer[y * width + x]
                let normalizedPixel = (pixel - minDepth) / range
                normalizedDepthMap.append(normalizedPixel)
            }
        }

        CVPixelBufferUnlockBaseAddress(depthMap, CVPixelBufferLockFlags.readOnly)
        
        return normalizedDepthMap
    }
}
