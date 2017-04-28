//
//  Text+Random.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 25/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public extension String {
    
    public enum RandomType {
        case word
        case sentence
        case paragraph
        case essay
    }
    
    
    // Modified from: http://planetozh.com/blog/2012/10/generate-random-pronouceable-words/
    public static func random(ofLength length: Int) -> String {
        
        enum State {
            case consonant
            case vowel
            
            func next() -> State {
                return self == .consonant ? .vowel : .consonant
            }
        }
        
        // Consonant sounds that can start a word
        let consonantSoundsPrefixes = [
            // single consonants. Beware of Q, it"s often awkward in words
            "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
            "n", "p", "r", "s", "t", "v", "w", "x", "z",
            // possible consonant combinations which can start a word
            "pt", "gl", "gr", "ch", "ph", "ps", "sh", "st", "th", "wh"
        ]
        
        // Consonant sounds that cannot start a word
        let consonantSoundsNonPrefixes = [
            "ck", "cm",
            "dr", "ds",
            "ft",
            "gh", "gn",
            "kr", "ks",
            "ls", "lt", "lr",
            "mp", "mt", "ms",
            "ng", "ns",
            "rd", "rg", "rs", "rt",
            "ss",
            "ts", "tch"
        ]
        
        let allConsonantSounds = consonantSoundsPrefixes + consonantSoundsNonPrefixes
        
        let vowelSounds = [
            // single vowels
            "a", "e", "i", "o", "u", "y",
            // vowel combinations your language allows
            "ee", "oa", "oo",
            // EXPERIMENT: Added to incorporate Q in the mix. Remove if doesn't yield good results.
            "qu", "que"
        ]
        
        // Start with a vowel or consonant?
        var currentState: State = Bool.randomWithLikeliness(likeliness: 0.5) ? .consonant : .vowel
        var word = ""
        
        while word.length() < length {
            
            // After first letter, use all consonant combos
            let consonantSounds = word.length() < 2 ? consonantSoundsPrefixes : allConsonantSounds
            
            let randomString = currentState == .consonant ? consonantSounds.random() : vowelSounds.random()
            
            if length >= word.length() + randomString.length() {
                word += randomString
                currentState = currentState.next()
            }
        }
        
        return word
        
    }
    
    
    public static func random(_ type: RandomType, ofLength length: Int) -> String {
        let randomString: String
        switch type {
        case .word:
            randomString = random(ofLength: length)
            
        case .sentence:
            let randomWords = (1...length).map { _ in
                random(.word, minLength: 2, maxLength: 10)
            }
            randomString = randomWords.joined(separator: " ").capitalizingFirstLetter() + "."
            
        case .paragraph:
            let randomSentences = (1...length).map { _ in
                random(.sentence, minLength: 3, maxLength: 10)
            }
            randomString = randomSentences.joined(separator: " ")
            
        case .essay:
            let randomParagraphs = (1...length).map { _ in
                random(.paragraph, minLength: 4, maxLength: 10)
            }
            randomString = randomParagraphs.joined(separator: "\n\n")
        }
        
        return randomString
    }
    
    
    public static func random(_ type: RandomType, minLength: Int, maxLength: Int) -> String {
        guard minLength > 0, maxLength > 0, minLength <= maxLength else {
            print("Unexpected minLength: \(minLength), maxLength: \(maxLength) encountered while generating random string")
            return ""
        }
        
        let length = Int.random(lower: minLength, upper: maxLength + 1)
        return random(type, ofLength: length)
        
    }
    
    
    
}
