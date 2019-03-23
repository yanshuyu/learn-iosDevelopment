//
//  questionFactory.swift
//  quizzesApp
//
//  Created by sy on 2019/3/21.
//  Copyright © 2019 sy. All rights reserved.
//

import Foundation

class QuestionFactory {
    private static var instance: QuestionFactory?
    private var questiones: [Question]
    var questionCategory: String?
    
    private init() {
        self.questiones = []
        self.questionCategory = ""
    }
    
    public static func getInstance() -> QuestionFactory {
        if QuestionFactory.instance == nil {
            QuestionFactory.instance = QuestionFactory()
        }
        
        return QuestionFactory.instance!
    }
    
    public static func releaseInstance() {
        QuestionFactory.instance = nil
    }
    
    public func setQuestionCategory(_ category: String?) {
        self.questionCategory = category
    }
    
    public func initQuestions(_ questiones: [Question]) {
        self.questiones = questiones
    }
    
    public func appendQuestion(_ question: Question) {
        self.questiones.append(question);
    }
    
    public func clear() {
        self.questiones = []
        self.questionCategory = ""
    }
    
    public func getQuestionCount() -> Int {
        return self.questiones.count
    }
    
    public func getQuestionCategory() -> String? {
        return self.questionCategory
    }
    
    public func getQuestion(_ index: Int) -> Question? {
        if index < 0 || index >= self.questiones.count {
            return nil
        }
        
        return self.questiones[index]
    }
        
}

