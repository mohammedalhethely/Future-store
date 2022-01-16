//  ContentView.swift
//  Future store
//  Created by Mohammed Abdullah on 04/05/1443 AH.

import SwiftUI
import RealityKit
import ARKit
import Photos
import QuartzCore

// MARK: - varibales

struct ContentView : View {
    
    @State private var alertIsPresented = false
    @State private var isPlacementEnabled = false
    @State private var selecterModel: Model?
    @State private var modelConfirmedForPlacement: Model?
    @State private var mArView: ARView?
    
    var arViewContainer : ARViewContainer {
        ARViewContainer(modelConfirmedForPlacement: $modelConfirmedForPlacement, mArView: $mArView)
        
    }
    
    // MARK: - clousers for 3D files
    
    private var models: [Model] =  {
        // Dinamically get out model file names
        
        let filemanager = FileManager.default
        guard let path = Bundle.main.resourcePath , let files = try? filemanager.contentsOfDirectory(atPath: path) else {
            return[]
        }
        var availableModels: [Model] = []
        for filename in files where filename.hasSuffix("usdz") {
            let modelName  = filename.replacingOccurrences(of: ".usdz", with: "")
            let model = Model(modelName: modelName)
            availableModels.append(model)
        }
        return availableModels
    }()
    
    // MARK: - function To take a screenshot
    
    func screenshot() -> UIImage {
        
        let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        UIGraphicsBeginImageContext((window?.bounds.size)!)
        
        if let context = UIGraphicsGetCurrentContext() {
            window!.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image!
    }
    var body: some View {
        
        // MARK: - Button to capture the screen and save the image
        
        HStack{
            Spacer()
            GeometryReader { proxy in
                Button(action: {
                    self.alertIsPresented = true
                    arViewContainer.takeShot()
                    
                }, label: {
                    Text("")
                    Circle()
                        .fill(Color.black)
                        .overlay(
                            Image(systemName: "camera.shutter.button")
                                .font(.title2.bold())
                                .foregroundColor(.white)
                                .background(Color.clear)
                            
                        )
                    
                        .frame(width: 60, height: 60)
                        .shadow(color: .white, radius: 10,  y: 5)
                    
                })
                    .alert("saved screen shot in your albums", isPresented: $alertIsPresented, actions: {})
                
            }.frame(height: 65)
        }
        
        // MARK: - this for 3D Pic (Bottom)
        
        ZStack(alignment: .bottom) {
            //ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            arViewContainer
            
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled, selecterModel: self.$selecterModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
                
            }else{
                ModelPIckerView(isPlacementEnabled: self.$isPlacementEnabled, selecterModel: self.$selecterModel, models: self.models)
            }
        }
    }
}

// MARK: -for view VR - Vertual reality

struct ARViewContainer: UIViewRepresentable {
    @Binding var modelConfirmedForPlacement: Model?
    @Binding var mArView : ARView?
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal,.vertical]
        config.environmentTexturing = .automatic
        
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
            config.sceneReconstruction = .mesh
            
        }
        
        arView.session.run(config)
        
        return arView
        
    }
    
    // MARK: - func to take snapshot and save to album
    
    func takeShot(){
        mArView?.snapshot(saveToHDR: false, completion: { image in
            if let image = image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            } else {
                print("could not save it")
            }
            
        })
        
        if mArView != nil {
            print("there is an mArView")
        }
        print("taking a shot")
    }
    
    // MARK: - to load model for scane
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = self.modelConfirmedForPlacement {
            if let modelEntity = model.modelEntity {
                
                print("DEBUG: adding model to scene - \(model.modelName)")
                
                let anchorEntity = AnchorEntity(plane: .any)
                
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity)
                DispatchQueue.main.async {
                    self.mArView = uiView
                }
                
            }else{
                print("DEBUG: unable to load modelEntity for - \(model.modelName)")
            }
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
        }
    }
}

// MARK: - Add product thumbnails

struct ModelPIckerView: View {
    
    @Binding var isPlacementEnabled: Bool
    @Binding var selecterModel: Model?
    var models: [Model]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 30) {
                ForEach(0 ..< self.models.count) {
                    index in
                    Button(action: {
                        print("DEBUG: selected model with name \(self.models[index].modelName)")
                        
                        self.selecterModel = self.models[index]
                        self.isPlacementEnabled = true
                        
                    }) {
                        Image(uiImage: self.models[index].image)
                            .resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1, contentMode: .fit)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.5))
    }
}
struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selecterModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    var body: some View {
        HStack {
            
            // MARK: - check marks
            
            Button(action:{
                print("DEBUG:   plasement confirm canceled.")
                
                self.resetPlacementParameters()
            }){
                Image(systemName: "xmark")
                    .frame(width: 60 , height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            // confirm Button
            Button(action:{
                print("DEBUG:  model plasement confirm.")
                self.modelConfirmedForPlacement = self.selecterModel
                self.resetPlacementParameters()
            }){
                Image(systemName: "checkmark")
                    .frame(width: 60 , height: 60)
                    .font(.title)
                    .background(Color.white.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
                
            }
        }
    }
    func resetPlacementParameters() {
        self.isPlacementEnabled = false
        self.selecterModel = nil
        
        
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
