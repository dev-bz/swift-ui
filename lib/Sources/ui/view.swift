#if TERMUX
  import SwiftGlibc.jni
#else
  import Native.jni
#endif
public typealias _JNIEnv = UnsafeMutablePointer<JNIEnv?>
public typealias Object = jobject
public typealias Class = jclass
public typealias Message = jint
public typealias Boolean = jboolean
public func logging(type: String, message: String) {
  let env = Context.env()
  let cls = env.find(type: "android/util/Log")
  let b = [env.new(text: type), env.new(text: message)]
  if let args = b.withUnsafeBufferPointer({ o in o.baseAddress }) {
    let _ = env.call(nil, cls, name: "d", int: "(Ljava/lang/String;Ljava/lang/String;)I", args: args)
  }
}
#if false
  public struct TContextView: View {
    public init(on: Bool) { self.on = on }
    @State var on: Bool = true
    let data = ["a", "b", "c", "d", "e", "f", "g"]
    public var obj: Object? { body.obj }
    private var body: some View {
      LinearLayout {
        LinearLayout(orientation: .HORIZONTAL) {
          Button("Make")
          Button("by swift 5.3.3")
        }.with(gravity: Gravity.CENTER_HORIZONTAL)  //.with(orientation: .HORIZONTAL)
        Button("Here a button")
        Button("Here a button too")
        List {
          "Hello"
          "World"
        }
        List(0...6) { id in
          "Item \(id)"
        }.with(weight: 1.0)
        do {
          TextView("Do control")
          TextView("Do test work")
        }
        if on {
          TextView("Test IF").with(gravity: Gravity.CENTER_HORIZONTAL)
          TextView("Next IF").with(gravity: Gravity.CENTER_HORIZONTAL)
        }
        List(data) { id in
          "\(id) is String"
        }.with(weight: 0.75)
        if on {
          TextView("USE IF TRUE")
          TextView("USE IF TRUE")
        } else {
          TextView("USE ELSE IF")
          TextView("USE ELSE IF")
        }
        ScrollView {
          TextView(Self.debug())
        }.with(fillViewport: true)
      }  //.with(orientation: .VERTICAL)
    }
  }

#endif

struct Switch: View {
  var obj: Object
  let objs: [View]
  init(_ objs: [View]) {
    self.objs = objs
    self.obj = data.context!
  }
}
@_functionBuilder public struct ListBuilder<T> {
  public static func buildBlock(_ content: T...) -> [T] {
    return content
  }
  public static func buildBlock(_ content: T) -> T {
    return content
  }
  public static func buildBlock<V, T>(_ header: V, _ content: [T]) -> (V?, [T], V?) {
    return (header, content, nil)
  }
  public static func buildBlock<T, V>(_ content: [T], _ footer: V) -> (V?, [T], V?) {
    return (nil, content, footer)
  }
  public static func buildBlock<V, T, W>(_ header: V, _ content: [T], _ footer: W) -> (V?, [T], W?) {
    return (header, content, footer)
  }
}
@_functionBuilder public struct Builder {
  public static func buildBlock(_ content: View...) -> [View] {
    return content
  }
  public static func buildDo(_ content: [View]) -> View {
    return Switch(content)
  }
  static public func buildEither(first: [View]) -> View {
    return Switch(first)
  }
  static public func buildEither(second: [View]) -> View {
    return Switch(second)
  }
  static public func buildIf(_ content: [View]?) -> View {
    return Switch(content ?? [])
  }
}
@propertyWrapper public struct State<Tp> {
  var value: Tp
  public var wrappedValue: Tp {
    get { value }
    set {
      value = newValue
      print("must update UI")
    }
  }
  public init(wrappedValue initialValue: Tp) { self.value = initialValue }
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
  func find(type: String) -> jclass {
    let e = pointee!.pointee
    return e.FindClass(self, type)!

  }
  func new(ctype: jclass) -> jobject {
    let e = pointee!.pointee
    let m = e.GetMethodID(self, ctype, "<init>", "(Landroid/content/Context;)V")
    var ctx = jvalue(l: Context.ctx())
    return e.NewObjectA(self, ctype, m, &ctx)!
  }
  func new(type: jclass, arg: String, args: [jvalue]) -> jobject {
    let e = pointee!.pointee
    let m = e.GetMethodID(self, type, "<init>", "(Landroid/content/Context;\(arg))V")
    let u = args.withUnsafeBufferPointer({ o in return o.baseAddress })
    return e.NewObjectA(self, type, m, u)!
  }
  func new(type: jclass) -> jobject {
    let e = pointee!.pointee
    let m = e.GetMethodID(self, type, "<init>", "()V")
    //let u = args.withUnsafeBufferPointer({ o in return o.baseAddress })
    return e.NewObjectA(self, type, m, nil)!
  }
  func getValue(cls: jclass, name: String, def: jint = -1) -> jint {
    if let env = pointee?.pointee {
      if let f = env.GetStaticFieldID(self, cls, name, "I") {
        return env.GetStaticIntField(self, cls, f)
      }
    }
    return def
  }
  func valueFloat(_ obj: Object, _ cls: Class, _ name: String, _ args: jvalue) {
    if let env = pointee?.pointee {
      if let f = env.GetFieldID(self, cls, name, "F") {
        env.SetFloatField(self, obj, f, args.f)
      }
    }
  }
  func valueInt(_ obj: Object, _ cls: Class, _ name: String, _ args: jvalue) {
    if let env = pointee?.pointee {
      if let f = env.GetFieldID(self, cls, name, "I") {
        env.SetIntField(self, obj, f, args.i)
      }
    }
  }
  func new(text: String) -> jvalue {
    return jvalue(l: pointee?.pointee.NewStringUTF(self, text))
  }
  func call(_ obj: jobject?, _ cls: jclass, name: String, void: String, args: UnsafePointer<jvalue>?) {
    if let env = pointee?.pointee {
      if let obj = obj {
        if let m = env.GetMethodID(self, cls, name, void) {
          env.CallVoidMethodA(self, obj, m, args)
        }
      } else {
        if let m = env.GetStaticMethodID(self, cls, name, void) {
          env.CallStaticVoidMethodA(self, cls, m, args)
        }
      }
    }
  }
  func call(_ obj: jobject?, clsn: String, name: String, int: String, args: UnsafePointer<jvalue>?) -> jint {
    if let env = pointee?.pointee {
      let cls = find(type: clsn)
      if let obj = obj {
        if let m = env.GetMethodID(self, cls, name, int) {
          return env.CallIntMethodA(self, obj, m, args)
        }
      } else {
        if let m = env.GetStaticMethodID(self, cls, name, int) {
          return env.CallStaticIntMethodA(self, cls, m, args)
        }
      }
    }
    return -1
  }
  func call(_ obj: jobject?, _ cls: jclass, name: String, int: String, args: UnsafePointer<jvalue>?) -> jint {
    if let env = pointee?.pointee {
      if let obj = obj {
        if let m = env.GetMethodID(self, cls, name, int) {
          return env.CallIntMethodA(self, obj, m, args)
        }
      } else {
        if let m = env.GetStaticMethodID(self, cls, name, int) {
          return env.CallStaticIntMethodA(self, cls, m, args)
        }
      }
    }
    return -1
  }
  func call(_ obj: jobject?, _ cls: jclass, name: String, object: String, args: UnsafePointer<jvalue>?) -> jobject? {
    if let env = pointee?.pointee {
      if let obj = obj {
        if let m = env.GetMethodID(self, cls, name, object) {
          return env.CallObjectMethodA(self, obj, m, args)
        }
      } else {
        if let m = env.GetStaticMethodID(self, cls, name, object) {
          return env.CallStaticObjectMethodA(self, cls, m, args)
        }
      }
    }
    return nil
  }
  /*func call(_ cls: jclass, name: String, type: String, args: UnsafePointer<jvalue>) -> jobject? {
    if let env = pointee?.pointee {
      if let m = env.GetStaticMethodID(self, cls, name, type) {
        return env.CallStaticObjectMethodA(self, cls, m, args)
      }
    }
    return nil
  }
  func call(_ cls: jclass, name: String, int: String, args: UnsafePointer<jvalue>) -> Int {
    if let env = pointee?.pointee {
      if let m = env.GetStaticMethodID(self, cls, name, int) {
        return Int(env.CallStaticIntMethodA(self, cls, m, args))
      }
    }
    return -1
  }*/
}
public struct Context {
  let env: _JNIEnv?
  let context: Object?
  var map: [jint: Button] = [:]
}
public protocol View {
  var obj: Object { get }
}
public typealias funcClick = (Object, View) -> Void
public typealias funcLong = (Object, View) -> Boolean
public protocol Clickable {
  var click: funcClick? { get }
  var long: funcLong? { get }
}
public protocol Graviting: View {
  var cls: Class { get }
}
public protocol Group: Graviting {
  func addView(child: View, w: jint, h: jint)
  init(children: () -> [View])
}
public struct Weight: View {
  public var obj: Object {
    view.obj
  }
  public var weight: Float
  public var view: View
}
public struct List: View {
  public var obj: Object
  public var weight: jvalue = jvalue(f: 0)
  public init(@ListBuilder<String> children: () -> (View?, [String], View?)) {
    var ret = Self.buildAdapter()
    obj = ret.obj
    let data = children()
    for s in data.1 {
      var args = Context.env().new(text: s)
      Context.env().call(ret.adapter.l, ret.clss, name: "add", void: "(Ljava/lang/Object;)V", args: &args)
    }
    Context.env().call(obj, ret.cls, name: "setAdapter", void: "(Landroid/widget/Adapter;)V", args: &ret.adapter)
    if let view = data.0 {
      var args = jvalue(l: view.obj)
      Context.env().call(obj, ret.cls, name: "addHeaderView", void: "(Landroid/view/View;)V", args: &args)
    }
    if let view = data.2 {
      var args = jvalue(l: view.obj)
      Context.env().call(obj, ret.cls, name: "addFooterView", void: "(Landroid/view/View;)V", args: &args)
    }
  }
  public init<T>(_ range: [T], header: View? = nil, footer: View? = nil, @ListBuilder<String> s: (T) -> String) {
    var ret = Self.buildAdapter()
    obj = ret.obj
    for id in range {
      var args = Context.env().new(text: s(id))
      Context.env().call(ret.adapter.l, ret.clss, name: "add", void: "(Ljava/lang/Object;)V", args: &args)
    }
    Context.env().call(obj, ret.cls, name: "setAdapter", void: "(Landroid/widget/Adapter;)V", args: &ret.adapter)
    if let view = header {
      var args = jvalue(l: view.obj)
      Context.env().call(obj, ret.cls, name: "addHeaderView", void: "(Landroid/view/View;)V", args: &args)
    }
    if let view = footer {
      var args = jvalue(l: view.obj)
      Context.env().call(obj, ret.cls, name: "addFooterView", void: "(Landroid/view/View;)V", args: &args)
    }
  }
  public init(_ range: ClosedRange<Int>, header: View? = nil, footer: View? = nil, @ListBuilder<String> s: (Int) -> String) {
    var ret = Self.buildAdapter()
    obj = ret.obj
    for id in range {
      var args = Context.env().new(text: s(id))
      Context.env().call(ret.adapter.l, ret.clss, name: "add", void: "(Ljava/lang/Object;)V", args: &args)
    }
    Context.env().call(obj, ret.cls, name: "setAdapter", void: "(Landroid/widget/Adapter;)V", args: &ret.adapter)
    if let view = header {
      var args = jvalue(l: view.obj)
      Context.env().call(obj, ret.cls, name: "addHeaderView", void: "(Landroid/view/View;)V", args: &args)
    }
    if let view = footer {
      var args = jvalue(l: view.obj)
      Context.env().call(obj, ret.cls, name: "addFooterView", void: "(Landroid/view/View;)V", args: &args)
    }
  }
  static func buildAdapter() -> (adapter: jvalue, cls: jclass, clss: jclass, obj: Object) {
    let cls = Context.env().find(type: "android/widget/ListView")
    let layout = Context.env().find(type: "android/R$layout")
    let id = Context.env().find(type: "android/R$id")
    let obj = Context.env().new(ctype: cls)
    let cls_ = Context.env().find(type: "android/widget/ArrayAdapter")
    let ids: [jvalue] = [jvalue(l: Context.ctx()), jvalue(i: Context.env().getValue(cls: layout, name: "simple_list_item_1")), jvalue(i: Context.env().getValue(cls: id, name: "text1"))]
    let adapter = Context.env().new(type: cls_, arg: "II", args: ids)
    return (jvalue(l: adapter), cls, cls_, obj)
  }
}
extension View {
  public func with(weight: Float) -> Weight {
    Weight(weight: weight, view: self)
  }
}
public struct ScrollView: Group {
  static let type: String = "android/widget/ScrollView"
  public var cls: Class
  public let obj: Object
  public init(@Builder children: () -> [View]) {
    cls = Context.env().find(type: Self.type)
    obj = Context.env().new(ctype: cls)
    for view in children() {
      addView(child: view)
      break
    }
  }
  public func with(fillViewport: Bool) -> Self {
    var args = jvalue(z: jboolean(fillViewport ? JNI_TRUE : JNI_FALSE))
    Context.env().call(obj, cls, name: "setFillViewport", void: "(Z)V", args: &args)
    return self
  }
}
public enum Gravity: jint {
  case BOTTOM = 80
  case CENTER = 17
  case CENTER_HORIZONTAL = 1
  case CENTER_VERTICAL = 16
  case CLIP_HORIZONTAL = 8
  case CLIP_VERTICAL = 128
  case DISPLAY_CLIP_HORIZONTAL = 16_777_216
  case DISPLAY_CLIP_VERTICAL = 268_435_456
  case END = 8_388_613
  case FILL = 119
  case FILL_HORIZONTAL = 7
  case FILL_VERTICAL = 112
  case LEFT = 3
  case NO_GRAVITY = 0
  case RELATIVE_HORIZONTAL_GRAVITY_MASK = 8_388_615
  case RELATIVE_LAYOUT_DIRECTION = 8_388_608
  case RIGHT = 5
  case START = 8_388_611
  case TOP = 48
}
public struct LinearLayout: Group {
  public enum Orientation : jint{
    case HORIZONTAL
    case VERTICAL
  }
  static var type = "android/widget/LinearLayout"
  public var cls: jclass
  public let obj: Object
  var orientation: Orientation = .HORIZONTAL
  public init(@Builder children: () -> [View]) {
    self.init(orientation: .HORIZONTAL, children: children)
  }
  public init(orientation: Orientation, @Builder children: () -> [View]) {
    self.orientation = orientation
    cls = Context.env().find(type: Self.type)
    obj = Context.env().new(ctype: cls)
    let _ = with(orientation: self.orientation)
    for view in children() {
      if orientation == .VERTICAL {
        addView(child: view, w: -1)
      } else {
        addView(child: view)
      }
      if let lst = view as? Weight, lst.weight > 0 {
        let vc = Context.env().find(type: "android/view/View")
        let lpc = Context.env().find(type: "\(Self.type)$LayoutParams")
        var args = jvalue()
        if let lp = Context.env().call(view.obj, vc, name: "getLayoutParams", object: "()Landroid/view/ViewGroup$LayoutParams;", args: &args) {
          Context.env().valueFloat(lp, lpc, "weight", jvalue(f: lst.weight))
          Context.env().valueInt(lp, lpc, "height", jvalue(i: 0))
        }
      }
    }
  }
}
extension Group {
  public func addView(child: View, w: jint = -2, h: jint = -2) {
    if child is Switch {
      for c in (child as! Switch).objs {
        addView(child: c, w: w, h: h)
      }
    } else if let args = [jvalue(l: child.obj), jvalue(i: w), jvalue(i: h)].withUnsafeBufferPointer({ o in return o.baseAddress }) {
      Context.env().call(obj, cls, name: "addView", void: "(Landroid/view/View;II)V", args: args)
    }
  }
}
extension LinearLayout {
  public func with(orientation: Orientation) -> Self {
    var val = jvalue(i: orientation.rawValue)
    Context.env().call(obj, cls, name: "setOrientation", void: "(I)V", args: &val)
    return self
  }
}
extension Graviting {
  public func with(gravity: Gravity) -> Self {
    var val = jvalue(i: gravity.rawValue)
    Context.env().call(obj, cls, name: "setGravity", void: "(I)V", args: &val)
    return self
  }
}
public protocol Text {
  func setText(text: String)
}
public struct TextView: View, Text, Graviting {
  static var type: String = "android/widget/TextView"
  public var cls: jclass
  public let obj: Object
  public init(_ text: String, type: String) {
    cls = Context.env().find(type: type)
    obj = Context.env().new(ctype: cls)
    setText(text: text)
  }
  public init(_ text: String) {
    self.init(text, type: Self.type)
  }
  public func setText(text: String) {
    var s = Context.env().new(text: text)  // \(#function):\(#dsohandle), \(#file):\(#fileID) > \(#filePath)")
    Context.env().call(obj, cls, name: "setText", void: "(Ljava/lang/CharSequence;)V", args: &s)
  }
  public func setText(obj: Object, text: String, type: String) {
    let cls = Context.env().find(type: type)
    var s = Context.env().new(text: text)  // \(#function):\(#dsohandle), \(#file):\(#fileID) > \(#filePath)")
    Context.env().call(obj, cls, name: "setText", void: "(Ljava/lang/CharSequence;)V", args: &s)
  }
}
public struct Button: View, Text, Graviting, Clickable {
  public var obj: Object { t.obj }
  public var cls: Class { t.cls }
  public var click: funcClick?
  public var long: funcLong?
  static var type: String = "android/widget/Button"
  let t: TextView
  public init(_ text: String, click: funcClick? = nil, long: funcLong? = nil) {
    t = TextView(text, type: Self.type)
    self.click = click
    self.long = long

    if nil != click || nil != long {
      let event = Context.env().find(type: "com/test/ui/Swift$Event")
      var args = jvalue(l: Context.env().new(type: event))
      if nil != click { Context.env().call(obj, cls, name: "setOnClickListener", void: "(Landroid/view/View$OnClickListener;)V", args: &args) }
      if nil != long { Context.env().call(obj, cls, name: "setOnLongClickListener", void: "(Landroid/view/View$OnLongClickListener;)V", args: &args) }
      var id = jvalue(i: jint(Context.env().call(nil, Context.env().find(type: "android/view/View"), name: "generateViewId", int: "()I", args: &args)))
      Context.env().call(obj, cls, name: "setId", void: "(I)V", args: &id)
      Context.map(id.i, self)
    }
    logging(type: "Swift", message: "store: \(obj) : \(self)")
  }
  public func setText(text: String) {
    //logging(env: Context.env(), type: "Swift", message: "set Text \(text) for button")
    t.setText(text: text)
  }
  public func setText(obj: Object, text: String) {
    logging(type: "Swift", message: "set Text \(text) for button \(obj)")
    t.setText(obj: obj, text: text, type: Button.type)
  }
}
public struct EditText: View, Text, Graviting {
  static var type: String = "android/widget/EditText"
  public var cls: jclass
  public let obj: Object
  public init(_ text: String, type: String) {
    cls = Context.env().find(type: type)
    obj = Context.env().new(ctype: cls)
    setText(text: text)
  }
  public init(_ text: String) {
    self.init(text, type: Self.type)
  }
  public func setText(text: String) {
    var s = Context.env().new(text: text)  // \(#function):\(#dsohandle), \(#file):\(#fileID) > \(#filePath)")
    Context.env().call(obj, cls, name: "setText", void: "(Ljava/lang/CharSequence;)V", args: &s)
  }
}
extension Text {
  public func with(text: String) -> Self {
    setText(text: text)
    return self
  }
}
var data: Context = Context(env: nil, context: nil)

extension Context {
  static func env() -> _JNIEnv { data.env! }
  static func ctx() -> jobject { return data.context! }
  static func map(_ obj: jint) -> Button? { data.map[obj] }
  static func map(_ obj: jint, _ target: Button) {
    data.map[obj] = target
  }
  static public func find(_ object: Object) -> Button? {
    let id = Context.env().call(object, clsn: "android/view/View", name: "getId", int: "()I", args: nil)
    logging(type: "Swift", message: "line: \(#line)")
    /*if let fd = Context.map(id) {
      if let bt = fd as? Button {
        bt.setText(text: "found")
        //logging(env: Context.env(), type: "Swift", message: "find: type \(type(of: fd)) for \(id): \(object)")
      } else {
        logging(type: "Swift", message: "find: type \(type(of: fd)) for \(id): \(object)")
      }
    } else {
      logging(type: "Swift", message: "find: no click for \(id): \(object)")
    }*/
    return Context.map(id)
  }
  public static func debug() -> String {
    return Context.env().list(type: "android/widget/LinearLayout", name: "android.widget.LinearLayout")
  }
  public init(env: _JNIEnv, ctx: jobject) {
    self.env = env
    self.context = ctx
    self.map = [:]
    data = self
  }
  //prefix static func ! (view: Self) -> jobject? { view.obj }
}
