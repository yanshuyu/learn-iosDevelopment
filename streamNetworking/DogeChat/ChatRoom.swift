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

import Foundation

protocol ChatRoomDelegate: class {
  func chatRoom(_ aChatRoom: ChatRoom, revice message: Message)
  func chatRoom(_ aChatRoom: ChatRoom, revice error: Error)
}

class ChatRoom: NSObject {
  private var readStream: InputStream!
  private var writeStream: OutputStream!
  private let maxReadLength = 4096
  private var userName = ""

  weak var delegate: ChatRoomDelegate?
  
  @discardableResult
  func connect(host: String, port: UInt32) -> Bool {
    var readStream: Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       host as CFString,
                                       port,
                                       &readStream,
                                       &writeStream)
    
    guard let _ = readStream, let _ = writeStream else {
      return false
    }
    
    self.readStream = readStream!.takeRetainedValue() as InputStream
    self.writeStream = writeStream!.takeRetainedValue() as OutputStream
    
    self.readStream.delegate = self
    
    self.readStream.schedule(in: .current, forMode: .common)
    self.writeStream.schedule(in: .current, forMode: .common)
    
    self.readStream.open()
    self.writeStream.open()
    
    return true
  }
  
  @discardableResult
  func joinChat(user: String) -> Bool {
    self.userName = user
    guard let data = "iam:\(user)".data(using: .utf8) as NSData? else {
      return false
    }
  
    let bytes = data.bytes.bindMemory(to: UInt8.self, capacity: data.length)
    let writeCount = self.writeStream.write(bytes, maxLength: data.length)
    
    return writeCount != -1
  }
  
  @discardableResult
  func send(message: String) -> Bool {
    guard let data = "msg:\(message)".data(using: .utf8) as NSData? else {
      return false
    }
    let bytes = data.bytes.bindMemory(to: UInt8.self, capacity: data.length)
    return self.writeStream.write(bytes, maxLength: data.length) != -1
  }
  
}

//
// MARK: - Input stream delegate
//
extension ChatRoom: StreamDelegate {
  func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
    switch eventCode {
    case .hasBytesAvailable:
      while self.readStream.hasBytesAvailable {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: self.maxReadLength)
        buffer.initialize(to: 0)
        let readedCount = self.readStream.read(buffer, maxLength: self.maxReadLength)
        if readedCount > 0 {
          if let msg = parseMessage(String(bytesNoCopy: buffer, length: readedCount, encoding: .utf8, freeWhenDone: false)) {
            self.delegate?.chatRoom(self, revice: msg)
          }
        }
        buffer.deallocate()
      }
      break
      
    case .endEncountered:
      break
      
    case .errorOccurred:
      print("processing stream error: \(aStream.streamError!.localizedDescription)")
      self.delegate?.chatRoom(self, revice: aStream.streamError!)
      break
      
    default:
      break
    }
  }
  
  private func parseMessage(_ string: String?) -> Message? {
    if let s = string {
      let comps = s.components(separatedBy: ":")
      guard let name = comps.first,
        let msg = comps.last  else {
          return nil
      }
      
      let msgSender: MessageSender = (name == self.userName) ? .ourself:.someoneElse
      return Message(message: msg, messageSender: msgSender, username: name)
    }
    
    return nil
  }
}
