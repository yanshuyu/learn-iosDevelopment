//
//  ViewController.swift
//  quizzesApp
//
//  Created by sy on 2019/3/21.
//  Copyright © 2019 sy. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var cateLable: UILabel!
    @IBOutlet weak var questionLable: UILabel!
    @IBOutlet weak var progressLable: UILabel!
    @IBOutlet weak var scoreLable: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var trueButton: UIButton!
    
    var curQuestionIndex = -1
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let questiones = [Question(text: "南北美洲之间的分界线是巴拿马运河", answer: true),
                          Question(text: "中国五大经济特区是: 深圳、珠海、汕头、厦门、海南", answer: true),
                          Question(text: "南美洲面积最大的国家是阿根廷", answer: false),
                          Question(text: "世界七大洲中海拔最高的是非洲", answer: false),
                          Question(text: "东南亚最长的国际性河流是湄公河", answer: true),
                          Question(text: "印度的茶叶茶叶产量世界第一", answer: true),
                          Question(text: "现存最著名的三大金字塔包括艾菲尔铁塔", answer: false)]
        QuestionFactory.getInstance().initQuestions(questiones)
        QuestionFactory.getInstance().setQuestionCategory("世界地理常识")
        
        self.progressQuestionAndUpdateView()
    }
    
    func progressQuestionAndUpdateView() {
        self.curQuestionIndex += 1
        
        let question = QuestionFactory.getInstance().getQuestion(self.curQuestionIndex)
        if question == nil {
            self.showAlertViewAskForReloadQuestionProgress()
            return
        }
        
        self.cateLable.text = QuestionFactory.getInstance().getQuestionCategory()
        self.questionLable.text = question?.text
        self.progressLable.text = "\(self.curQuestionIndex+1)/\(QuestionFactory.getInstance().getQuestionCount())"
        self.scoreLable.text = "score: \(self.score)"
        self.progressBar.setProgress((Float)(self.curQuestionIndex+1) / (Float)(QuestionFactory.getInstance().getQuestionCount()), animated: true)
    }
    
    func reloadQuestionProgress(){
        self.curQuestionIndex = -1
        self.score = 0
        self.progressQuestionAndUpdateView()
    }
    
    func showAlertViewAskForReloadQuestionProgress() {
        let alertController = UIAlertController(title: "无更多问题", message: "这是最后一个问题啦！您想要再试一次吗？", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "退出", style: .destructive, handler: {(action: UIAlertAction) -> Void in
            self.quitApplication()
        }))
        alertController.addAction(UIAlertAction(title: "再试一次", style: .default, handler: {(action: UIAlertAction) -> Void in
            self.reloadQuestionProgress()
        }))
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func quitApplication() -> Void {
        //QuestionFactory.getInstance().clear()
        //QuestionFactory.releaseInstance()
        self.trueButton.sendAction(Selector("suspend"), to: UIApplication.shared, for: nil)
    }

    @IBAction func onAnswerBtnClick(_ sender: UIButton) {
        let isTureButton = sender.tag == 1
        let question = QuestionFactory.getInstance().getQuestion(self.curQuestionIndex)
        if question != nil {
            let isTureAnwser = isTureButton == question?.answer
            self.score =  isTureAnwser ? self.score+1 : self.score
            
            if isTureAnwser {
                ProgressHUD.showSuccess("回答正确")
            }else{
                ProgressHUD.showError("回答错误")
            }
        }
        self.progressQuestionAndUpdateView()
    }
    

}

