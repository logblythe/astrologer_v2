package com.cosmosNepal.cosmos

import android.app.Activity
import android.app.AlertDialog
import android.app.DatePickerDialog
import android.content.Intent
import android.util.Log
import android.widget.Toast
import androidx.annotation.NonNull
import com.esewa.android.sdk.payment.ESewaConfiguration
import com.esewa.android.sdk.payment.ESewaPayment
import com.esewa.android.sdk.payment.ESewaPaymentActivity
import com.khalti.checkout.helper.Config
import com.khalti.checkout.helper.KhaltiCheckOut
import com.khalti.checkout.helper.OnCheckOutListener
import com.khalti.checkout.helper.PaymentPreference
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.Serializable
import java.util.*


class MainActivity : FlutterActivity() {
    private val eSewaChannel = "cosmos-eSewa";
    private val khaltiChannel = "cosmos-khalti";
    private val datePickerChannel = "cosmos-date-picker";
    private val REQUEST_CODE_PAYMENT: Int = 100;
    private var pendingResult: MethodChannel.Result? = null
    private var datePickerDialog: DatePickerDialog? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        //For Native eSewa Integration
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, eSewaChannel).setMethodCallHandler { call, result ->
            if (call.method == "initiate_eSewa_gateway") {
                pendingResult = result;
                val arg: List<HashMap<String, String>>? = call.arguments();
                val config: ESewaConfiguration = initESewa(arg!![0]);
                val productData: HashMap<String, String> = arg[1];
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

        // For Native date picker integration.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, datePickerChannel).setMethodCallHandler { call, result ->
            if (call.method == "init_date_piker_model") {
                pendingResult = result;
                initDatePicker()
            } else {
                result.notImplemented();
            }
        }

        //For Native Khalti Integration
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, khaltiChannel).setMethodCallHandler { call, result ->
            if (call.method == "initiate_khalti_gateway") {
                pendingResult = result;
                val arg: HashMap<String, String> = call.arguments()!!
                initKhalti(arg)
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

    private fun initKhalti(data: HashMap<String, String>) {
        val map: MutableMap<String, Any> = HashMap()
        map["merchant_extra"] = "This is extra data"

        val builder: Config.Builder = Config.Builder(data["publicKey"]!!, data["productId"]!!, data["productName"]!!, data["amount"]!!.toLong(), object : OnCheckOutListener {
            override fun onError(@NonNull action: String, @NonNull errorMap: Map<String, String>) {
                Log.i(action, errorMap.toString())
                paymentResultKhalti(false, errorMap);
            }

            override fun onSuccess(@NonNull data: Map<String, Any>) {
                Log.i("success", data.toString())
                paymentResultKhalti(true, data)
            }
        })
                .paymentPreferences(object : ArrayList<PaymentPreference?>() {
                    init {
                        add(PaymentPreference.KHALTI)
//                        add(PaymentPreference.EBANKING)
//                        add(PaymentPreference.MOBILE_BANKING)
//                        add(PaymentPreference.CONNECT_IPS)
//                        add(PaymentPreference.SCT)
                    }
                })
//                .additionalData(map)
                .productUrl("")
        val config = builder.build()
        val khaltiCheckOut = KhaltiCheckOut(this, config)
        khaltiCheckOut.show();
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
    private fun paymentResultKhalti(success: Boolean, message: Any) {
        if (pendingResult != null) {
            val result = HashMap<String, Any>()
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

    private fun initDatePicker() {
        val dateSetListener = DatePickerDialog.OnDateSetListener { datePicker, year, month, day ->
            var m = month + 1
            val date = makeDateString(day, m, year)
            pendingResult!!.success(date)
            clearMethodCallAndResult()
        }
        val cal = Calendar.getInstance()
        val year = cal[Calendar.YEAR]
        val month = cal[Calendar.MONTH]
        val day = cal[Calendar.DAY_OF_MONTH]
        val style: Int = AlertDialog.THEME_HOLO_DARK
        datePickerDialog = DatePickerDialog(this, style, dateSetListener, year, month, day)
        datePickerDialog!!.datePicker.maxDate = System.currentTimeMillis();
        datePickerDialog!!.show()
    }

    private fun makeDateString(day: Int, month: Int, year: Int): String {
        return "$year-" + "%02d".format(month) + "-" + "%02d".format(day)
    }


}
