import Glibc

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
