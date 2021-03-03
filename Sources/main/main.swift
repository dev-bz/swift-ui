import Glibc
import common

public struct Temp: CustomStringConvertible {
  var children: [Temp]
  let text: String
  init(_ text: String) {
    self.text = text
    self.children = []
  }
  init(a: () -> [Temp]) {
    self.children = a()
    self.text = self.children.isEmpty ? "empty" : "Array"
  }
  public var description: String {
    return children.isEmpty ? text : make(children)
  }
  func make(_ arr: [CustomStringConvertible]) -> String {
    var out: String = "[\n"
    for i in arr {
      out.append(i.description)
      out.append("\n")
    }
    out.append("]\n")
    return out
  }
}
@_functionBuilder public struct TestBuilder {
  public static func buildBlock(_ content: Temp...) -> Temp {
    return Temp { content }
  }
  static func buildIf(_ part: Temp?) -> Temp {
    return part ?? Temp { [] }
  }
  static func buildEither(first: Temp) -> Temp {
    return first
  }
  static func buildEither(second: Temp) -> Temp {
    return second
  }
  static func buildDo(_ first: Temp) -> Temp {
    return first
  }
}

@propertyWrapper struct State<Tp> {
  var value: Tp
  var wrappedValue: Tp {
    get { value }
    set {
      value = newValue
      print("must update UI")
    }
  }
  init(wrappedValue initialValue: Tp) { self.value = initialValue }
}

struct Test {
  var data: Temp
  init(@TestBuilder s: () -> Temp) {
    data = s()
  }
  var description: String {
    return data.description
  }
}

struct Build: CustomStringConvertible {
  @State public var status: Bool
  let tmp: String = "Hello"
  let ids = Array(0...5)
  //let w:Wrapped
  public var body: Test {
    Test {
      Temp("c")
      if status { Temp("#function") } else { Temp("#file") }
      if status {
        Temp("first")
        Temp(tmp)
        Temp("lost")
      }
      Temp {
        foreach(ids) { id in
          return Temp("\(id) build")
        }
      }
      do {
        Temp("one")
        Temp("two")
      }
      Temp("a")
      Temp("b")
    }
  }
  var description: String {
    return body.description
  }
}
print("list", Build(status: true))
print("list", Build(status: false))
var a = 20
var b = 10
do {
  if b == a { a = 0 }
}  //while a > b
print("\(a), \(b)")
let args: [Int] = [9, 5, 2, 7]
let u = args.withUnsafeBytes({ o in return o.bindMemory(to: Int.self).baseAddress })
if var t = u {
  for _ in 0..<args.count {
    print(t.pointee, " at ", u!.distance(to: t))
    t += 1
  }
}
print("array:", args, "capacity:", args.capacity)
print("pointer:", u ?? "Not pointer")
