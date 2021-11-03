//
//  WindowController.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/03.
//

import Cocoa

/// アプリケーションウィンドウを制御するクラス
class WindowController: NSWindowController {
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    // アプリケーションウィンドウの背景透過
    window?.isOpaque = false
    window?.backgroundColor = NSColor(white: 1, alpha: 0)

    // タイトルバーの非表示
    window?.titlebarAppearsTransparent = true
    window?.titleVisibility = .hidden

    // アプリケーションの「終了」「最小化」「最大化」ボタンの非表示
    window?.styleMask = .fullSizeContentView
    // アプリケーションの「終了」「最小化」「最大化」ボタンの表示
    // -> ユーザの要望によってはこちらを利用
//    window?.styleMask.insert(.fullSizeContentView)

    // コンテンツ部分のドラッグによる移動を可能にする
    window?.isMovableByWindowBackground = true
  }
  
}
