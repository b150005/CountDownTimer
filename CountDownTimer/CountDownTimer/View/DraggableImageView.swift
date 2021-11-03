//
//  DraggableImageView.swift
//  CountDown
//
//  Created by 伊藤直輝 on 2021/10/20.
//

import Cocoa

/// ドラッグによるウィンドウ移動が可能なNSImageViewクラス
class DraggableImageView: NSImageView {
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
}
