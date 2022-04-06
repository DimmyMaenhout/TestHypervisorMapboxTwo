
private let logTag = "HypervisorCore"

//internal func log(_ level: LogLevel, _ message: String) {
//    HypervisorCoreController.logger?.log(level, logTag, message)
//}

public class HypervisorCoreController {
    
    public static var logger: HypervisorLogger? {
        get { logDelegate }
        set { logDelegate = newValue }
    }
}
