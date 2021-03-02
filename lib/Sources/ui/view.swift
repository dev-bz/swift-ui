#if TERMUX
  import SwiftGlibc.jni
#else
  import Native.jni
#endif
public typealias _JNIEnv = UnsafeMutablePointer<JNIEnv?>
public typealias Object = jobject
public typealias Class = jclass
@_functionBuilder public struct Builder<T> {
  public static func buildBlock(_ content: T...) -> [T] {
    return content
  }
  /*static func buildEither<TrueContent, FalseContent>(first: TrueContent) -> ConditionalContent<TrueContent, FalseContent>{
	return ConditionalContent<TrueContent, FalseContent>(first)
	}
	static func buildEither<TrueContent, FalseContent>(second: FalseContent) -> ConditionalContent<TrueContent, FalseContent>{
	return ConditionalContent<TrueContent, FalseContent>(second)
	}*/
}

extension _JNIEnv {
  func list(type: String, name: String) -> String {
    var out: String = type

    if let env = pointee?.pointee {
      #if false
        if let cls = env.FindClass(self, "java/lang/Class") {
          var args = new(text: name)
          guard let obj = call(cls, name: "forName", type: "(Ljava/lang/String;)Ljava/lang/Class;", args: &args) else { return out }
          var empty = jvalue()
          if let arr = call(obj, cls, name: "getMethods", object: "()[Ljava/lang/reflect/Method;", args: &empty) {
            let len = env.GetArrayLength(self, arr)
            guard let mcls = env.FindClass(self, "java/lang/reflect/Method") else { return out }
            for id in 0..<len {
              guard let item = env.GetObjectArrayElement(self, arr, id) else { return out }
              guard let str = call(item, mcls, name: "toString", object: "()Ljava/lang/String;", args: &empty) else { break }
              if let cText = env.GetStringUTFChars(self, str, nil) {
                let text = String(cString: cText)
                out.append("\n")
                out.append(text)
                env.ReleaseStringUTFChars(self, str, cText)
              }
            }
          }
        }
      #else
        if let cls = env.FindClass(self, "android/R$layout") {
          out.append("\n\(cls)")
          if let f = env.GetStaticFieldID(self, cls, "simple_list_item_1", "I") {
            out.append("\n\(f)")
            let value: jint = env.GetStaticIntField(self, cls, f)
            out.append("\n\(value)")
          }
          if let sub = env.FindClass(self, "android/R$id") {
            out.append("\n\(sub)")
            if let f = env.GetStaticFieldID(self, sub, "text1", "I") {
              out.append("\n\(f)")
              let value: jint = env.GetStaticIntField(self, sub, f)
              out.append("\n\(value)")
            }
          }
        }
      #endif
    }
    return out
  }
  func find(type: String) -> jclass? {
    if let e = pointee?.pointee {
      return e.FindClass(self, type)!
    }
    return nil
  }
  func new(type: jclass, ctx: jobject) -> jobject? {
    if let e = pointee?.pointee {
      if let m = e.GetMethodID(self, type, "<init>", "(Landroid/content/Context;)V") {
        var ctx = jvalue(l: ctx)
        return e.NewObjectA(self, type, m, &ctx)
      }
    }
    return nil
  }
  func new(type: jclass, arg: String, args: [jvalue]) -> jobject? {
    if let e = pointee?.pointee {
      if let m = e.GetMethodID(self, type, "<init>", "(Landroid/content/Context;\(arg))V") {
        let u = args.withUnsafeBufferPointer({ o in return o.baseAddress })
        return e.NewObjectA(self, type, m, u)
      }
    }
    return nil
  }
  func getValue(cls: jclass, name: String) -> jint {
    if let env = pointee?.pointee {
      if let f = env.GetStaticFieldID(self, cls, name, "I") {
        return env.GetStaticIntField(self, cls, f)
      }
    }
    return -1
  }
  func new(text: String) -> jvalue {
    return jvalue(l: pointee?.pointee.NewStringUTF(self, text))
  }
  func call(_ obj: jobject, _ cls: jclass, name: String, type: String, args: UnsafePointer<jvalue>) {
    if let env = pointee?.pointee {
      if let m = env.GetMethodID(self, cls, name, type) {
        env.CallVoidMethodA(self, obj, m, args)
      }
    }
  }
  func call(_ obj: jobject, _ cls: jclass, name: String, object: String, args: UnsafePointer<jvalue>) -> jobject? {
    if let env = pointee?.pointee {
      if let m = env.GetMethodID(self, cls, name, object) {
        return env.CallObjectMethodA(self, obj, m, args)
      }
    }
    return nil
  }
  func call(_ cls: jclass, name: String, type: String, args: UnsafePointer<jvalue>) -> jobject? {
    if let env = pointee?.pointee {
      if let m = env.GetStaticMethodID(self, cls, name, type) {
        return env.CallStaticObjectMethodA(self, cls, m, args)
      }
    }
    return nil
  }
}
public struct Context {
  let env: _JNIEnv?
  let context: Object?
}
public protocol View {
  var obj: Object? { get }
}
protocol Group: View {
  func addView(child: View, w: jint, h: jint)
  var cls: jclass? { get }
  init(children: () -> [View])
}
public struct List: View {
  public var obj: Object?
  public init(@Builder<String> children: () -> [String]) {
    let cls = Self.env().find(type: "android/widget/ListView")
    let layout = Self.env().find(type: "android/R$layout")
    let id = Self.env().find(type: "android/R$id")
    obj = Self.env().new(type: cls!, ctx: Self.ctx())
    if let cls_ = Self.env().find(type: "android/widget/ArrayAdapter") {
      let ids: [jvalue] = [jvalue(l: Self.ctx()), jvalue(i: Self.env().getValue(cls: layout!, name: "simple_list_item_1")), jvalue(i: Self.env().getValue(cls: id!, name: "text1"))]
      if let adapter = Self.env().new(type: cls_, arg: "II", args: ids) {
        for s in children() {
          var args = Self.env().new(text: s)
          Self.env().call(adapter, cls_, name: "add", type: "(Ljava/lang/Object;)V", args: &args)
        }
        var args = jvalue(l: adapter)
        Self.env().call(obj!, cls!, name: "setAdapter", type: "(Landroid/widget/Adapter;)V", args: &args)
      }
    }
  }
}
public struct ScrollView: Group {
  static let type: String = "android/widget/ScrollView"
  var cls: jclass?
  public let obj: Object?
  public init(@Builder<View> children: () -> [View]) {
    cls = Self.env().find(type: Self.type)
    obj = Self.env().new(type: cls!, ctx: Self.ctx())
    for view in children() {
      addView(child: view)
      break
    }
  }
  public func with(fillViewport: Bool) -> Self {
    var args = jvalue(z: jboolean(fillViewport ? JNI_TRUE : JNI_FALSE))
    Self.env().call(obj!, cls!, name: "setFillViewport", type: "(Z)V", args: &args)
    return self
  }
}
public struct Gravity {
  public static let BOTTOM = 80
  public static let CENTER = 17
  public static let CENTER_HORIZONTAL = 1
  public static let CENTER_VERTICAL = 16
  public static let CLIP_HORIZONTAL = 8
  public static let CLIP_VERTICAL = 128
  public static let DISPLAY_CLIP_HORIZONTAL = 16_777_216
  public static let DISPLAY_CLIP_VERTICAL = 268_435_456
  public static let END = 8_388_613
  public static let FILL = 119
  public static let FILL_HORIZONTAL = 7
  public static let FILL_VERTICAL = 112
  public static let HORIZONTAL_GRAVITY_MASK = 7
  public static let LEFT = 3
  public static let NO_GRAVITY = 0
  public static let RELATIVE_HORIZONTAL_GRAVITY_MASK = 8_388_615
  public static let RELATIVE_LAYOUT_DIRECTION = 8_388_608
  public static let RIGHT = 5
  public static let START = 8_388_611
  public static let TOP = 48
}
public struct LinearLayout: Group {
  public enum Orientation {
    case HORIZONTAL
    case VERTICAL
  }
  static var type = "android/widget/LinearLayout"
  var cls: jclass?
  public let obj: Object?
  var orientation: Orientation = .VERTICAL
  public init(@Builder<View> children: () -> [View]) {
    self.init(orientation: .VERTICAL, children: children)
  }
  public init(orientation: Orientation, @Builder<View> children: () -> [View]) {
    self.orientation = orientation
    cls = Self.env().find(type: Self.type)
    obj = Self.env().new(type: cls!, ctx: Self.ctx())
    let _ = with(orientation: self.orientation)
    for view in children() {
      if orientation == .VERTICAL {
        addView(child: view, w: -1)
      } else {
        addView(child: view)
      }
    }
  }
}
extension Group {
  func addView(child: View, w: jint = -2, h: jint = -2) {
    if let obj = obj {
      if let args = [jvalue(l: child.obj), jvalue(i: w), jvalue(i: h)].withUnsafeBufferPointer({ o in return o.baseAddress }) {
        Self.env().call(obj, cls!, name: "addView", type: "(Landroid/view/View;II)V", args: args)
      }
    }
  }
}
extension LinearLayout {
  public func with(orientation: Orientation) -> Self {
    var val = jvalue(i: (orientation == .VERTICAL) ? 1 : 0)
    Self.env().call(obj!, cls!, name: "setOrientation", type: "(I)V", args: &val)
    return self
  }
  public func with(gravity: Int) -> Self {
    var val = jvalue(i: jint(gravity))
    Self.env().call(obj!, cls!, name: "setGravity", type: "(I)V", args: &val)
    return self
  }
}
public struct TextView: View {
  static var type: String = "android/widget/TextView"
  var cls: jclass?
  public let obj: Object?
  public init(_ text: String, type: String) {
    cls = Self.env().find(type: type)
    obj = Self.env().new(type: cls!, ctx: Self.ctx())
    setText(text: text)
  }
  public init(_ text: String) {
    self.init(text, type: Self.type)
  }
  public func setText(text: String) {
    var s = Self.env().new(text: text)  // \(#function):\(#dsohandle), \(#file):\(#fileID) > \(#filePath)")
    Self.env().call(obj!, cls!, name: "setText", type: "(Ljava/lang/CharSequence;)V", args: &s)
  }
}
extension TextView {
  public func with(text: String) -> Self {
    setText(text: text)
    return self
  }
}
public struct Button: View {
  public var obj: Object? {
    t.obj
  }
  static var type: String = "android/widget/Button"
  let t: TextView
  public init(_ text: String) {
    t = TextView(text, type: Self.type)
  }
  public func setText(text: String) {
    t.setText(text: text)
  }
}
extension Button {
  public func with(text: String) -> Self {
    t.setText(text: text)
    return self
  }
}
var data: Context = Context(env: nil, context: nil)
extension View {
  static func env() -> _JNIEnv { data.env! }
  static func ctx() -> jobject { return data.context! }
  public static func debug() -> String {
    return Self.env().list(type: "android/widget/LinearLayout", name: "android.widget.LinearLayout")
  }
}
extension Context {
  public init(env: _JNIEnv, ctx: jobject) {
    self.env = env
    self.context = ctx
    data = self
  }
  //prefix static func ! (view: Self) -> jobject? { view.obj }
}
