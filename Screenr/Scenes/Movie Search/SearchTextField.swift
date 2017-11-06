
import Foundation
import UIKit

public class SearchTextField: UITextField {
    
    fileprivate var throttler: Throttler? = nil
    public var throttlingInterval: Double? = 0 {
        didSet {
            guard let interval = throttlingInterval else {
                self.throttler = nil
                return
            }
            self.throttler = Throttler(seconds: Int(interval))
        }
    }
    
    public var onCancel: (() -> (Void))? = nil
    public var onSearch: ((String) -> (Void))? = nil
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    required override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    private func commonInit() {
        self.delegate = self
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
}

extension SearchTextField: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.onSearch?(self.text ?? "")
        return true
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        guard let throttler = self.throttler else {
            self.onSearch?(textField.text ?? "")
            return
        }
        throttler.throttle {
            DispatchQueue.main.async {
                self.onSearch?(textField.text ?? "")
            }
        }
    }
    
}
