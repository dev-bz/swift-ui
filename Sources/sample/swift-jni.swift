//import Foundation
import ui

var body: View?
@_cdecl("Java_com_test_ui_Swift_message") public func Java_com_test_ui_Swift_view(env_: _JNIEnv, cls: Class, type: Message, obj: Object, arg: Object) -> Object {
  switch type {
  case 0:
    let _ = Context(env: env_, ctx: obj)
    body = TContentView(on: true).body
    logging(type: "Swift", message: "build: \(body!) with \(obj) \(arg)")
  default: break
  }
  return body!.obj
}
@_cdecl("Java_com_test_ui_Swift_messageVoid") public func Java_com_test_ui_Swift_void(env_: _JNIEnv, cls: Class, type: Message, obj: Object, arg: Object) {
  switch type {
  case 1:
    logging(type: "Swift", message: "click: \(body!) with \(obj) \(arg)")
    if let view = Context.find(obj), let clk = view.click { clk(obj, view) }
  case 3: print("before")
  case 4: print("after")
  case 5: print("changed")
  default: break
  }
}
@_cdecl("Java_com_test_ui_Swift_messageBool") public func Java_com_test_ui_Swift_bool(env_: _JNIEnv, cls: Class, type: Message, obj: Object, arg: Object) -> Boolean {
  switch type {

  case 2:
    logging(type: "Swift", message: "long swift")
    if let view = Context.find(obj), let clk = view.long { return clk(obj, view) }
    return 1
  default: break
  }
  return 0
}
