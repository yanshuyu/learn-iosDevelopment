
/// Copyright (c) 2019 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit

class ChatRoomViewController: UIViewController {
  let tableView = UITableView()
  let messageInputBar = MessageInputView()
  
  var messages: [Message] = []
  
  var username = ""
  
  var chatRoom: ChatRoom!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.chatRoom = ChatRoom()
    self.chatRoom.delegate = self
    
    if !self.chatRoom.connect(host: "localhost", port: 80) {
      print("Failed to connect to chat room....")
    } else {
      print("Success to connet to chat room.")
      
      if !self.chatRoom.joinChat(user: self.username) {
        print("Failed to join in chat...")
      } else {
        print("Success to join in chat.")
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

  }
}

//MARK - Message Input Bar
extension ChatRoomViewController: MessageInputDelegate {
  func sendWasTapped(message: String) {
    if !self.chatRoom.send(message: message) {
      print("failed to send message: \(message)")
    }
  }
}

//MARK: - ChatRoom delegate
extension ChatRoomViewController: ChatRoomDelegate {
  func chatRoom(_ aChatRoom: ChatRoom, revice message: Message) {
    print("got msg: \(message)")
    insertNewMessageCell(message)
  }
  
  func chatRoom(_ aChatRoom: ChatRoom, revice error: Error) {
    print("got error: \(error.localizedDescription)")
  }
}
