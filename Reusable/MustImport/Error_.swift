//
//  Error_.swift
//  PitchPerfect
//
//  Created by Shobhit Gupta on 25/03/17.
//  Copyright © 2017 Shobhit Gupta. All rights reserved.
//

import Foundation

public enum Error_ {
    // Extend Error_ in individual files.
    // Then import this file along with specific files that need to be reused in future projects.
}

// Add/Remove or Comment/Uncomment nested enums according to which piece of code you reuse.
public extension Error_ {
    
    enum Audio {
        
    }
    
}


extension Error {
    func info() -> String {
        let description: String
        let objectDescription = String(describing: self)
        let localizedDescription = self.localizedDescription
        
        if localizedDescription == ""  || objectDescription.contains(localizedDescription) {
            description = objectDescription
        } else if localizedDescription.contains(objectDescription) {
            description = localizedDescription
        } else {
            description = objectDescription + ": " + localizedDescription
        }
        
        return description
    }
}
