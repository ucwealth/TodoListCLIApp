import Foundation

func getDesktopDirectory() -> URL {
    let paths = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)
    return paths[0]
}
let fileURL = getDesktopDirectory().appendingPathComponent("/PROJECTS/UIKit-Programmatic/TodoListApp/todos.json")

struct Item: Codable {
    var name: String
    var isCompleted: Bool = false

    enum CodingKeys: String, CodingKey {
        case name
    }
}

var array: [Item] = {
    do {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        let items = try decoder.decode([Item].self, from: data)
        return items
    } catch {
        print(error.localizedDescription)
        return []
    }
}()

func writeJSON(items: [Item]) {
    do {
        let encoder = JSONEncoder()
        try encoder.encode(array).write(to: fileURL)
    } catch {
        print(error.localizedDescription)
    }
}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) {
        (lhs.name, lhs.isCompleted) == (rhs.name, rhs.isCompleted)
    }
    
    @discardableResult
    mutating func updateAndWrite(name: String? = nil, isCompleted: Bool = false, at url: URL) throws -> [Item]? {
        var items = try JSONDecoder().decode([Item].self, from: .init(contentsOf: url))
        if let index = items.firstIndex(of: self) {
            self.name = name ?? self.name
            self.isCompleted = isCompleted ?? self.isCompleted
            items[index] = self
            try JSONEncoder().encode(items).write(to: url, options: .atomic)
            return items
        }
        return nil
    }
}


let inputArgs = CommandLine.arguments.dropFirst(2)
let inputStr = inputArgs.joined(separator: " ")



enum Commands: String {
    case add = "-add"
    case list = "-list"
    case complete
    case del
}

var CommandLineArg = CommandLine.arguments[1]
//var num = 0
switch CommandLineArg {
case "-add":
    if CommandLineArg != CommandLine.arguments.last {
        array.append(Item(name: inputStr))
        writeJSON(items: array)
    }
case "-list":
    for task in 0..<array.count {
        print(" {\(task + 1)} \(array[task].name) \n")
    }
case "-complete=\(num)":
    num = Int(CommandLineArg.suffix(1))!
    let lastGuy = num
    if array.count <= lastGuy {
        for task in 0..<array.count {
            if task == lastGuy - 1 {
                print(" {\(task+1)*} \(array[task].name) \n")
            } else {
                print(" {\(task+1 )} \(array[task].name) \n")
            }
            
        }
    }
    print("completed!")
case "-del=":
    // delete a row
    print("delete")
default:
    print("Command not recognized. Available options are: (1) -add (2) -list (3) -complete={row_number} (4) -del={row_number} ")

}
