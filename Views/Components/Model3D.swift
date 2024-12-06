// Model3D.swift
import SwiftUI
import SceneKit

struct Model3D: UIViewRepresentable {
    let modelName: String

    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.backgroundColor = .clear

        // Load the scene
        let scene = SCNScene()
        if let objScene = loadModel(named: modelName) {
            scene.rootNode.addChildNode(objScene.rootNode)
        }

        sceneView.scene = scene
        return sceneView
    }

    func updateUIView(_ uiView: SCNView, context: Context) {
        // No updates needed for now
    }

    private func loadModel(named name: String) -> SCNScene? {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
            print("Failed to find \(name) in bundle.")
            return nil
        }

        do {
            let scene = try SCNScene(url: url, options: nil)
            return scene
        } catch {
            print("Error loading \(name): \(error)")
            return nil
        }
    }
}

struct Model3D_Previews: PreviewProvider {
    static var previews: some View {
        Model3D(modelName: "test_obj.obj")
            .frame(width: 200, height: 200)
    }
}
