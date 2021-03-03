public func foreach<T, Rt>(_ ids: [T], d: (T) -> Rt) -> [Rt] {
  var r: [Rt] = []
  for i in ids {
    r.append(d(i))
  }
  return r
}
