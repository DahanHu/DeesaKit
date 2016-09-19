//
//  DeesaActor.swift
//  Deesa
//
//  Created by Dahan Hu on 4/5/16.
//  Copyright © 2016 AppHeader. All rights reserved.
//

import UIKit

class DeesaActor: NSObject {

  var stage: Dictionary<AnyHashable,AnyObject>?
  var controller: DeesaController?
  var webView: UIView?
  
  init(stage: Dictionary<AnyHashable,AnyObject>?) {
    self.stage = stage
  }
  
  func act() {
    guard let dic = stage, !dic.isEmpty else { return }
    guard let className = dic["className"]?.description,
      let funcName = dic["funcName"]?.description else { return }
    guard let clazz = NSClassFromString((Bundle.main.object(forInfoDictionaryKey: "CFBundleName")! as AnyObject).description + "." + className) as? DeesaPlugin.Type
      else {
        debugPrint("Not found! Class `\(className)`")
        return
    }
    let obj = clazz.init()
    let funcSelector = Selector(funcName + ":")
    if obj.responds(to: funcSelector) {
      obj.controller = self.controller
      obj.webView = self.webView
      obj.callbackId = dic["callbackId"]?.intValue
      obj.perform(funcSelector, with: DeesaArguments(data: dic["data"]))
    } else {
      debugPrint("Not found `\(funcSelector)` in `\(className)` class")
    }
  }
  
}
