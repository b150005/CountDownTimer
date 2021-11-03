//
//  DigitalPreviewLabel.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/16.
//

import Cocoa

/// デジタル時計を表示するView
@IBDesignable class DigitalPreviewLabel: NSView {
  var timer: Timer?
  let generalPreferences: GeneralPreferences = GeneralPreferences.shared
  
  var digitalTime: DigitalTime {
    get {
      return DigitalTime()
    }
    set (newDigitalTime) {
      /// `digitalTime`プロパティの参照先が更新された場合はプレビューを更新
      /// → プレビューを更新するには`digitalTime`プロパティに再セットしなければならない
      self.resetDigitalPreview(&self.timer)
    }
  }
  
  @IBInspectable var text: String? {
    didSet { setNeedsDisplay(NSRect(origin: .zero, size: frame.size)) }
  }
  var font: NSFont = .systemFont(ofSize: 100) {
    didSet { setNeedsDisplay(NSRect(origin: .zero, size: frame.size)) }
  }
  @IBInspectable var textColor: NSColor = .labelColor {
    didSet { setNeedsDisplay(NSRect(origin: .zero, size: frame.size)) }
  }
  var textAlignment: NSTextAlignment = .natural {
    didSet { setNeedsDisplay(NSRect(origin: .zero, size: frame.size)) }
  }
  @IBInspectable var backgroundColor: NSColor = .clear {
    didSet { setNeedsDisplay(NSRect(origin: .zero, size: frame.size)) }
  }
  
  // ドラッグによるウィンドウの移動を可能にする
  override var mouseDownCanMoveWindow: Bool {
    get {
      return true
    }
  }
  
  /// テキスト・テキストビュー領域の描画
  override func draw(_ dirtyRect: NSRect) {
    super.draw(dirtyRect)
    
    // ビュー領域の描画(のちにdraw()メソッドで再描画する)
    backgroundColor.setFill()
    dirtyRect.fill()
    
    let str = text ?? ""
    var fontSize = self.font.pointSize
    
    // 初期フォントサイズ(100)からViewの横幅より小さくなるまでフォントサイズを1ずつデクリメント
    while let font = NSFont(descriptor: self.font.fontDescriptor, size: fontSize),
              size(of: str, for: font).width >= frame.width {
      fontSize -= 1
    }
    
    guard let font = NSFont(descriptor: self.font.fontDescriptor, size: fontSize) else { return }
    // 段落の属性を表すオブジェクト
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = .center
    
    let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: textColor, .paragraphStyle: paragraph]
    let textSize = size(of: str, for: font)
    var textOrigin = NSPoint.zero
    
    switch textAlignment {
    case .center:
      // 中央配置
      textOrigin = NSPoint(x: (frame.width - textSize.width) / 2, y: (frame.height - textSize.height) / 2)
    case .right:
      // 右詰め(高さは中央配置)
      textOrigin = NSPoint(x: frame.width - textSize.width, y: (frame.height - textSize.height) / 2)
    default:
      // 左詰め(高さは中央配置)
      textOrigin = NSPoint(x: 0, y: (frame.height - textSize.height) / 2)
    }
    
    // テキストの開始位置とテキストビュー領域を保持するオブジェクトの生成
    let textRect = NSRect(origin: textOrigin, size: textSize)
    // 文字列の描画
    str.draw(in: textRect, withAttributes: attributes)
  }
  
  /// 描画に必要なテキスト領域のサイズを算出
  private func size(of str: String, for font: NSFont) -> NSSize {
    // フォント情報をマップとして保持するプロパティ
    let attributes: [NSAttributedString.Key: Any] = [.font: font]
    // NSLayoutManagerに描画するテキストの変化を検知するオブジェクト
    let storage = NSTextStorage(string: str, attributes: attributes)
    // テキストの表示領域を定義するオブジェクト
    let container = NSTextContainer(
      containerSize: NSSize(width: CGFloat.greatestFiniteMagnitude,
                            height: CGFloat.greatestFiniteMagnitude))
    // テキストのレイアウトを定義するオブジェクト
    let layoutManager = NSLayoutManager()
    
    /*
     TextStorage - テキストの変化を検知し、必要に応じてLayoutManagerに再描画を依頼
     ※NSAttributedStringを利用して文字操作を行うことを推奨
     ↑
     LayoutManager - テキストのレイアウトを定義
     ↑
     TextContainer - テキストの表示領域を定義
     */
    
    // LayoutManagerにTextContainerを付与
    layoutManager.addTextContainer(container)
    // TextStorageにLayoutManagerを付与
    storage.addLayoutManager(layoutManager)
    // テキスト間のパディングを0として計算
    container.lineFragmentPadding = 0
    // TextContainerのグリフ領域を返却
    // -> 意味があるかは不明
    layoutManager.glyphRange(for: container)
    
    // LayoutManagerの利用領域を返却
    return layoutManager.usedRect(for: container).size
  }
  
  /// 文字列に応じたビュー領域のサイズ変更
  func sizeToFit() {
    if let str = text {
      frame.size = self.size(of: str, for: font)
    }
    else {
      frame.size = .zero
    }
  }
  
  /// プレビューの初期化
  func initializeDigitalPreviewLabel() {
    // デジタル時計のプレビュー設定
    if let userFont = NSFont(name: self.generalPreferences.fontName, size: 100) {
      self.font = userFont
    }
    self.textColor = self.generalPreferences.baseFontColor
    self.textAlignment = .center
    
    // DigitalTimeの再計算(デジタル時計プレビューの更新)
    self.digitalTime = DigitalTime()
  }
  
  /// デジタル時計プレビューの再描画(Timerの発火)
  /// → `digitalTime`プロパティの値変更時に呼び出される
  fileprivate func resetDigitalPreview(_ timer: inout Timer?) {
    // timerプロパティがnilでない場合はTimerを無効化
    if let timer = timer {
      // Timerの無効化
      timer.invalidate()
    }
    
    // Timerオブジェクトの発火
    timerFiring(&timer)
  }
  
  /// 1秒ごとに指定した処理を実行
  // MARK: - 定期的に実行する処理はTimerを利用、実行するメソッドは@objcアノテーションを付加
  private func timerFiring(_ timer: inout Timer?) {
    // Timerオブジェクトの定義
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setText), userInfo: nil, repeats: true)
    RunLoop.main.add(timer!, forMode: .common)
  }
  
  /// 1秒ごとに実行する処理
  @objc private func setText() {
    // [期限超過の場合は現在時刻を表示する設定 かつ 期限超過] または [デジタル時計モード] である場合
    // → デジタル時計として機能させる
    if (DigitalTime.temporaryClockMode || generalPreferences.isTimer == false) {
      // hour, minute, secondの定義
      self.digitalTime.setAsClock()
      
      // フォントカラーを基本に戻す
      self.textColor = generalPreferences.baseFontColor.withAlphaComponent(generalPreferences.opacity)
      
      // テキストに反映
      self.text = "\(String(format: "%02d", DigitalTime.hour)):\(String(format: "%02d", DigitalTime.minute)):\(String(format: "%02d", DigitalTime.second))"
    }
    // それ以外の場合はタイマーとして機能させる
    else {
      // hour, minute, secondの定義
      self.digitalTime.decrementTimer()
      // 残り時間に応じた色の判別
      let remainsSec = self.digitalTime.getRemainsSec()
      
      // [期限超過の場合は現在時刻を表示する設定 かつ 期限に到達した] 場合は一時的にデジタル時計として機能させるモードに変更
      if (generalPreferences.isSwitchingCurrentTime && self.digitalTime.getRemainsSec() == 0) {
        DigitalTime.temporaryClockMode = true
      }
      
      switch remainsSec {
      case 0...generalPreferences.beforeSec:
        // フォントカラーの変更
        self.textColor = generalPreferences.beforeFontColor.withAlphaComponent(generalPreferences.opacity)
      case (generalPreferences.afterSec * -1)..<0:
        // フォントカラーの変更
        self.textColor = generalPreferences.afterFontColor.withAlphaComponent(generalPreferences.opacity)
      default:
        // フォントカラーを基本に戻す
        self.textColor = generalPreferences.baseFontColor.withAlphaComponent(generalPreferences.opacity)
      }
      
      // テキストに反映
      self.text = "\(DigitalTime.isMinus ? "-" : "")\(String(format: "%02d", DigitalTime.hour)):\(String(format: "%02d", DigitalTime.minute)):\(String(format: "%02d", DigitalTime.second))"
    }
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
