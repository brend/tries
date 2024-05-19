var t = Trie.root()
var words: [String] = []

func prompt() {
    print("Enter a word (or press Ctrl-D to finish): ", terminator: "")
}

prompt()
while let word = readLine() {
    prompt()
    words.append(word)
}

for word in words {
    t.insert(word: Array(word))
}

print()
print("====== Full tree ======")
print("\(t.dump())")

print("====== Reduced tree ======")
t.shrink()
print("\(t.dump())")

print("====== Abbreviations ======")
let abbrevs = t.computeCyphers()
for abbr in abbrevs {
    print("\(String(abbr.word)) -> \(String(abbr.cypher))")
}

print("====== Abbreviations ======")
let sortedNaturally = abbrevs.map {String($0.word)}.sorted()
let sortedByCypher = abbrevs.sorted {String($0.cypher) < String($1.cypher)}.map {String($0.word)}

print("        Sorted by word: \(sortedNaturally.joined(separator: ", "))")
print("Sorted by abbreviation: \(sortedByCypher.joined(separator: ", "))")
