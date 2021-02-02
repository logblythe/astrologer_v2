package com.cosmosNepal.cosmos

import android.app.Activity
import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.esewa.android.sdk.payment.ESewaConfiguration
import com.esewa.android.sdk.payment.ESewaPayment
import com.esewa.android.sdk.payment.ESewaPaymentActivity
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.Serializable
import java.util.*

class MainActivity : FlutterActivity() {
    private val eSewaChannel = "cosmos-eSewa";
    private val REQUEST_CODE_PAYMENT: Int = 100;
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, eSewaChannel).setMethodCallHandler { call, result ->
            if (call.method == "initiate_eSewa_gateway") {
                pendingResult = result;
                val arg: List<HashMap<String, String>>? = call.arguments();
                val config: ESewaConfiguration = initESewa(arg!![0]);
                val productData: HashMap<String, String> = arg[1];
                println(arg[0]);
                println(arg[1])
                val eSewaPayment: ESewaPayment = ESewaPayment(productData["productPrice"],
                        productData["productName"], productData["productId"], productData["callBackUrl"]);

                val intent: Intent = Intent(this, ESewaPaymentActivity::class.java)
                intent.putExtra(ESewaConfiguration.ESEWA_CONFIGURATION, config)

                intent.putExtra(ESewaPayment.ESEWA_PAYMENT, eSewaPayment)
                startActivityForResult(intent, REQUEST_CODE_PAYMENT)
            } else {
                result.notImplemented();
            }
        }
    }

    private fun initESewa(data: HashMap<String, String>): ESewaConfiguration {
        val live = "ENVIRONMENT_LIVE";
        return ESewaConfiguration()
                .clientId(data["clientId"])
                .secretKey(data["secretKey"])
                .environment(if (data["environment"] == live) ESewaConfiguration.ENVIRONMENT_PRODUCTION else ESewaConfiguration.ENVIRONMENT_TEST)
    }

    private fun successResult(success: Boolean, message: String) {
        if (pendingResult != null) {
            val result = HashMap<String, Serializable>()
            result["isSuccess"] = success
            result["message"] = message
            pendingResult!!.success(result)
            clearMethodCallAndResult()
        }
    }

    private fun clearMethodCallAndResult() {
        pendingResult = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_PAYMENT) {
            if (resultCode == Activity.RESULT_OK) {
                val s = data!!.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
                Log.i("Proof of Payment", s!!)
                successResult(true, s);
//                Toast.makeText(this, "SUCCESSFUL PAYMENT", Toast.LENGTH_SHORT).show()
            } else if (resultCode == Activity.RESULT_CANCELED) {
                Toast.makeText(this, "Canceled By User", Toast.LENGTH_SHORT).show()
                successResult(false, "Payment process canceled by user");
            } else if (resultCode == ESewaPayment.RESULT_EXTRAS_INVALID) {
                val s = data!!.getStringExtra(ESewaPayment.EXTRA_RESULT_MESSAGE)
                Log.i("Proof of Payment", s!!)
                successResult(false, s);
            }
        }
    }
}
