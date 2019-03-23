//
//  question.swift
//  quizzesApp
//
//  Created by sy on 2019/3/21.
//  Copyright © 2019 sy. All rights reserved.
//

import Foundation

class Question {
    let text: String?
    var answer: Bool
    
    init() {
        self.text = nil
        self.answer = false
    }
    
    init(text: String?, answer: Bool) {
        self.text = text
        self.answer = answer
    }
}
