# react-native-paytabs-sdk [![npm version](https://img.shields.io/npm/v/react-native-paytabs-sdk.svg?style=flat)](https://www.npmjs.com/package/react-native-paytabs-sdk)

```sh
npm i react-native-paytabs-sdk --save
```

## Steps to follow before use

### Android

1. In Android Studio, Right click on the app choose New > Module
2. Choose the Downloaded paytabs_sdk-v4.0.1.aar. If not, download [here](https://github.com/paytabscom/paytabs-android-library-sample/raw/master/sdk/paytabs_sdk-v4.0.1.aar)
3. Right click on your App and choose Open Module Settings
4. Add the Module dependency
5. Choose the: paytabs_sdk-v4.0.1 module to be included for both `app` and `react-native-paytabs-sdk` modules

![](https://github.com/Simicart/react-native-paytabs-sdk/blob/master/images/screenshot_1.png)

6. Add below dependencies.

```gradle
allprojects {
    repositories {
        ...
        maven { url 'https://jitpack.io' }
    }
}
```

```gradle
implementation 'com.android.support:design:28.0.0'
implementation 'com.android.support:appcompat-v7:28.0.0'
implementation 'com.squareup.retrofit2:retrofit:2.4.0'
implementation 'com.google.code.gson:gson:2.8.5'
implementation 'com.squareup.retrofit2:converter-gson:2.4.0'
implementation 'com.github.dbachelder:CreditCardEntry:1.4.9'
```

7. Open MainActivity.java and add the below code

```java
import com.rn.paytabs.PaytabsSdkModule;

@Override
  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (requestCode == PaymentParams.PAYMENT_REQUEST_CODE) {
      if(resultCode == RESULT_OK) {
        String responseCode = data.getStringExtra(PaymentParams.RESPONSE_CODE);
        String transactionID = data.getStringExtra(PaymentParams.TRANSACTION_ID);
        WritableMap productMap = new WritableNativeMap();
        productMap.putString("response_code", responseCode);
        productMap.putString("transaction_id", transactionID);
        if (data.hasExtra(PaymentParams.TOKEN) && !data.getStringExtra(PaymentParams.TOKEN).isEmpty()) {
          productMap.putString("token", respondata.getStringExtra(PaymentParams.TOKEN)seCode);
          productMap.putString("customer_email", data.getStringExtra(PaymentParams.CUSTOMER_EMAIL));
          productMap.putString("customer_password", data.getStringExtra(PaymentParams.CUSTOMER_PASSWORD));
        }
        PaytabsSdkModule.onResult.invoke(productMap);
      } else {
        PaytabsSdkModule.onResult.invoke(new WritableNativeMap());
      }
    }
  }
```

### iOS

1. Download library from [here](https://raw.githubusercontent.com/paytabscom/paytabs-ios-library-sample/master/sdk/ios_sdk-v4.0.6-lite.zip)
2. Extract the PayTabs iOS SDK.zip file which contains `paytabs-iOS.framework` and `Resources.bundle`.
3. Add `paytabs-iOS.framework` and `Resources.bundle` into your Pods Frameworks folder by dragging and with Copy items if needed checked. In Add to targets section, `react-native-paytabs-sdk` should be checked. Note: Please wipe out completely if you have any previous version already added in your codebase i.e. Delete it with "Move to trash" option and removing it from your Xcode project navigator.

![](https://github.com/Simicart/react-native-paytabs-sdk/blob/master/images/screenshot_2.png)

4. Copy path of paytabs_iOS.h file from paytabs-iOS.framework → Headers and add that path in Pods → Development Pods → react-native-paytabs-sdk → PaytabsSdk.m as shown in screenshot.

![](https://github.com/Simicart/react-native-paytabs-sdk/blob/master/images/screenshot_3.png)

5. Add those pods

```
pod 'BIObjCHelpers'
pod 'IQKeyboardManager'
pod 'AFNetworking'
pod 'Mantle'
pod 'Reachability'
pod 'Lockbox'
pod 'SBJson'
pod 'PINCache'
pod 'MBProgressHUD', '~> 1.1.0'
```

6. open iOS folder in terminal and run command "pod install" .
7. Disable the perfect forward secrecy (PFS) only for paytabs.com

```
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>paytabs.com</key>
        <dict>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSThirdPartyExceptionRequiresForwardSecrecy</key>
            <false/>
        </dict>
    </dict>
</dict>
```

## Usage

```javascript
import PaytabsSdk from 'react-native-paytabs-sdk';

onPay = () => {
  PaytabsSdk.openPaytab({
    merchant_email: 'your merchant email',
    secret_key: 'your paytabs secret key',
    language: 'en',
    transaction_title: 'Test Paytabs library',
    product_name: 'Product 1, Product 2',
    order_id: '123456',
    amount: 99.99,
    currency_code: 'BHD',
    phone_number: '009733',
    customer_email: 'customer-email@example.com',
    address_billing: 'Flat 1,Building 123, Road 2345',
    city_billing: 'Manama',
    state_billing: 'Manama',
    country_billing: 'BHR',
    postal_code_billing: '00973',
    address_shipping: 'Flat 1,Building 123, Road 2345',
    city_shipping: 'Manama',
    state_shipping: 'Manama',
    country_shipping: 'BHR',
    postal_code_shipping: '00973',
    pay_button_color: '#2474bc'
  }, (data) => {
    console.log(data);
  })
};
```

#### for more details, visit references [Payfort Mobile SDK](https://dev.paytabs.com/docs/android.html)
