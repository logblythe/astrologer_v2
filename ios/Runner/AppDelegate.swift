import UIKit
import Flutter
import Khalti
//import EsewaSDK

@UIApplicationMain
//EsewaSDKPaymentDelegate
@objc class AppDelegate: FlutterAppDelegate,KhaltiPayDelegate {
    
    //Instanace of esewa sdk
//    var sdk: EsewaSDK?
    
    var result: FlutterResult?
    
    //Khalti Url Scheme
    let khaltiUrlScheme:String = "CosmosKhaltiScheme"
    
  override func application(
    _ application: UIApplication,didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
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
    
    //Khalti Platform Method Connector
    let khaltiChannel = FlutterMethodChannel(name: "cosmos-khalti",binaryMessenger: controller.binaryMessenger)
    khaltiChannel.setMethodCallHandler({
          [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        guard call.method == "initiate_khalti_gateway" else {
            result(FlutterMethodNotImplemented)
            return
          }
        self?.initKhaltiPayment(view: controller, res: result, data:call.arguments as! Dictionary<String, String>)
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application,didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func initESewaPayment(view:FlutterViewController ,res: @escaping FlutterResult,arguments:Array<Dictionary<String,String>>) {
        result = res;
//        let envLive:String = "ENVIRONMENT_LIVE";
    
        //Parsing Argument data from method channel
//        let config:Dictionary<String,String> = arguments[0];
//        let productData:Dictionary<String,String> = arguments[1];
        
        //Esewa Configuration Data
//        sdk = EsewaSDK(inViewController: view, environment: config["environment"]==envLive ?.production:.development, delegate: self)
        
//        sdk?.initiatePayment(merchantId: config["clientId"]!, merchantSecret: config["secretKey"]!, productName: productData["productName"]!, productAmount: productData["productPrice"]!, productId: productData["productId"]!, callbackUrl: productData["callBackUrl"]!)
    }

    
    func onEsewaSDKPaymentSuccess(info:[String:Any]) {
        var value = Dictionary<String, Any>()
        value["isSuccess"] = true
        value["message"] = info
        result?(value)
        result=nil
    }

    func onEsewaSDKPaymentError(errorDescription: String) {
        var value = Dictionary<String, Any>()
        value["isSuccess"] = false
        value["message"] = errorDescription
        result?(value)
        result=nil
    }
    
//    Khalti Integration
    override func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        Khalti.shared.action(with: url)
        return Khalti.shared.defaultAction() // Or true
    }
    
    private func initKhaltiPayment(view:FlutterViewController ,res: @escaping FlutterResult,data:Dictionary<String,String>) {
        result = res;
//        Additional Parameter
//        https://github.com/khalti/khalti-sdk-ios/blob/master/Example/Khalti/ViewController.swift
//        additionalData: additionalData
        let khalti_config:Config = Config(publicKey:data["publicKey"]!, amount: Int(data["amount"]!)!, productId: data["productId"]!, productName: data["productName"]!, productUrl: data["productUrl"], ebankingPayment: data["eBankingPayment"]=="true" ? true : false)
        Khalti.shared.appUrlScheme = khaltiUrlScheme
        Khalti.present(caller: view, with: khalti_config, delegate: self)
    }
    
    func onCheckOutSuccess(data: Dictionary<String, Any>) {
        print(data)
        var value = Dictionary<String, Any>()
        value["isSuccess"] = true
        value["message"] = data
        result?(value)
        result=nil
    }
    
    func onCheckOutError(action: String, message: String, data: Dictionary<String, Any>?) {
        print(message)
        var value = Dictionary<String, Any>()
        value["isSuccess"] = false
        value["message"] = message
        value["action"] = action
        value["data"] = data
        result?(value)
        result=nil
    }
}
