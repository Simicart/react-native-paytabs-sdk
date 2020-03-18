#import "PaytabsSdk.h"
#import <paytabs-iOS/paytabs_iOS.h>

@implementation PaytabsSdk

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(openPaytab:(NSDictionary *)indic createDialog:(RCTResponseSenderBlock)doneCallback) {
  NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"Resources" withExtension:@"bundle"]];
  
  UIViewController *rootViewController;

  rootViewController = (UIViewController*)[UIApplication sharedApplication].delegate.window.rootViewController;

  NSDictionary *data = [[NSDictionary alloc] initWithDictionary:indic];
  
  NSArray *events = @[];

  PTFWInitialSetupViewController *view = [[PTFWInitialSetupViewController alloc]
                                          initWithBundle:bundle
                                          andWithViewFrame:rootViewController.view.frame
                                          andWithAmount:[data[@"amount"] doubleValue]
                                          andWithCustomerTitle:data[@"transaction_title"]
                                          andWithCurrencyCode:data[@"currency_code"]
                                          andWithTaxAmount:0
                                          andWithSDKLanguage:data[@"language"]
                                          andWithShippingAddress:data[@"address_shipping"]
                                          andWithShippingCity:data[@"city_shipping"]
                                          andWithShippingCountry:data[@"country_shipping"]
                                          andWithShippingState:data[@"state_shipping"]
                                          andWithShippingZIPCode:data[@"postal_code_shipping"]
                                          andWithBillingAddress:data[@"address_billing"]
                                          andWithBillingCity:data[@"city_billing"]
                                          andWithBillingCountry:data[@"country_billing"]
                                          andWithBillingState:data[@"state_billing"]
                                          andWithBillingZIPCode:data[@"postal_code_billing"]
                                          andWithOrderID:data[@"order_id"]
                                          andWithPhoneNumber:data[@"phone_number"]
                                          andWithCustomerEmail:data[@"customer_email"]
                                          andIsTokenization:NO
                                          andIsPreAuth:NO
                                          andWithMerchantEmail:data[@"merchant_email"]
                                          andWithMerchantSecretKey:data[@"secret_key"]
                                          andWithAssigneeCode:@"SDK"
                                          andWithThemeColor:[self colorFromHexString:data[@"pay_button_color"]]
                                          andIsThemeColorLight:YES];

  view.didReceiveBackButtonCallback = ^{
      [rootViewController dismissViewControllerAnimated:YES completion:nil];
      NSDictionary *responseDict = @{};
      doneCallback(@[responseDict, events]);
  };

  view.didStartPreparePaymentPage = ^{
      // Start Prepare Payment Page
      // Show loading indicator
  };

  view.didFinishPreparePaymentPage = ^{
      // Finish Prepare Payment Page
      // Stop loading indicator
  };

    view.didReceiveFinishTransactionCallback = ^(int responseCode, NSString * _Nonnull result, int transactionID, NSString * _Nonnull tokenizedCustomerEmail, NSString * _Nonnull tokenizedCustomerPassword, NSString * _Nonnull token, BOOL transactionState) {
        NSLog(@"Response Code: %i", responseCode);
        NSLog(@"Response Result: %@", result);
        
        // In Case you are using tokenization
        NSLog(@"Tokenization Cutomer Email: %@", tokenizedCustomerEmail);
        NSLog(@"Tokenization Customer Password: %@", tokenizedCustomerPassword);
        NSLog(@"TOkenization Token: %@", token);
        
        NSDictionary *responseDict = @{ @"reponse_code" : [@(responseCode) stringValue], @"transaction_id" : [@(transactionID) stringValue]};
        if(token != nil) {
            [responseDict setValue:token forKey:@"token"];
        }
        if(tokenizedCustomerEmail != nil) {
            [responseDict setValue:tokenizedCustomerEmail forKey:@"token_customer_email"];
        }
        if(tokenizedCustomerPassword != nil) {
            [responseDict setValue:tokenizedCustomerPassword forKey:@"token_customer_password"];
        }
        
        doneCallback(@[responseDict, events]);
        [rootViewController dismissViewControllerAnimated:YES completion:nil];
  };

  dispatch_sync(dispatch_get_main_queue(), ^{
    [rootViewController presentViewController:view animated:true completion:nil];
  });
}

- (UIColor* )colorFromHexString:(NSString* )hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
