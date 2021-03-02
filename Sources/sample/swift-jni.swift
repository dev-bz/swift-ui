import ui

@_cdecl("Java_com_test_ui_Swift_view") public func Java_com_test_ui_Swift_view(env_: _JNIEnv, cls: Class, ctx: Object) -> Object? {
  let _ = Context(env: env_, ctx: ctx)
  return ContextView().obj
}
