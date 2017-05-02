//
//  Text+Random.swift
//  MemeMe
//
//  Created by Shobhit Gupta on 25/04/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation


public extension String {
    
    public enum RandomType: CanGenerateRandomValues {
        case word
        case sentence
        case paragraph
        case essay
    }
    
    
    // Modified from: http://planetozh.com/blog/2012/10/generate-random-pronouceable-words/
    private static func random(ofLength length: Int) -> String {
        
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
        var currentState: State = Bool.random() ? .consonant : .vowel
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
                random(.word,
                       minLength: Default.Random.Word.Length.Min,
                       maxLength: Default.Random.Word.Length.Max)
            }
            randomString = randomWords.joined(separator: Default.Random.Word.Separator).capitalizingFirstLetter() + Default.Random.Sentence.Finisher
            
        case .paragraph:
            let randomSentences = (1...length).map { _ in
                random(.sentence,
                       minLength: Default.Random.Sentence.Length.Min,
                       maxLength: Default.Random.Sentence.Length.Max)
            }
            randomString = randomSentences.joined(separator: Default.Random.Sentence.Separator)
            
        case .essay:
            let randomParagraphs = (1...length).map { _ in
                random(.paragraph,
                       minLength: Default.Random.Paragraph.Length.Min,
                       maxLength: Default.Random.Paragraph.Length.Max)
            }
            randomString = randomParagraphs.joined(separator: Default.Random.Paragraph.Separator)
        }
        
        return randomString
    }
    
    
    public static func random(_ type: RandomType, minLength: Int, maxLength: Int) -> String {
        guard minLength > 0, maxLength > 0, minLength <= maxLength else {
            print(Error_.Random.UnexpectedStringLengths(min: minLength, max: maxLength).localizedDescription)
            return ""
        }
        
        let length = Int.random(lower: minLength, upper: maxLength + 1)
        return random(type, ofLength: length)
        
    }
    
    
}


public extension Default.Random {
    
    enum Word {
        enum Length {
            static let Min = 2
            static let Max = 10
        }
        static let Separator = " "
    }
    
    enum Sentence {
        enum Length {
            static let Min = 3
            static let Max = 10
        }
        static let Separator = " "
        static let Finisher = "."
    }
    
    enum Paragraph {
        enum Length {
            static let Min = 4
            static let Max = 10
        }
        static let Separator = "\n\n"
    }
    
}
