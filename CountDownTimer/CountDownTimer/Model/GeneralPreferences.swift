//
//  GeneralPreferences.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/03.
//

import Foundation
import Cocoa

/// 各種設定(Preferences)のGeneralタブのデータモデルを管理するクラス
class GeneralPreferences {
  /// UserDefaults(アプリ内DB)に格納するキー
  enum UserDefaultsKey: String {
    /// 時計の表示モード(アナログ or デジタル)
    /// `true`の場合はアナログ時計が表示され、`false`の場合はデジタル時計が表示される
    case isAnalog
    /// アナログ時計の盤面(face)となるgifファイル名
    case faceFileName
    /// アナログ時計の短針となるgifファイル名
    case hourHandFileName
    /// アナログ時計の長針となるgifファイル名
    case minuteHandFileName
    /// アナログ時計の秒針となるgifファイル名
    case secondHandFileName
    /// アナログ時計に反映するアニメーション①ファイル名
    case animation1FileName
    /// アナログ時計に反映するアニメーション②ファイル名
    case animation2FileName
    /// デジタルタイマーの表示モード(タイマーor時計)
    /// `true`の場合は指定期限へのタイマーとして機能し、`false`の場合はデジタル時計として機能する
    case isTimer
    /// 最終期限(期限②が設定されている場合は期限②)到達後にデジタル時計へと移行するかどうかを表すフラグ
    /// デジタル時計に移行しない(false)場合は、最終期限からの経過時刻を表す
    case isSwitchingCurrentTime
    /// デジタル時計に反映するアニメーション③ファイル名
    case animation3FileName
    /// デジタル時計に反映するアニメーション④ファイル名
    case animation4FileName
    /// フォント情報
    case fontName
    /// フォントカラー(基本)
    case baseFontColor
    /// フォントカラー(直前)
    case beforeFontColor
    /// フォントカラー(直後)
    case afterFontColor
    /// フォントカラー(直前)の適用時間[秒]
    case beforeSec
    /// フォントカラー(直後)の適用時間[秒]
    case afterSec
    /// 文字の透明度
    /// 小数点以下1桁の0-1の値で表現する
    case opacity
  }
  
  /// シングルトンパターン
  /// → staticなインスタンスプロパティを用意し、init()をprivateで記述
  static let shared: GeneralPreferences = GeneralPreferences()
  
  /// 初期化処理
  private init() {
    // UserDefaultsの辞書生成
    UserDefaults.standard.register(defaults: [
      UserDefaultsKey.isAnalog.rawValue : false,
      
      UserDefaultsKey.faceFileName.rawValue : "",
      UserDefaultsKey.hourHandFileName.rawValue : "",
      UserDefaultsKey.minuteHandFileName.rawValue : "",
      UserDefaultsKey.secondHandFileName.rawValue : "",
      UserDefaultsKey.animation1FileName.rawValue : "",
      UserDefaultsKey.animation2FileName.rawValue : "",
      
      UserDefaultsKey.isTimer.rawValue : false,
      UserDefaultsKey.isSwitchingCurrentTime.rawValue : false,
      UserDefaultsKey.animation3FileName.rawValue : "",
      UserDefaultsKey.animation4FileName.rawValue : "",
      UserDefaultsKey.fontName.rawValue : "HiraginoSans-W7",
      UserDefaultsKey.baseFontColor.rawValue : NSColor.gray,
      UserDefaultsKey.beforeFontColor.rawValue : NSColor.white,
      UserDefaultsKey.afterFontColor.rawValue : NSColor.black,
      UserDefaultsKey.beforeSec.rawValue: 300,
      UserDefaultsKey.afterSec.rawValue: 300,
      UserDefaultsKey.opacity.rawValue : 0.5,
    ])
  }
  
  var isAnalog: Bool {
    get {
      return UserDefaults.standard.bool(forKey: UserDefaultsKey.isAnalog.rawValue)
    }
    set (isAnalog) {
      UserDefaults.standard.set(isAnalog, forKey: UserDefaultsKey.isAnalog.rawValue)
    }
  }
  
  var faceFileName: String {
    get {
      guard let faceFileName = UserDefaults.standard.string(forKey: UserDefaultsKey.faceFileName.rawValue) else {
        return ""
      }
      return faceFileName
    }
    set(faceFileName) {
      UserDefaults.standard.set(faceFileName, forKey: UserDefaultsKey.faceFileName.rawValue)
    }
  }
  
  var hourHandFileName: String {
    get {
      guard let hourHandFileName = UserDefaults.standard.string(forKey: UserDefaultsKey.hourHandFileName.rawValue) else {
        return ""
      }
      return hourHandFileName
    }
    set(hourHandFileName) {
      UserDefaults.standard.set(hourHandFileName, forKey: UserDefaultsKey.hourHandFileName.rawValue)
    }
  }
  
  var minuteHandFileName: String {
    get {
      guard let minuteHandFileName = UserDefaults.standard.string(forKey: UserDefaultsKey.minuteHandFileName.rawValue) else {
        return ""
      }
      return minuteHandFileName
    }
    set(minuteHandFileName) {
      UserDefaults.standard.set(minuteHandFileName, forKey: UserDefaultsKey.minuteHandFileName.rawValue)
    }
  }
  
  var secondHandFileName: String {
    get {
      guard let secondHandFileName = UserDefaults.standard.string(forKey: UserDefaultsKey.secondHandFileName.rawValue) else {
        return ""
      }
      return secondHandFileName
    }
    set(secondHandFileName) {
      UserDefaults.standard.set(secondHandFileName, forKey: UserDefaultsKey.secondHandFileName.rawValue)
    }
  }
  
  var animation1FileName: String {
    get {
      guard let animation1FileName = UserDefaults.standard.string(forKey: UserDefaultsKey.animation1FileName.rawValue) else {
        return ""
      }
      return animation1FileName
    }
    set(animation1FileName) {
      UserDefaults.standard.set(animation1FileName, forKey: UserDefaultsKey.animation1FileName.rawValue)
    }
  }
  
  var animation2FileName: String {
    get {
      guard let animation2FileName = UserDefaults.standard.string(forKey: UserDefaultsKey.animation2FileName.rawValue) else {
        return ""
      }
      return animation2FileName
    }
    set(animation2FileName) {
      UserDefaults.standard.set(animation2FileName, forKey: UserDefaultsKey.animation2FileName.rawValue)
    }
  }
  
  var isTimer: Bool {
    get {
      return UserDefaults.standard.bool(forKey: UserDefaultsKey.isTimer.rawValue)
    }
    set (isTimer) {
      UserDefaults.standard.set(isTimer, forKey: UserDefaultsKey.isTimer.rawValue)
    }
  }
  
  var dueDate1: Date = Calendar.current.date(byAdding: .hour, value: +1, to: Date())!
  var dueDate2: Date = Calendar.current.date(byAdding: .hour, value: +2, to: Date())!
  
  var isSwitchingCurrentTime: Bool {
    get {
      return UserDefaults.standard.bool(forKey: UserDefaultsKey.isSwitchingCurrentTime.rawValue)
    }
    set (isSwitchingCurrentTime) {
      UserDefaults.standard.set(isSwitchingCurrentTime, forKey: UserDefaultsKey.isSwitchingCurrentTime.rawValue)
    }
  }
  
  var animation3FileName: String {
    get {
      guard let animation3FileName = UserDefaults.standard.string(forKey: UserDefaultsKey.animation3FileName.rawValue) else {
        return ""
      }
      return animation3FileName
    }
    set(animation3FileName) {
      UserDefaults.standard.set(animation3FileName, forKey: UserDefaultsKey.animation3FileName.rawValue)
    }
  }
  
  var animation4FileName: String {
    get {
      guard let animation4FileName = UserDefaults.standard.string(forKey: UserDefaultsKey.animation4FileName.rawValue) else {
        return ""
      }
      return animation4FileName
    }
    set(animation4FileName) {
      UserDefaults.standard.set(animation4FileName, forKey: UserDefaultsKey.animation4FileName.rawValue)
    }
  }
  
  var fontName: String {
    get {
      guard let name = UserDefaults.standard.string(forKey: UserDefaultsKey.fontName.rawValue) else {
        return NSFont.systemFont(ofSize: NSFont.systemFontSize).fontName
      }
      return name
    }
    set(fontName) {
      UserDefaults.standard.set(fontName, forKey: UserDefaultsKey.fontName.rawValue)
    }
  }
  
  var baseFontColor: NSColor {
    get {
      guard let colorData = UserDefaults.standard.data(forKey: UserDefaultsKey.baseFontColor.rawValue) else {
        return NSColor.gray
      }
      guard let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? NSColor else {
        return NSColor.gray
      }
      return color
    }
    set(color) {
      guard let colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData? else {
        return
      }
      UserDefaults.standard.set(colorData, forKey: UserDefaultsKey.baseFontColor.rawValue)
    }
  }
  
  var beforeFontColor: NSColor {
    get {
      guard let colorData = UserDefaults.standard.data(forKey: UserDefaultsKey.beforeFontColor.rawValue) else {
        return NSColor.white
      }
      guard let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? NSColor else {
        return NSColor.white
      }
      return color
    }
    set(color) {
      guard let colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData? else {
        return
      }
      UserDefaults.standard.set(colorData, forKey: UserDefaultsKey.beforeFontColor.rawValue)
    }
  }
  
  var afterFontColor: NSColor {
    get {
      guard let colorData = UserDefaults.standard.data(forKey: UserDefaultsKey.afterFontColor.rawValue) else {
        return NSColor.black
      }
      guard let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? NSColor else {
        return NSColor.black
      }
      return color
    }
    set(color) {
      guard let colorData = NSKeyedArchiver.archivedData(withRootObject: color) as NSData? else {
        return
      }
      UserDefaults.standard.set(colorData, forKey: UserDefaultsKey.afterFontColor.rawValue)
    }
  }
  
  var beforeSec: Int {
    get {
      return UserDefaults.standard.integer(forKey: UserDefaultsKey.beforeSec.rawValue)
    }
    set (beforeSec) {
      UserDefaults.standard.set(beforeSec, forKey: UserDefaultsKey.beforeSec.rawValue)
    }
  }
  
  var afterSec: Int {
    get {
      return UserDefaults.standard.integer(forKey: UserDefaultsKey.afterSec.rawValue)
    }
    set (afterSec) {
      UserDefaults.standard.set(afterSec, forKey: UserDefaultsKey.afterSec.rawValue)
    }
  }
  
  var opacity: Double {
    get {
      let opacity = UserDefaults.standard.double(forKey: UserDefaultsKey.opacity.rawValue)
      return opacity
    }
    set(opacity) {
      if (opacity >= 0 && opacity <= 1) {
        UserDefaults.standard.set(opacity, forKey: UserDefaultsKey.opacity.rawValue)
      }
    }
  }
}
