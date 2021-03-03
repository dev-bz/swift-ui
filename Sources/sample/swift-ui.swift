import ui

struct ContextView: View {
  var obj: Object? { body.obj }
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
      ScrollView {
        TextView(Self.debug())
      }.with(fillViewport: true)
    }  //.with(orientation: .VERTICAL)
  }
}
struct TContextView:View {
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
          TextView("Do block")
          TextView("Do block test")
        }
        if on {
          TextView("Test IF block").with(gravity: Gravity.CENTER_HORIZONTAL)
          TextView("If on is True").with(gravity: Gravity.CENTER_HORIZONTAL)
        }
        List(data) { id in
          "\(id) is String"
        }.with(weight: 0.75)
        if on {
          TextView("on = TRUE")
          TextView("on is TRUE")
        } else {
          TextView("on = False")
          TextView("on is False")
        }
        ScrollView {
          TextView(Self.debug())
        }.with(fillViewport: true)
      }  //.with(orientation: .VERTICAL)
    }
  }