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
