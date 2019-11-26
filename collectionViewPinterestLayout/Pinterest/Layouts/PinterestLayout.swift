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

protocol PinterestLayoutDelegate: AnyObject {
   func pinterestLayout(layout: PinterestLayout, itemHeightAt indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {
  private var callOrderFlag: Int = 0
  private var callOrder: Int {
    callOrderFlag += 1
    return callOrderFlag
  }
  
  weak var delegate: PinterestLayoutDelegate?
  
  var numberOfColumn: Int = 2 {
    didSet {
      self.collectionView?.setNeedsLayout()
    }
  }
  var itemPadding: CGFloat = 10 {
    didSet {
      self.collectionView?.setNeedsLayout()
    }
  }
  
  private var contentWidth: CGFloat {
    guard let cv = self.collectionView else {
      return 0
    }
    return cv.bounds.width - (cv.contentInset.left + cv.contentInset.right)
  }
  private var contentHeight: CGFloat = 0
  
  private var cacheLayoutAttributes = [UICollectionViewLayoutAttributes]()
  
  override func prepare() {
    print("func: \(#function), line: \(#line), call order: \(self.callOrder)")
    
    guard let cv = self.collectionView else {
      return
    }
    self.cacheLayoutAttributes.removeAll(keepingCapacity: true)
    
    let itemsCount = cv.numberOfItems(inSection: 0)
    let columnWidth = self.contentWidth / CGFloat(self.numberOfColumn)
    var xOffset = Array<CGFloat>(repeating: 0, count: self.numberOfColumn)
    var yOffset = Array<CGFloat>(repeating: 0, count: self.numberOfColumn)
    
    for i in 0..<self.numberOfColumn {
      xOffset[i] = CGFloat(i) * columnWidth
    }
  
    var column = 0
    for idx in 0..<itemsCount {
      let indexPath = IndexPath(item: idx, section: 0)
      let itemHeight = self.delegate?.pinterestLayout(layout: self, itemHeightAt: indexPath) ?? 180
      let itemFrame = CGRect(x: xOffset[column],
                             y: yOffset[column],
                             width: columnWidth,
                             height: itemHeight)
      let itemLayoutAttribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
      itemLayoutAttribute.frame = itemFrame.inset(by: UIEdgeInsets(top: self.itemPadding,
                                                                   left: self.itemPadding,
                                                                   bottom: self.itemPadding,
                                                                   right: self.itemPadding))
      self.cacheLayoutAttributes.append(itemLayoutAttribute)
      
      contentHeight = max(contentHeight, itemFrame.maxY)
      yOffset[column] = yOffset[column] + itemHeight
      
      let isLastColumn = column == self.numberOfColumn-1
      column = isLastColumn ? 0 : column + 1
    }
    
  }

  override var collectionViewContentSize: CGSize {
    let sz = CGSize(width: self.contentWidth, height: self.contentHeight)
    print("func: \(#function), line: \(#line), call order: \(self.callOrder), value: \(sz)")
    return sz
  }
  
  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    print("func: \(#function), line: \(#line), call order: \(self.callOrder), param: \(rect)")
    var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
    self.cacheLayoutAttributes.forEach { (layoutAttribute) in
      if layoutAttribute.frame.intersects(rect) {
        visibleLayoutAttributes.append(layoutAttribute)
      }
    }
    return visibleLayoutAttributes
  }
  
  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    print("func: \(#function), line: \(#line), call order: \(self.callOrder)")
    return self.cacheLayoutAttributes[indexPath.item]
  }
  
}

