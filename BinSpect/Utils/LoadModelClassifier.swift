//
//  LoadModelClassifier.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 21/05/24.
//

import Foundation
import PhotosUI
import Vision

class ModelClassifierLoader{
    static var model:TrashNBClassifier2?
    static func loadModel(){
        do {
            if model == nil {
                let config = MLModelConfiguration()
                model = try TrashNBClassifier2(configuration: config)
            }
        } catch {
            print("Failed to load the model request")
        }
    }
}
