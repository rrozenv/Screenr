
import Foundation

struct Resource<A> {
    let target: ServerAPI
    let parse: (Data) -> A?
}

extension Resource {
    init(target: ServerAPI, parseJSON: @escaping (Any) -> A?) {
        self.target = target
        self.parse = { data -> A? in
            let json = try? JSONSerialization.jsonObject(with: data, options: [])
            return json.flatMap(parseJSON)
        }
    }
}
