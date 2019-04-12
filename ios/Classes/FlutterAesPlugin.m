#import "FlutterAesPlugin.h"
#import <CommonCrypto/CommonCryptor.h>


@implementation FlutterAesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_aes"
            binaryMessenger:[registrar messenger]];
  FlutterAesPlugin* instance = [[FlutterAesPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSData *key =call.arguments[@"key"];
    NSData *data =call.arguments[@"data"];
    NSData *iv =call.arguments[@"iv"];
  if ([@"decrypt" isEqualToString:call.method]) {
    result([cipherOperation(data, key,iv, kCCDecrypt));
  } else if ([@"encrypt" isEqualToString:call.method]) {
    result([cipherOperation(data, key,iv, kCCEncrypt)]);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

NSData * cipherOperation(NSData *contentData, NSData *keyData,NSData *ivData, CCOperation operation) {
    NSUInteger dataLength = contentData.length;

    void const *initVectorBytes = ivData;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;

    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    if (operationBytes == NULL) {
        return nil;
    }
    size_t actualOutSize = 0;

    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyBytes,
                                          kCCKeySizeAES256,
                                          initVectorBytes,
                                          contentBytes,
                                          dataLength,
                                          operationBytes,
                                          operationSize,
                                          &actualOutSize);

    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:operationBytes length:actualOutSize];
    }
    free(operationBytes);
    operationBytes = NULL;
    return nil;
}

@end
