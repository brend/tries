typealias Letter = Character
typealias Text = [Letter]

class Trie {
    var value: Letter?
    var children: [Trie] = []
    var words: [Text] = []
    init(value: Letter?) {
        self.value = value
    }
}

extension Trie {
    static func root() -> Trie {
        Trie(value: nil)
    }

    func addChild(value: Letter) -> Trie {
        let newChild = Trie(value: value)
        self.children.append(newChild)
        return newChild
    }

    func insert(word: Text, originalWord: Text) {
        guard let firstLetter = word.first else { 
            self.words.append(originalWord)
            return 
        }
        let remainder = Array(word[1..<word.count])
        let child = self.children.first(where: {$0.value == firstLetter}) ?? self.addChild(value: firstLetter)
        child.insert(word: remainder, originalWord: originalWord)
    }

    func insert(word: Text) {
        self.insert(word: word, originalWord: word)
    }
}

extension Trie {
    func dump(_ indentation: String = "", _ increment: String = "  ") -> String {
        "\(indentation)\(value ?? Letter(" "))  \(words.isEmpty ? "" : "(\(words.map({String($0)}).joined(separator: ", ")))")\n\(children.reduce("", {"\($0)\($1.dump("\(indentation)\(increment)"))"}))"
    }
}

extension Trie {
    func shrink() {
        for child in self.children {
            child.shrink()
        }
        if self.children.count == 1 && self.words.isEmpty &&
            self.value != nil, 
            let onlyChild = self.children.first {
            self.children = onlyChild.children
            self.words = onlyChild.words
        }
    }

    func computeCyphers() -> [Abbrev] {
        var abbrevs: [Abbrev] = []
        self.computeCyphers(abbrevs: &abbrevs)
        return abbrevs
    }

    func computeCyphers(abbrevs: inout [Abbrev], path: Text = []) {
        let newPath = value == nil ? path : path + [value!]
        for word in words {
            abbrevs.append(Abbrev(word: word, cypher: newPath))
        }
        for child in children {
            child.computeCyphers(abbrevs: &abbrevs, path: newPath)
        }
    }
}

struct Abbrev {
    let word: Text
    let cypher: Text
}
