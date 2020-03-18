package com.rn.paytabs;

import android.content.Intent;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.paytabs.paytabs_sdk.payment.ui.activities.PayTabActivity;
import com.paytabs.paytabs_sdk.utils.PaymentParams;
import java.util.Objects;

public class PaytabsSdkModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;
    public static Callback onResult;

    public PaytabsSdkModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "PaytabsSdk";
    }

    @ReactMethod
    void openPaytab(ReadableMap data, Callback onResult) {
        this.onResult = onResult;

        Intent in = new Intent(reactContext, PayTabActivity.class);
        in.putExtra(PaymentParams.MERCHANT_EMAIL, data.getString("merchant_email"));
        in.putExtra(PaymentParams.SECRET_KEY, data.getString("secret_key"));
        in.putExtra(PaymentParams.LANGUAGE, data.getString("language"));
        in.putExtra(PaymentParams.TRANSACTION_TITLE, data.getString("transaction_title"));
        in.putExtra(PaymentParams.AMOUNT, data.getDouble("amount"));

        in.putExtra(PaymentParams.CURRENCY_CODE, data.getString("currency_code"));
        in.putExtra(PaymentParams.CUSTOMER_PHONE_NUMBER, data.getString("phone_number"));
        in.putExtra(PaymentParams.CUSTOMER_EMAIL, data.getString("customer_email"));
        in.putExtra(PaymentParams.ORDER_ID, data.getString("order_id"));
        in.putExtra(PaymentParams.PRODUCT_NAME, data.getString("product_name"));

        //Billing Address
        in.putExtra(PaymentParams.ADDRESS_BILLING, data.getString("address_billing"));
        in.putExtra(PaymentParams.CITY_BILLING, data.getString("city_billing"));
        in.putExtra(PaymentParams.STATE_BILLING, data.getString("state_billing"));
        in.putExtra(PaymentParams.COUNTRY_BILLING, data.getString("country_billing"));
        in.putExtra(PaymentParams.POSTAL_CODE_BILLING, data.getString("postal_code_billing"));

        //Shipping Address
        in.putExtra(PaymentParams.ADDRESS_SHIPPING, data.getString("address_shipping"));
        in.putExtra(PaymentParams.CITY_SHIPPING, data.getString("city_shipping"));
        in.putExtra(PaymentParams.STATE_SHIPPING, data.getString("state_shipping"));
        in.putExtra(PaymentParams.COUNTRY_SHIPPING, data.getString("country_shipping"));
        in.putExtra(PaymentParams.POSTAL_CODE_SHIPPING, data.getString("postal_code_shipping"));

        //Payment Page Style
        in.putExtra(PaymentParams.PAY_BUTTON_COLOR, data.getString("pay_button_color"));

        //Tokenization
        in.putExtra(PaymentParams.IS_TOKENIZATION, true);
        Objects.requireNonNull(getCurrentActivity()).startActivityForResult(in, PaymentParams.PAYMENT_REQUEST_CODE);;
    }
}

