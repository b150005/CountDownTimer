//
//  ViewController.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/03.
//

import Cocoa
import KeyboardShortcuts

/// アプリケーションウィンドウのコンテンツを管理するクラス
class ViewController: NSViewController {
  // アニメーションを表示するNSImageView
  @IBOutlet weak var animationImageView: AnimationImageView!
  
  // アナログ時計を表示するNSImageView
  @IBOutlet weak var faceImageView: DraggableImageView!
  @IBOutlet weak var hourHandImageView: HandImageView!
  @IBOutlet weak var minuteHandImageView: HandImageView!
  @IBOutlet weak var secondHandImageView: HandImageView!
  
  // デジタル時計(またはタイマー)を表示するDigitalPreviewLabel
  @IBOutlet weak var digitalPreviewLabel: DigitalPreviewLabel!
  
  let generalPreferences: GeneralPreferences = GeneralPreferences.shared
  var timer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // NSFontPanelオブジェクトが存在する場合はウィンドウを閉じる
    guard let fontPanel = NSFontManager.shared.fontPanel(true) else {
      return
    }
    fontPanel.close()
    
    // NSColorPanelオブジェクトが存在する場合はウィンドウを閉じる
    if (NSColorPanel.sharedColorPanelExists) {
      NSColorPanel.shared.close()
    }
    
    // ショートカットキーの押下によって呼び出される処理
    KeyboardShortcuts.onKeyDown(for: .toggleUnicornMode) { [self] in
      self.initializeEachView()
      
      // 表示するViewの切り替え
      self.setViewContent()
    }
  }
  
  override var representedObject: Any? {
    didSet {
      // Update the view, if already loaded.
    }
  }
  
  
  override func viewWillDisappear() {
    super.viewWillDisappear()
    // NSFontPanelオブジェクトが存在する場合はウィンドウを閉じる
    guard let fontPanel = NSFontManager.shared.fontPanel(true) else {
      return
    }
    fontPanel.close()
    
    // NSColorPanelオブジェクトが存在する場合はウィンドウを閉じる
    if (NSColorPanel.sharedColorPanelExists) {
      NSColorPanel.shared.close()
    }
  }
  
  /// 各Viewの初期化処理
  private func initializeEachView() {
    if (generalPreferences.isAnalog == true) {
      // アナログ時計のNSImageViewの設定
      hourHandImageView.section = TimeSection.hour
      minuteHandImageView.section = TimeSection.minute
      secondHandImageView.section = TimeSection.second
      
      // アナログ時計のアニメーションのセット
      if let desktopDirString = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first {
        if let image = NSImage(contentsOfFile: desktopDirString + "/CountDown/" + generalPreferences.faceFileName) {
          self.faceImageView.image = image
        }
      }
      self.hourHandImageView.fileName = generalPreferences.hourHandFileName
      self.minuteHandImageView.fileName = generalPreferences.minuteHandFileName
      self.secondHandImageView.fileName = generalPreferences.secondHandFileName
      
      // アナログ時計の描画
      self.hourHandImageView.isFirstDraw = true
      self.minuteHandImageView.isFirstDraw = true
      self.secondHandImageView.isFirstDraw = true
      self.hourHandImageView.setAnalogClock()
      self.minuteHandImageView.setAnalogClock()
      self.secondHandImageView.setAnalogClock()
    }
    else {
      // デジタル時計プレビューの初期化
      self.digitalPreviewLabel.initializeDigitalPreviewLabel()
    }
  }
  
  /// モードに応じた表示Viewの切り替え
  private func setViewContent() {
    if (generalPreferences.isAnalog) {
      // アナログ時計のアニメーションのセット
      self.animationImageView.gifFileName1 = generalPreferences.animation1FileName
      self.animationImageView.gifFileName2 = generalPreferences.animation2FileName
      
      self.digitalPreviewLabel.isHidden = true
      self.faceImageView.isHidden = false
      self.hourHandImageView.isHidden = false
      self.minuteHandImageView.isHidden = false
      self.secondHandImageView.isHidden = false
    }
    else {
      // デジタル時計のアニメーションのセット
      self.animationImageView.gifFileName1 = generalPreferences.animation3FileName
      self.animationImageView.gifFileName2 = generalPreferences.animation4FileName
      
      self.digitalPreviewLabel.isHidden = false
      self.faceImageView.isHidden = true
      self.hourHandImageView.isHidden = true
      self.minuteHandImageView.isHidden = true
      self.secondHandImageView.isHidden = true
    }
    
    // 設定したアニメーションの開始
    self.animationImageView.startAnimation()
  }
}
