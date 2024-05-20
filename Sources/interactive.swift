//
//  interactive.swift
//
//
//  Created by Philipp Brendel on 20.05.24.
//

import Foundation

func readWords() -> [String] {
    func prompt() {
        print("Enter a word (or press Ctrl-D to finish): ", terminator: "")
    }
    
    var words: [String] = []
    prompt()
    while let word = readLine() {
        prompt()
        words.append(word)
    }
    
    return words
}
