//
//  HandImageView.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/27.
//

import Cocoa
import Foundation

/// アナログ時計の針を表現するNSImageViewクラス
@IBDesignable class HandImageView: DraggableImageView {
  var timer: Timer?
  var section = TimeSection.hour
  
  var fileName: String = "" {
    didSet (oldFileName) {
      if let desktopDirString = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first {
        let countDownDirString: String = desktopDirString + "/CountDown/"
        
        if let image = NSImage(contentsOfFile: countDownDirString + fileName) {
          super.image = image
          if (oldFileName != fileName) {
            self.defaultImage = image
          }
        }
      }
    }
  }
  
  var defaultImage: NSImage?
  var isFirstDraw: Bool = true
  
  @IBInspectable override var image: NSImage? {
    get { return super.image }
    set { }
  }
  
  override var wantsLayer: Bool {
    get {
      return true
    }
    set { }
  }
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
  }
  
  // アナログ時計のアニメーション幅開始
  func setAnalogClock() {
    // アナログ時計の初期角度のセット
    self.setInitializePosition()
    
    // アニメーションの開始
    self.startRotate()
  }
  
  /// 現在時刻に基づく初期回転角度の取得
  private func setInitializePosition() {
    let time: AnalogTime = AnalogTime()
    // 初期角度の指定
    if let defImage = self.defaultImage {
      // 現在時刻を0:00:00からの経過時間[秒]で取得
      var elapsedSecond: Float = Float(time.getElapsedSec())
      var degree: Float = 360.0
      
      switch (self.section) {
      case TimeSection.hour:
        degree -= (elapsedSecond / (12 * 60 * 60)) * 360
      case TimeSection.minute:
        // 時は考慮しなくてよいので除外
        elapsedSecond -= Float(time.hour * 60 * 60)
        degree -= (elapsedSecond / (60 * 60)) * 360
      case TimeSection.second:
        // 時・分は考慮しなくてよいので除外
        elapsedSecond -= Float(time.hour * 60 * 60 + time.minute * 60)
        degree -= (elapsedSecond / 60) * 360
      }
      
      // NSImageの回転は初回の描画時に限定
      // → Main.storyboardから呼び出すときは`HandImageView#isFirstDraw = true`を実行してから呼び出す
      if (self.isFirstDraw == true) {
        super.image = defImage.rotated(by: CGFloat(degree))
        self.isFirstDraw = false
      }
    }
  }
  
  // MARK: - CoreAnimationの使い方
  /// 回転アニメーションの開始
  func startRotate() {
    // アンカーポイントをImageViewの中心に設定
    self.setAnchorPoint(anchorPoint: CGPoint(x: 0.5, y: 0.5))
    
    // アニメーションの開始(初回しか実行されない)
    //    if self.layer?.animationKeys()?.count == 0 || self.layer?.animationKeys() == nil {
    let rotate = CABasicAnimation(keyPath: "transform.rotation")
    rotate.fromValue = 0
    rotate.toValue = CGFloat(Double.pi / 180) * -360
    // 1回転にかかる時間[秒]の指定
    switch (self.section) {
    case TimeSection.hour:
      rotate.duration = 1.0 * 12 * 60 * 60
    case TimeSection.minute:
      rotate.duration = 1.0 * 60 * 60
    case TimeSection.second:
      rotate.duration = 1.0 * 60
    }
    
    rotate.repeatCount = Float.infinity
    
    self.layer?.add(rotate, forKey: "rotation")
    //  }
  }
}

/// 各`HandImageView`が指す針を特定するためのキー
enum TimeSection {
  case hour
  case minute
  case second
}

// MARK: - 時間があるときに解析(https://stackoverflow.com/questions/31699235/rotate-nsimage-in-swift-cocoa-mac-osx)
extension NSImage {
  /// Rotates the image by the specified degrees around the center.
  /// Note that if the angle is not a multiple of 90°, parts of the rotated image may be drawn outside the image bounds.
  // MARK: - This is nice but only works for square images. Rectangular ones get cropped.
  public func rotated(by angle: CGFloat) -> NSImage {
    let img = NSImage(size: self.size, flipped: false, drawingHandler: { (rect) -> Bool in
      let (width, height) = (rect.size.width, rect.size.height)
      let transform = NSAffineTransform()
      transform.translateX(by: width / 2, yBy: height / 2)
      transform.rotate(byDegrees: angle)
      transform.translateX(by: -width / 2, yBy: -height / 2)
      transform.concat()
      self.draw(in: rect)
      return true
    })
    img.isTemplate = self.isTemplate // preserve the underlying image's template setting
    return img
  }
}

// MARK: - 時間があるときに解析(https://stackoverflow.com/questions/1968017/changing-my-calayers-anchorpoint-moves-the-view)
extension NSView {
  func setAnchorPoint(anchorPoint:CGPoint) {
    if let layer = self.layer {
      var newPoint = NSPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
      var oldPoint = NSPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)
      
      newPoint = newPoint.applying(layer.affineTransform())
      oldPoint = oldPoint.applying(layer.affineTransform())
      
      var position = layer.position
      
      position.x -= oldPoint.x
      position.x += newPoint.x
      
      position.y -= oldPoint.y
      position.y += newPoint.y
      
      layer.anchorPoint = anchorPoint
      layer.position = position
    }
  }
}
