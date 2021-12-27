//  model.swift
//  Future store
//  Created by Mohammed Abdullah on 05/05/1443 AH.

import UIKit
import ReplayKit
import Combine
import RealityKit

class Model {
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    
    private var cancellable: AnyCancellable? = nil
    
    init(modelName: String) {
        self.modelName = modelName
        self.image = UIImage(named: modelName)!
        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync(named: filename).sink(receiveCompletion: { loadCompletion in
            // handle our error
            print("DEBUG: Unable to load modelEntity for modelName \(self.modelName)")
        }, receiveValue: { modelEntity in
            // get our modelEntity
            self.modelEntity = modelEntity
            print("DEBUG: successfully loaded modelEntity for modelName \(self.modelName)")
        })
       }
      }
