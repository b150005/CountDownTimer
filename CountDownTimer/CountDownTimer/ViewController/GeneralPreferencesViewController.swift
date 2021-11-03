//
//  GeneralPreferencesViewController.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/03.
//

import Cocoa
import AppKit

class GeneralPreferencesViewController: NSViewController, NSDatePickerCellDelegate {
  
  /// アナログ or デジタルを決定するボタン
  /// ```
  /// ON: NSButton#state = NSControlStateValue(rawValue: 1)
  /// OFF: NSButton#state = NSControlStateValue(rawValue: 0)
  /// ```
  @IBOutlet weak var analogRadioButton: NSButton!
  @IBOutlet weak var digitalRadioButton: NSButton!
  
  @IBOutlet weak var faceURLTextField: NSTextField!
  @IBOutlet weak var hourURLTextField: NSTextField!
  @IBOutlet weak var minuteURLTextField: NSTextField!
  @IBOutlet weak var secondURLTextField: NSTextField!
  
  @IBOutlet weak var animation1URLTextField: NSTextField!
  @IBOutlet weak var animation2URLTextField: NSTextField!
  
  @IBOutlet weak var faceImageView: NSImageView!
  @IBOutlet weak var hourHandImageView: HandImageView!
  @IBOutlet weak var minuteHandImageView: HandImageView!
  @IBOutlet weak var secondHandImageView: HandImageView!
  
  @IBOutlet weak var analogAnimationImageView: AnimationImageView!
  
  /// タイマー or 時計を決定するボタン
  /// ```
  /// ON: NSButton#state = NSControlStateValue(rawValue: 1)
  /// OFF: NSButton#state = NSControlStateValue(rawValue: 0)
  /// ```
  @IBOutlet weak var timerRadioButton: NSButton!
  @IBOutlet weak var clockRadioButton: NSButton!
  
  @IBOutlet weak var dueDate1DatePicker: NSDatePicker!
  @IBOutlet weak var dueDate2DatePicker: NSDatePicker!
  
  @IBOutlet weak var switchCurrentTimeButton: NSButton!
  
  @IBOutlet weak var animation3URLTextField: NSTextField!
  @IBOutlet weak var animation4URLTextField: NSTextField!
  
  @IBOutlet weak var fontTextField: NSTextField!
  
  @IBOutlet weak var selectFontButton: NSButton!
  
  @IBOutlet weak var baseFontColorWell: NSColorWell!
  @IBOutlet weak var beforeFontColorWell: NSColorWell!
  @IBOutlet weak var afterFontColorWell: NSColorWell!
  
  @IBOutlet weak var beforeDatePicker: NSDatePicker!
  @IBOutlet weak var afterDatePicker: NSDatePicker!
  
  @IBOutlet weak var opacitySlider: NSSlider!
  @IBOutlet weak var opacityTextField: NSTextField!
  
  @IBOutlet weak var digitalPreviewLabel: DigitalPreviewLabel!
  @IBOutlet weak var digitalAnimationImageView: AnimationImageView!
  
  let generalPreferences: GeneralPreferences = GeneralPreferences.shared
  var isFirst: Bool = true
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // 設定の初期化
    initializePreferences()
    
    // デジタル時計プレビューの初期化
    digitalPreviewLabel.initializeDigitalPreviewLabel()
    
    // アナログ時計アニメーションの描画
    analogAnimationImageView.startAnimationForPreview()
    
    // デジタル時計アニメーションの描画
    digitalAnimationImageView.startAnimationForPreview()
  }
  
  override func viewDidLayout() {
    // アナログ時計の描画
    self.hourHandImageView.setAnalogClock()
    self.minuteHandImageView.setAnalogClock()
    self.secondHandImageView.setAnalogClock()
  }
  
  override func viewDidDisappear() {
    // Timerオブジェクトの解放
    analogAnimationImageView.clearTimer()
    digitalPreviewLabel.clearTimer()
    digitalAnimationImageView.clearTimer()
    
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
  
  /// GeneralPreferenceの初期化処理
  private func initializePreferences() {
    /*
     UIの初期設定
     */
    // 全体のモード
    if (generalPreferences.isAnalog) {
      analogRadioButton.state = NSControl.StateValue.on
      digitalRadioButton.state = NSControl.StateValue.off
    }
    else {
      analogRadioButton.state = NSControl.StateValue.off
      digitalRadioButton.state = NSControl.StateValue.on
    }
    
    // アナログ時計で利用するGIFファイル名
    faceURLTextField.stringValue = generalPreferences.faceFileName
    hourURLTextField.stringValue = generalPreferences.hourHandFileName
    minuteURLTextField.stringValue = generalPreferences.minuteHandFileName
    secondURLTextField.stringValue = generalPreferences.secondHandFileName
    animation1URLTextField.stringValue = generalPreferences.animation1FileName
    animation2URLTextField.stringValue = generalPreferences.animation2FileName
    
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
    self.analogAnimationImageView.gifFileName1 = generalPreferences.animation1FileName
    self.analogAnimationImageView.gifFileName2 = generalPreferences.animation2FileName
    
    // デジタル時計のモード
    if (generalPreferences.isTimer) {
      timerRadioButton.state = NSControl.StateValue.on
      clockRadioButton.state = NSControl.StateValue.off
    }
    else {
      timerRadioButton.state = NSControl.StateValue.off
      clockRadioButton.state = NSControl.StateValue.on
    }
    
    // 期限超過時の挙動モード
    if (generalPreferences.isSwitchingCurrentTime) {
      switchCurrentTimeButton.state = NSControl.StateValue.on
    }
    else {
      switchCurrentTimeButton.state = NSControl.StateValue.off
    }
    
    // デジタル時計で利用するGIFファイル名
    animation3URLTextField.stringValue = generalPreferences.animation3FileName
    animation4URLTextField.stringValue = generalPreferences.animation4FileName
    
    // フォント名
    fontTextField.stringValue = generalPreferences.fontName
    
    // フォントカラー
    baseFontColorWell.color = generalPreferences.baseFontColor
    beforeFontColorWell.color = generalPreferences.beforeFontColor
    afterFontColorWell.color = generalPreferences.afterFontColor
    
    // 期限
    let now = Date()
    let calendar = Calendar.current
    
    let year = calendar.component(.year, from: now)
    let month = calendar.component(.month, from: now)
    let day = calendar.component(.day, from: now)
    
    let beforeHour = generalPreferences.beforeSec / 3600
    let beforeMinute = (generalPreferences.beforeSec - beforeHour * 3600) / 60
    let beforeSecond = generalPreferences.beforeSec - beforeHour * 3600 - beforeMinute * 60
    let beforeDate = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: beforeHour, minute: beforeMinute, second: beforeSecond))!
    
    let afterHour = generalPreferences.afterSec / 3600
    let afterMinute = (generalPreferences.afterSec - afterHour * 3600) / 60
    let afterSecond = generalPreferences.afterSec - afterHour * 3600 - afterMinute * 60
    let afterDate = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: afterHour, minute: afterMinute, second: afterSecond))!
    
    dueDate1DatePicker.dateValue = calendar.date(byAdding: .hour, value: +1, to: now)!
    dueDate2DatePicker.dateValue = calendar.date(byAdding: .hour, value: +2, to: now)!
    
    // デジタル時計のフォント色変更期間
    beforeDatePicker.dateValue = beforeDate
    afterDatePicker.dateValue = afterDate
    
    // 透明度
    opacitySlider.doubleValue = generalPreferences.opacity
    opacityTextField.doubleValue = generalPreferences.opacity
    
    // デジタル時計のアニメーションのセット
    self.digitalAnimationImageView.gifFileName1 = generalPreferences.animation3FileName
    self.digitalAnimationImageView.gifFileName2 = generalPreferences.animation4FileName
  }
  
  /// アナログ or デジタルのモード選択時に実行される処理
  @IBAction func setIsAnalog(_ sender: Any) {
    // アナログが選択された場合
    if (analogRadioButton.state.rawValue == 1) {
      generalPreferences.isAnalog = true
    }
    // デジタルが選択された場合
    else if (digitalRadioButton.state.rawValue == 1) {
      generalPreferences.isAnalog = false
      
      // DigitalTimeの再計算(デジタル時計プレビューの更新)
      digitalPreviewLabel.digitalTime = DigitalTime()
    }
  }
  
  // MARK: - アナログ時計
  
  /// 選択ボタン押下時の処理
  @IBAction func selectGIF(_ sender: NSButton) {
    let openPanel: NSOpenPanel = NSOpenPanel()
    // 1ファイルのみ選択可能にする(フォルダの選択は不可)
    openPanel.canChooseFiles = true
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = false
    
    // MARK: - 最終的にデスクトップに限定しない処理に変更
    // デスクトップ上にファイル格納用のフォルダを生成
    let fileManager = FileManager.default
    if let desktopDirString = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first {
      if let desktopURL = URL(string: desktopDirString) {
        let gifDirectoryURL = desktopURL.appendingPathComponent("CountDown", isDirectory: true)
        
        // デスクトップに「CountDown」フォルダが存在しない場合は生成
        if !fileManager.fileExists(atPath: gifDirectoryURL.path) {
          do {
            try fileManager.createDirectory(atPath: gifDirectoryURL.path, withIntermediateDirectories: true, attributes: nil)
          }
          catch {
            print(error.localizedDescription)
          }
        }
        // 初期位置を作成したフォルダパスにする
        openPanel.directoryURL = gifDirectoryURL
      }
    }
    
    // gifファイルのみ選択可能にする
    openPanel.allowedFileTypes = ["gif"]
    openPanel.begin(completionHandler: { (res) -> Void in
      // ファイル選択ダイアログのレスポンスコードに応じた分岐処理
      switch res {
      case NSApplication.ModalResponse.OK:
        guard let filePathURL = openPanel.url else {
          return
        }
        let filePath: String = filePathURL.absoluteString
        // 押下されたボタンのタグに応じた分岐処理
        // -> UserDefaults・各TextFieldの値を変更
        let fileName: String = String(filePath.split(separator: "/").last!)
        switch sender.tag {
          /*
           1: 盤面GIF
           2: 短針GIF
           3: 長針GIF
           4: 秒針GIF
           5: アニメーションGIF①
           6: アニメーションGIF②
           7: アニメーションGIF③
           8: アニメーションGIF④
           */
        case 1:
          self.generalPreferences.faceFileName = fileName
          self.faceURLTextField.stringValue = filePath
          
          if let desktopDirString = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first {
            if let image = NSImage(contentsOfFile: desktopDirString + "/CountDown/" + fileName) {
              self.faceImageView.image = image
            }
          }
        case 2:
          self.generalPreferences.hourHandFileName = fileName
          self.hourURLTextField.stringValue = filePath
          self.hourHandImageView.fileName = fileName
          // アナログ時計のアニメーションの開始
          self.hourHandImageView.setAnalogClock()
        case 3:
          self.generalPreferences.minuteHandFileName = fileName
          self.minuteURLTextField.stringValue = filePath
          self.minuteHandImageView.fileName = fileName
          // アナログ時計のアニメーションの開始
          self.minuteHandImageView.setAnalogClock()
        case 4:
          self.generalPreferences.secondHandFileName = fileName
          self.secondURLTextField.stringValue = filePath
          self.secondHandImageView.fileName = fileName
          // アナログ時計のアニメーションの開始
          self.secondHandImageView.setAnalogClock()
        case 5:
          self.generalPreferences.animation1FileName = fileName
          self.animation1URLTextField.stringValue = filePath
          
          // アナログ時計アニメーションの再描画
          self.analogAnimationImageView.gifFileName1 = fileName
          self.analogAnimationImageView.startAnimationForPreview()
        case 6:
          self.generalPreferences.animation2FileName = fileName
          self.animation2URLTextField.stringValue = filePath
          
          // アナログ時計アニメーションの再描画
          self.analogAnimationImageView.gifFileName2 = fileName
          self.analogAnimationImageView.startAnimationForPreview()
        case 7:
          self.generalPreferences.animation3FileName = fileName
          self.animation3URLTextField.stringValue = filePath
          
          // デジタル時計アニメーションの再描画
          self.digitalAnimationImageView.gifFileName1 = fileName
          self.digitalAnimationImageView.startAnimationForPreview()
        case 8:
          self.generalPreferences.animation4FileName = fileName
          self.animation4URLTextField.stringValue = filePath
          
          // デジタル時計アニメーションの再描画
          self.digitalAnimationImageView.gifFileName2 = fileName
          self.digitalAnimationImageView.startAnimationForPreview()
        default:
          print("Which button?")
        }
      case NSApplication.ModalResponse.cancel:
        print("File Selection has been canceled.")
      default:
        print("Neither Select nor Cancel")
      }
    })
  }
  
  @IBAction func selectGIFWithTextField(_ sender: NSTextField) {
    switch sender.tag {
      /*
       1: 盤面GIF
       2: 短針GIF
       3: 長針GIF
       4: 秒針GIF
       5: アニメーションGIF①
       6: アニメーションGIF②
       7: アニメーションGIF③
       8: アニメーションGIF④
       */
    case 1:
      generalPreferences.faceFileName = sender.stringValue
    case 2:
      generalPreferences.hourHandFileName = sender.stringValue
    case 3:
      generalPreferences.minuteHandFileName = sender.stringValue
    case 4:
      generalPreferences.secondHandFileName = sender.stringValue
    case 5:
      generalPreferences.animation1FileName = sender.stringValue
    case 6:
      generalPreferences.animation2FileName = sender.stringValue
    case 7:
      generalPreferences.animation3FileName = sender.stringValue
    case 8:
      generalPreferences.animation4FileName = sender.stringValue
    default:
      return
    }
  }
  
  // MARK: - デジタル時計
  /// タイマー or 時計のモード選択時に実行される処理
  @IBAction func setIsTimer(_ sender: Any) {
    // タイマーが選択された場合
    if (timerRadioButton.state.rawValue == 1) {
      generalPreferences.isTimer = true
    }
    // 時計が選択された場合
    if (clockRadioButton.state.rawValue == 1) {
      generalPreferences.isTimer = false
    }
    // DigitalTimeの再計算(デジタル時計プレビューの更新)
    digitalPreviewLabel.digitalTime = DigitalTime()
  }
  
  /// 期限超過時のチェックボックス変更時の処理
  @IBAction func switchCurrentTime(_ sender: NSButton) {
    if (sender.state.rawValue == 1) {
      generalPreferences.isSwitchingCurrentTime = true
    }
    else {
      generalPreferences.isSwitchingCurrentTime = false
    }
    // DigitalTimeの再計算(デジタル時計プレビューの更新)
    digitalPreviewLabel.digitalTime = DigitalTime()
  }
  
  
  // 期限変更時の処理
  @IBAction func setDueDate(_ sender: NSDatePicker) {
    switch sender.tag {
    case 1:
      generalPreferences.dueDate1 = sender.dateValue
    case 2:
      // MARK: 期限①より前の日時を入力される可能性があるため、その場合はタイマー設定時に弾く
      generalPreferences.dueDate2 = sender.dateValue
    default:
      return
    }
    // DigitalTimeの再計算(デジタル時計プレビューの更新)
    digitalPreviewLabel.digitalTime = DigitalTime()
  }
  
  /// フォントの選択ボタンを押下した場合に呼び出される処理
  @IBAction func selectFont(_ sender: Any) {
    let fontManager = NSFontManager.shared
    // VCをNSFontManagerのレシーバとしてセット
    fontManager.target = self
    guard let panel = fontManager.fontPanel(true) else {
      return
    }
    // FontPanelを前面に表示
    panel.orderFront(self)
    panel.isEnabled = true
  }
  
  /// デジタル時計のフォントカラーを変更した場合に呼び出される処理
  @IBAction func changeFontColor(_ sender: NSColorWell) {
    switch sender.tag {
      /*
       1: フォントカラー(基本)
       2: フォントカラー(直前)
       3: フォントカラー(直後)
       */
    case 1:
      generalPreferences.baseFontColor = sender.color
    case 2:
      generalPreferences.beforeFontColor = sender.color
    case 3:
      generalPreferences.afterFontColor = sender.color
    default:
      return
    }
    // フォントカラーをセット
    digitalPreviewLabel.textColor = generalPreferences.baseFontColor.withAlphaComponent(generalPreferences.opacity)
    // DigitalTimeの再計算(デジタル時計プレビューの更新)
    digitalPreviewLabel.digitalTime = DigitalTime()
  }
  
  /// デジタル時計のフォントカラー変更期間を変更した場合に呼び出される処理
  /// DatePickerは実行日当日の時刻を指しているため、実行日当日の午前0時との差分を算出
  /// → 例えばDatePicker上で0:05:00となっている場合、「5分間」という意味ではなく「実行日のAM 0:05」を指しているため、
  ///   0:05:00 - 0:00:00 から「5分間(厳密には300[秒])」を算出している
  @IBAction func setDuration(_ sender: NSDatePicker) {
    let now = Date()
    let calendar = Calendar.current
    let year = calendar.component(.year, from: now)
    let month = calendar.component(.month, from: now)
    let day = calendar.component(.day, from: now)
    let executeDate = calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0))!
    
    switch sender.tag {
    case 1:
      let diffSec: Int = Int(beforeDatePicker.dateValue.timeIntervalSince(executeDate).rounded(.towardZero))
      generalPreferences.beforeSec = diffSec
    case 2:
      let diffSec: Int = Int(afterDatePicker.dateValue.timeIntervalSince(executeDate).rounded(.towardZero))
      generalPreferences.afterSec = diffSec
    default:
      return
    }
    // DigitalTimeの再計算(デジタル時計プレビューの更新)
    digitalPreviewLabel.digitalTime = DigitalTime()
  }
  
  /// Sliderから透明度の値を変更した場合に呼び出される処理
  @IBAction func setOpacityWithSlider(_ sender: NSSlider) {
    let opacity = sender.doubleValue
    opacityTextField.doubleValue = opacity
    generalPreferences.opacity = opacity
    
    // フォントカラーをセット
    digitalPreviewLabel.textColor = generalPreferences.baseFontColor.withAlphaComponent(generalPreferences.opacity)
    
    // DigitalTimeの再計算(デジタル時計プレビューの更新)
    digitalPreviewLabel.digitalTime = DigitalTime()
  }
  
  /// TextFieldから透明度の値を変更した場合に呼び出される処理
  @IBAction func setOpacityWithTextField(_ sender: NSTextField) {
    // 最大・最小はStoryboardのプロパティで指定しているため考慮しなくてよい
    let opacity = sender.doubleValue
    opacitySlider.doubleValue = opacity
    generalPreferences.opacity = opacity
    
    // フォントカラーをセット
    digitalPreviewLabel.textColor = generalPreferences.baseFontColor.withAlphaComponent(generalPreferences.opacity)
    
    // DigitalTimeの再計算(デジタル時計プレビューの更新)
    digitalPreviewLabel.digitalTime = DigitalTime()
  }
  
  
}

extension GeneralPreferencesViewController: NSFontChanging {
  // FontPanelでのフォント選択時に呼び出される処理
  func changeFont(_ sender: NSFontManager?) {
    guard let fontManager = sender else {
      return
    }
    generalPreferences.fontName = fontManager.convert(
      NSFont(name: generalPreferences.fontName, size: NSFont.systemFontSize)!
    ).fontName
    fontTextField.stringValue = generalPreferences.fontName
    
    // フォントの変更
    digitalPreviewLabel.font = NSFont(name: generalPreferences.fontName, size: 100)!
  }
}
