//
//  DigitalTime.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/13.
//

import Cocoa

class DigitalTime {
  let generalPreferences: GeneralPreferences = GeneralPreferences.shared
  
  static var isMinus: Bool = false
  // [期限超過の場合は現在時刻を表示する設定 かつ 期限超過]の場合にのみtrueに変更される
  static var temporaryClockMode: Bool = false
  
  static var hour: Int = 0
  static var minute: Int = 0
  static var second: Int = 0
  
  init(){
    // タイマーの場合のみ
    if (generalPreferences.isTimer) {
      setAsTimer()
    }
  }
  
  /// タイマーとしてプロパティを初期化(期限①)
  private func setAsTimer() {
    // 引数の日時との差(呼出元Dateオブジェクト - 引数Dateオブジェクト)[秒]
    // MARK: - 2つのDate間の差を知りたい場合はDate#timeIntervalSince(_:)を利用
    var diffSec: Int = Int(generalPreferences.dueDate1.timeIntervalSinceNow.rounded())
    
    if (diffSec >= 0) {
      DigitalTime.isMinus = false
    }
    else {
      DigitalTime.isMinus = true
      diffSec *= -1
    }
    
    DigitalTime.hour = diffSec / 3600
    DigitalTime.minute = (diffSec - DigitalTime.hour * 3600) / 60
    DigitalTime.second = diffSec - DigitalTime.hour * 3600 - DigitalTime.minute * 60
  }
  
  /// タイマーから1秒デクリメントする
  /// → Timer()で毎秒呼び出される処理
  func decrementTimer() {
    var remainsSec: Int = self.getRemainsSec()
    
    if (remainsSec > 0) {
      DigitalTime.isMinus = false
      remainsSec -= 1
    }
    else {
      DigitalTime.isMinus = true
      remainsSec *= -1
      remainsSec += 1
    }
    
    DigitalTime.hour = remainsSec / 3600
    DigitalTime.minute = (remainsSec - DigitalTime.hour * 3600) / 60
    DigitalTime.second = remainsSec - DigitalTime.hour * 3600 - DigitalTime.minute * 60
  }
  
  /// デジタル時計としてプロパティを初期化
  /// → Timer()で毎秒呼び出される処理
  func setAsClock() {
    let date = Date()
    let calendar = Calendar.current
    
    // 日本時間(GMT+9:00:00)を取得
    // MARK: - Dateオブジェクトから時・分・秒などの値を抽出する場合はCalendar#component(_:from:)を利用
    DigitalTime.hour = calendar.component(.hour, from: date)
    DigitalTime.minute = calendar.component(.minute, from: date)
    DigitalTime.second = calendar.component(.second, from: date)
  }
  
  /// 残り時間[秒]を返却
  /// `GeneralPreferences#isTimer == true`の場合のみ利用
  /// → 未到達の場合は0以上の値、期限超過の場合は負の値を返却
  func getRemainsSec() -> Int {
    if (DigitalTime.isMinus) {
      return (DigitalTime.hour * 3600 + DigitalTime.minute * 60 + DigitalTime.second) * -1
    }
    else {
      return (DigitalTime.hour * 3600 + DigitalTime.minute * 60 + DigitalTime.second)
    }
  }
}
