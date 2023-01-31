import Foundation
import SwiftUI

class FileManagerOperator {
    class func createDirectory(directoryName: String) {
        let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directory = documentDirectoryFileURL.appendingPathComponent(directoryName, isDirectory: true)

        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    class func createFile(directoryName: String, fileName: String, contents: Data) {
        var pathString = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        pathString = "file://" + pathString + "/" + "\(directoryName)/"
        guard let directoryPath = URL(string: pathString) else { return }
        let filePath = directoryPath.appendingPathComponent(fileName)
        
        do {
            try contents.write(to: filePath)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func convertToDataFromUIImage(image: UIImage) -> Data? {
        return image.pngData()
    }
}
