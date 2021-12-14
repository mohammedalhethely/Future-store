//
//  ContentView.swift
//  Future store
//
//  Created by Mohammed Abdullah on 04/05/1443 AH.
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    
    @State private var isPlacementEnabled = false
    @State private var selecterModel: Model?
    @State private var modelConfirmedForPlacement: Model?
    
    
//    var models:[String] = ["chair","tv","wateringView"]
    
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
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ARViewContainer(modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            
            if self.isPlacementEnabled {
                PlacementButtonsView(isPlacementEnabled: self.$isPlacementEnabled, selecterModel: self.$selecterModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
                
            }else{
                ModelPIckerView(isPlacementEnabled: self.$isPlacementEnabled, selecterModel: self.$selecterModel, models: self.models)
            }
           }
          }
         }
struct ARViewContainer: UIViewRepresentable {
 @Binding var modelConfirmedForPlacement: Model?
    
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
    
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = self.modelConfirmedForPlacement {
            if let modelEntity = model.modelEntity {
                
                print("DEBUG: adding model to scene - \(model.modelName)")
                let anchorEntity = AnchorEntity(plane: .any)
                
                anchorEntity.addChild(modelEntity)
                uiView.scene.addAnchor(anchorEntity)
                
                
            }else{
                print("DEBUG: unable to load modelEntity for - \(model.modelName)")
            }
            
            DispatchQueue.main.async {
                self.modelConfirmedForPlacement = nil
            }
           }
          }
         }

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
        .padding(50)
        .background(Color.black.opacity(0.5))
    }
   }
struct PlacementButtonsView: View {
    @Binding var isPlacementEnabled: Bool
    @Binding var selecterModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    var body: some View {
        HStack {
            // cancel Button
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
