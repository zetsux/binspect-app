//
//  ResultViewModel.swift
//  BinSpect
//
//  Created by Kevin Nathanael Halim on 21/05/24.
//

import Foundation
import Observation
import UIKit
import CoreML
import Vision

@Observable class ResultViewModel{

    var request: VNCoreMLRequest?
    var type: String = "Loading..."
    var confidence: Double = 0.0
    
    func classifyTrashImage(image: UIImage, trashClassifier: TrashNBClassifier2) {
        if request == nil {
            if let visionModel = try? VNCoreMLModel(for: trashClassifier.model) {
                request = VNCoreMLRequest(model: visionModel) { request, error in
                    if let results = request.results
                        as? [VNClassificationObservation] {
                        if results.isEmpty {
                            self.type = "Nothing found.."
                        } else {
                            self.type = results[0].identifier == "B" ? "Organic" : "Inorganic"
                            self.confidence = Double(results[0].confidence * 100)
                        }
                    } else if let error = error {
                        self.type = "Failed"
                        print("error: \(error.localizedDescription)")
                    } else {
                        self.type = "???"
                    }
                }
                request?.imageCropAndScaleOption = .scaleFill
            }
        }
        guard let ciImage = CIImage(image: image) else {
            print("Unable to create CIImage")
            return
        }
        
        if let request {
            let handler = VNImageRequestHandler(ciImage: ciImage)
            try? handler.perform([request])
        }
    }
}
