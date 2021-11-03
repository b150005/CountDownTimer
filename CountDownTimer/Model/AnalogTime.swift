//
//  AnalogTime.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/28.
//

import Cocoa

class AnalogTime {
  var hour: Int = 0
  var minute: Int = 0
  var second: Int = 0
  
  init(){
    self.setAsClock()
  }
  
  /// アナログ時計としてプロパティを初期化
  private func setAsClock() {
    let date = Date()
    let calendar = Calendar.current
    
    // 日本時間(GMT+9:00:00)を取得
    // MARK: - Dateオブジェクトから時・分・秒などの値を抽出する場合はCalendar#component(_:from:)を利用
    self.hour = calendar.component(.hour, from: date)
    self.minute = calendar.component(.minute, from: date)
    self.second = calendar.component(.second, from: date)
  }
  
  /// 現在時刻を0:00:00からの経過時間[秒]で取得(最大を12:00:00とする)
  func getElapsedSec() -> Int {
    if (self.hour >= 12) {
      return (self.hour - 12) * 3600 + self.minute * 60 + self.second
    }
    else {
      return self.hour * 3600 + self.minute * 60 + self.second
    }
  }
}
