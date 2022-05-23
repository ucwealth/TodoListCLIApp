import Foundation

extension String {
    func fileName() -> String{
        return URL(fileURLWithPath: self).deletingPathExtension().lastPathComponent
    }
    
    func fileExtension() -> String{
        return URL(fileURLWithPath: self).pathExtension
    }
}

func readFile(inputFile: String) -> String{
    let fileName = inputFile.fileName()
    let fileExtension = inputFile.fileExtension()
    
    let fileUrl = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let inputFile = fileUrl.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    
    do {
        let savedData = try! String(contentsOf: inputFile)
        return savedData
    } catch {
        return error.localizedDescription
    }
}

func writeFile(outputFile: String, stringData: String) {
    let fileName = outputFile.fileName()
    let fileExtension = outputFile.fileExtension()
    
    let fileUrl = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    let outputFile = fileUrl.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
    
    guard let data = stringData.data(using: .utf8) else {
        print("Unable to convert string to data")
        return
    }
    do {
        try data.write(to: outputFile)
        print("Data Written:  + \(data)")
    } catch {
        print(error.localizedDescription)
    }

}

/*
 - read todos
 - write todos
 - list todos
 - mark todos as complete
 
 */

////var myData = readFile(inputFile: "input.txt")
//writeFile(outputFile: "/Users/decagon/Desktop/PROJECTS/UIKit-Programmatic/TodoListApp/output.txt", stringData: "Hello there")

 
let filePath = NSHomeDirectory() + "/Desktop/test.txt"
let filename = getDocumentsDirectory().appendingPathComponent("output.txt")
//let filePath = "/Users/decagon/Desktop/PROJECTS/UIKit-Programmatic/TodoListApp/output.txt"
if (FileManager.default.createFile(atPath: filePath, contents: nil, attributes: nil)) {
    print("File created successfully.")
} else {
    print("File not created.")
}

print(filename)
