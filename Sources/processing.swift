//
//  processing.swift
//
//
//  Created by Philipp Brendel on 20.05.24.
//

import Foundation

func printLog(_ message: String) {
    print(message)
}

struct Options: OptionSet {
    let rawValue: Int
    static let logging = Options(rawValue: 1 << 0)
    static let shrinking = Options(rawValue: 1 << 1)
    static let abbreviating = Options(rawValue: 1 << 2)
    static let all: Options = [.logging, .shrinking, .abbreviating]
}

func process(words: [String],
             options: Options = .all,
             log: ((_: String) -> ())? = nil) {
    let log = options.contains(.logging) ? (log ?? printLog) : { _ in }
    var t = Trie<Character>()
    func logTrie(_ message: String) {
        log("")
        log("========= \(message) =========")
        log("\(t.dump())")
    }
    for word in words {
        t.insert(word: Array(word))
    }
    
    logTrie("Prefix Tree")
    
    if options.contains(.shrinking) {
        t.shrink()
        logTrie("Reduced Tree")
    }
    
    if options.contains(.abbreviating) {
        let abbrevs = t.computeCyphers()
        for abbr in abbrevs {
            print("\(String(abbr.word)) -> \(String(abbr.cypher))")
        }
        
        log("========= Abbreviations =========")
        let sortedNaturally = abbrevs.map {String($0.word)}.sorted()
        let sortedByCypher = abbrevs.sorted {String($0.cypher) < String($1.cypher)}.map {String($0.word)}
        
        log("        Sorted by word: \(sortedNaturally.joined(separator: ", "))")
        log("Sorted by abbreviation: \(sortedByCypher.joined(separator: ", "))")
    }
}
