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

enum Option {
    case logging, shrinking, abbreviations
}

func process(words: [String],
             options: [Option] = [.logging, .shrinking, .abbreviations],
             log: ((_: String) -> ())? = nil) {
    let log = options.first {$0 == .logging}.map {_ in log ?? printLog} ?? { _ in }
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
    
    if options.first(where: {$0 == .shrinking}) != nil {
        t.shrink()
        logTrie("Reduced Tree")
    }
    
    if options.first(where: {$0 == .abbreviations}) != nil {
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
