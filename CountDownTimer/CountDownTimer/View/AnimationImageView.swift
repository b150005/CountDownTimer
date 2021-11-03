//
//  AnimationImageView.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/26.
//

import Cocoa

/// アニメーションを表示するドラッグによるウィンドウ移動が可能なNSImageViewクラス
/// → GIFアニメーションは基本的にループ回数を"1"に設定しておく
/// ※ 必要に応じてユーザには`[ezgif.com](https://ezgif.com/loop-count)`を利用してもらう
@IBDesignable class AnimationImageView: DraggableImageView {
  var timer: Timer?
  private let generalPreferences: GeneralPreferences = GeneralPreferences.shared
  
  // アニメーションGIFファイルが存在するかどうかを識別するフラグ
  private var isExistAnimation1: Bool = false
  private var isExistAnimation2: Bool = false
  
  /// プレビュー用に利用するプロパティ
  /// → アニメーションが2つとも設定されている場合に、プレビューで交互に表示させるために利用
  private var prevSwitch: Bool = true
  
  // 表示するNSImage
  @IBInspectable override var image: NSImage? {
    get {
      return super.image
    }
    set (newImage) {
      super.image = newImage
    }
  }
  
  override var canDrawConcurrently: Bool {
    get {
      return true
    }
    set { }
  }
  
  override var imageScaling: NSImageScaling {
    get {
      return .scaleProportionallyDown
    }
    set { }
  }
  
  override var animates: Bool {
    get {
      return true
    }
    set { }
  }
  
  var gifFileName1: String = ""
  var gifFileName2: String = ""
  
  /// 指定したGIFファイルを1時間間隔で交互に再生(本番用)
  /// → 現状は`デスクトップ/CountDown/`直下に配置する必要がある
  func startAnimation() {
    // timerプロパティがnilでない場合はTimerを無効化
    if let timer = self.timer {
      // Timerの無効化
      timer.invalidate()
    }
    
    // GIFファイルの存在チェック
    checkFileExistence()
    
    // Timerオブジェクトの発火
    timerFiring()
  }
  
  /// 指定時間ごとに処理を実行(本番用)
  /// → 現状は1時間ごと(`60 * 60`の部分を変更することで指定時間の変更が可能)
  // MARK: - 定期的に実行する処理はTimerを利用、実行するメソッドは@objcアノテーションを付加
  private func timerFiring() {
    // Timerオブジェクトの定義
    self.timer = Timer.scheduledTimer(timeInterval: 60 * 60, target: self, selector: #selector(self.setImage), userInfo: nil, repeats: true)
    RunLoop.main.add(timer!, forMode: .common)
  }
  
  /// 指定したGIFファイルを5秒間隔で交互に再生(プレビュー用)
  /// → 現状は`デスクトップ/CountDown/`直下に配置する必要がある
  func startAnimationForPreview() {
    // timerプロパティがnilでない場合はTimerを無効化
    if let timer = self.timer {
      // Timerの無効化
      timer.invalidate()
    }
    
    // GIFファイルの存在チェック
    checkFileExistence()
    
    // Timerオブジェクトの発火
    timerFiringForPreview()
  }
  
  /// 5秒ごとに指定した処理を実行(プレビュー用)
  // MARK: - 定期的に実行する処理はTimerを利用、実行するメソッドは@objcアノテーションを付加
  private func timerFiringForPreview() {
    // Timerオブジェクトの定義
    self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.setImage), userInfo: nil, repeats: true)
    RunLoop.main.add(timer!, forMode: .common)
  }
  
  /// 指定時間ごとに実行する処理
  @objc private func setImage() {
    // どちらも存在しない場合は処理を抜ける
    if (!self.isExistAnimation1 && !self.isExistAnimation2) {
      print("Neither exists.")
      return
    }
    
    // 少なくともどちらかのGIFファイルが存在する場合
    if let desktopDirString = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first {
      let countDownDirString: String = desktopDirString + "/CountDown/"
      
      // どちらも存在する場合は交互に表示する
      if (self.isExistAnimation1 && self.isExistAnimation2) {
        let animation1PathString: String = countDownDirString + self.gifFileName1
        let animation2PathString: String = countDownDirString + self.gifFileName2
        
        if let image1 = NSImage(contentsOfFile: animation1PathString), let image2 = NSImage(contentsOfFile: animation2PathString) {
          if (prevSwitch) {
            self.image = image1
            prevSwitch.toggle()
          }
          else {
            self.image = image2
            prevSwitch.toggle()
          }
        }
        // 処理を抜ける
        return
      }
      
      // どちらかしか存在しない場合はどちらかしか表示しない
      if (self.isExistAnimation1) {
        let animation1PathString: String = countDownDirString + self.gifFileName1
        
        if let image1 = NSImage(contentsOfFile: animation1PathString) {
          self.image = image1
        }
      }
      else if (self.isExistAnimation2) {
        let animation2PathString: String = countDownDirString + self.gifFileName2
        
        if let image2 = NSImage(contentsOfFile: animation2PathString) {
          self.image = image2
        }
      }
    }
  }
  
  /// 指定したGIFファイルが存在するかチェック
  private func checkFileExistence() {
    let fileManager = FileManager.default
    if let desktopDirString: String = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first {
      let countDownDirString: String = desktopDirString + "/CountDown/"
      
      self.isExistAnimation1 = fileManager.fileExists(atPath: countDownDirString + self.gifFileName1) ? true : false
      self.isExistAnimation2 = fileManager.fileExists(atPath: countDownDirString + self.gifFileName2) ? true : false
    }
  }
  
  // ドラッグによるウィンドウの移動を可能にする
  override var mouseDownCanMoveWindow: Bool {
    get {
      return true
    }
  }
  
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    // Drawing code here.
  }
  
  /// Timerオブジェクトの無効化・解放処理
  func clearTimer() {
    // digitalPreviewLabel.timerがnilでない場合はTimerを無効化
    if let timer = self.timer {
      // Timerの無効化
      timer.invalidate()
      // timerプロパティの解放
      self.timer = nil
    }
  }
}
