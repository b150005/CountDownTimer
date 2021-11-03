//
//  PreferencesWindow.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/03.
//

import Cocoa

///  各種設定(Preferences)のウィンドウを管理するクラス
class PreferencesWindow: NSPanel {
  
  // ユーザ操作によるTabBarの非表示を無効化
  // -> 2021/10/3時点ではTabBarの非表示はできなさそう..?
  override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
    switch menuItem.action {
    case #selector(toggleToolbarShown(_:))?:
      return false
    default:
      return super.validateMenuItem(menuItem)
    }
  }
}
