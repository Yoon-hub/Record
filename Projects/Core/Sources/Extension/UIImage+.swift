//
//  UIImage+.swift
//  Core
//
//  Created by 윤제 on 7/12/24.
//

import UIKit

public extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
           let size = self.size

           let widthRatio  = targetSize.width  / size.width
           let heightRatio = targetSize.height / size.height

           // Determine the scale factor that preserves aspect ratio
           let scaleFactor = min(widthRatio, heightRatio)

           // Compute the new image size that preserves aspect ratio
           let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

           // Create a new image context
           UIGraphicsBeginImageContextWithOptions(scaledImageSize, false, 0.0)
           self.draw(in: CGRect(origin: .zero, size: scaledImageSize))

           // Create a new image from the context
           let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()

           return resizedImage!
       }
    
    func toData(compressionQuality: CGFloat = 1.0) -> Data {
        guard let data = self.jpegData(compressionQuality: compressionQuality) else { fatalError() }
        return data
    }
}

public extension Data {
    func toImage() -> UIImage? {
        return UIImage(data: self)
    }
}
