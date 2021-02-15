import UIKit
import Flutter
import EsewaSDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, EsewaSDKPaymentDelegate {
    //Instanace of esewa sdk
    var sdk: EsewaSDK?
    
    var result: FlutterResult?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    // Platform Channel Connector
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let eSewaChannel = FlutterMethodChannel(name: "cosmos-eSewa",binaryMessenger: controller.binaryMessenger)
    eSewaChannel.setMethodCallHandler({
          [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        guard call.method == "initiate_eSewa_gateway" else {
            result(FlutterMethodNotImplemented)
            return
          }
        self?.initESewaPayment(view: controller, res: result, arguments:call.arguments as! Array<Dictionary<String, String>>)
        })
    
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func initESewaPayment(view:FlutterViewController ,res: @escaping FlutterResult,arguments:Array<Dictionary<String,String>>) {
        result = res;
        let envLive:String = "ENVIRONMENT_LIVE";
    
        //Parsing Argument data from method channel
        let config:Dictionary<String,String> = arguments[0];
        let productData:Dictionary<String,String> = arguments[1];
        
        //Esewa Configuration Data
        sdk = EsewaSDK(inViewController: view, environment: config["environment"]==envLive ?.production:.development, delegate: self)
        
        sdk?.initiatePayment(merchantId: productData["clientId"]!, merchantSecret: productData["secretKey"]!, productName: productData["productName"]!, productAmount: productData["productPrice"]!, productId: productData["productId"]!, callbackUrl: productData["callBackUrl"]!)
    }
    
    func onEsewaSDKPaymentSuccess(info:[String:Any]) {
        var value = Dictionary<String, Any>()
        value["isSuccess"] = true
        value["message"] = info
        result?(value)
        result = nil
    }

    func onEsewaSDKPaymentError(errorDescription: String) {
        var value = Dictionary<String, Any>()
        value["isSuccess"] = false
        value["message"] = errorDescription
        result?(value)
        result = nil
    }
}
