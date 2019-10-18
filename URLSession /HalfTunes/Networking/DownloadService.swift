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


protocol DownloadServiceDelegate {
  func downloadService(_ service: DownloadService,
                       didBeginDownload track: Track)
  
  func downloadService(_ service: DownloadService,
                       didDownloading track: Track,
                       downloadedSize: Int64,
                       totalSize: Int64)
  
  func downloadService(_ service: DownloadService,
                       didFinishDownload track: Track,
                       toLocation url: URL)
  
}



//
// MARK: - Download Service
//

/// Downloads song snippets, and stores in local file.
/// Allows cancel, pause, resume download.
class DownloadService: NSObject {
  //
  // MARK: - Variables And Properties
  //
  // TODO 4
  var delegate: DownloadServiceDelegate? = nil
  var downloadActivityDictionary: [URL:DownloadActivity] = [:]
  
  /// SearchViewController creates downloadsSession
  lazy var downloadsSession: URLSession! = URLSession(configuration: .default,
                                                delegate: self,
                                                delegateQueue: nil)
  
  //
  // MARK: - Internal Methods
  //
  // TODO 9
  func cancelDownload(_ track: Track) {
    guard let downloadActivity = self.downloadActivityDictionary[track.previewURL] else {
      return
    }
    
    downloadActivity.task?.cancel()
    self.downloadActivityDictionary.removeValue(forKey: track.previewURL)
  }
  
  // TODO 10
  func pauseDownload(_ track: Track) {
    guard let downloadActivity = self.downloadActivityDictionary[track.previewURL], downloadActivity.downloading == true else {
      return
    }
    
    downloadActivity.task?.cancel(byProducingResumeData: { (resumeDate) in
      downloadActivity.resumeData = resumeDate
    })
    downloadActivity.downloading = false
  }
  
  // TODO 11
  func resumeDownload(_ track: Track) {
    var resumeDate: Data? = nil
    var currentDownloadActivity: DownloadActivity? = nil
    
    if let downloadActivity = self.downloadActivityDictionary[track.previewURL], let data = downloadActivity.resumeData {

      resumeDate = data
      currentDownloadActivity = downloadActivity
    }
    
    let resumeTask = resumeDate != nil ? self.downloadsSession.downloadTask(withResumeData: resumeDate!) : self.downloadsSession.downloadTask(with: track.previewURL)
    let resumeDownloadActivity = currentDownloadActivity ??  DownloadActivity(track: track, task: resumeTask)
    resumeDownloadActivity.task = resumeTask
    resumeDownloadActivity.downloading = true
    resumeTask.resume()
    self.downloadActivityDictionary[track.previewURL] = resumeDownloadActivity
    
    if resumeDate == nil {
      self.delegate?.downloadService(self, didBeginDownload: track)
    }
  }
  
  // TODO 8
  func startDownload(_ track: Track) {
    if let currentActivity = self.downloadActivityDictionary[track.previewURL] {
      if let task = currentActivity.task, task.state == .running, currentActivity.downloading {
        return
      }
      self.downloadActivityDictionary.removeValue(forKey: track.previewURL)
    }
    
    let downloadTask = self.downloadsSession.downloadTask(with: track.previewURL)
    let downloadActivity = DownloadActivity(track: track, task: downloadTask)
    self.downloadActivityDictionary[track.previewURL] = downloadActivity
    downloadActivity.downloading = true
    downloadTask.resume()
    self.delegate?.downloadService(self, didBeginDownload: track)
  }
  
}


extension DownloadService: URLSessionDownloadDelegate {
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    var track: Track? = nil
    self.downloadActivityDictionary.forEach { (pair) in
      if let task = pair.value.task, task == downloadTask {
        track = pair.value.track
      }
    }
    if let _ = track {
      self.delegate?.downloadService(self, didFinishDownload: track!, toLocation: location)
      track!.downloaded = true
      self.downloadActivityDictionary.removeValue(forKey: track!.previewURL)
    }
  }
  
  func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    var downloadActivity: DownloadActivity? = nil
    self.downloadActivityDictionary.forEach { (pair) in
      if pair.value.task == downloadTask {
        downloadActivity = pair.value
      }
    }
    
    guard let _ = downloadActivity else {
      return
    }
    
    downloadActivity!.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    self.delegate?.downloadService(self, didDownloading: downloadActivity!.track!, downloadedSize: totalBytesWritten, totalSize: totalBytesExpectedToWrite)
  }
}
