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
    FlutterStandardTypedData  *key =call.arguments[@"key"];
    FlutterStandardTypedData  *data =call.arguments[@"data"];
    FlutterStandardTypedData  *iv =call.arguments[@"iv"];
    if ([@"decrypt" isEqualToString:call.method]) {
        result([FlutterStandardTypedData typedDataWithBytes:[self operation:data.data keyData: key.data iv:iv.data op:kCCDecrypt]]);
    } else if ([@"encrypt" isEqualToString:call.method]) {
        result([FlutterStandardTypedData typedDataWithBytes:[self operation:data.data keyData: key.data iv:iv.data op:kCCEncrypt]] );
    } else {
        result(FlutterMethodNotImplemented);
    }
}
- (NSData *)operation:(NSData*)contentData keyData:(NSData*)keyData iv:(NSData*)iv op:(CCOperation)op {
    NSUInteger dataLength = [contentData length];
    
    void const *initVectorBytes =  iv.bytes;
    void const *contentBytes = contentData.bytes;
    void const *keyBytes = keyData.bytes;
    
    size_t operationSize = dataLength + kCCBlockSizeAES128;
    void *operationBytes = malloc(operationSize);
    if (operationBytes == NULL) {
        return nil;
    }
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(op,
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
