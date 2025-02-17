struct Trie<Letter> where Letter: Equatable {
    typealias Word = [Letter]
    
    var letter: Letter? = nil
    var children: [Self] = []
    var words: [Word] = []
    
    init(value: Letter? = nil) {
        self.letter = value
    }
    
    var isRoot: Bool {
        letter == nil
    }
}

extension Trie {
    mutating func insert<C1, C2>(word: C1, originalWord: C2)
    where C1: Collection, C1.Element == Letter, C2: Collection, C2.Element == Letter {
        guard let firstLetter = word.first else {
            words.append(Array(originalWord))
            return
        }
        
        let remainder = word.dropFirst()
        
        if let index = children.firstIndex(where: {$0.letter == firstLetter}) {
            children[index].insert(word: remainder, originalWord: originalWord)
        } else {
            var newChild = Trie(value: firstLetter)
            newChild.insert(word: remainder, originalWord: originalWord)
            children.append(newChild)
        }
    }
    
    mutating func insert<C>(word: C) where C: Collection, C.Element == Letter {
        insert(word: word, originalWord: word)
    }
}

extension Trie {
    mutating func shrink() {
        for i in 0..<children.count {
            children[i].shrink()
        }
        if children.count == 1 && words.isEmpty && !isRoot {
            let onlyChild = children[0]
            children = onlyChild.children
            words = onlyChild.words
        }
    }
        
    struct Abbrev {
        let word: Word
        let cypher: Word
    }

    func computeCyphers() -> [Abbrev] {
        var abbrevs: [Abbrev] = []
        computeCyphers(abbrevs: &abbrevs)
        return abbrevs
    }
    
    private func computeCyphers(abbrevs: inout [Abbrev], path: Word = []) {
        let newPath = path + (letter.map { [$0] } ?? [])
        for word in words {
            abbrevs.append(Abbrev(word: word, cypher: newPath))
        }
        for child in children {
            child.computeCyphers(abbrevs: &abbrevs, path: newPath)
        }
    }
}

extension Trie {
    func dump(_ indentation: String = "", _ increment: String = "  ") -> String {
        "\(indentation)\(isRoot ? "" : String(describing: letter!))  \(words.isEmpty ? "" : "(\(words.map({String(describing: $0)}).joined(separator: ", ")))")\n\(children.reduce("", {"\($0)\($1.dump("\(indentation)\(increment)"))"}))"
    }
}
