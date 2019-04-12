package com.jlcool.flutter_aes;

import android.util.Base64;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterAesPlugin
 */
public class FlutterAesPlugin implements MethodCallHandler {
    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_aes");
        channel.setMethodCallHandler(new FlutterAesPlugin());
    }
    @Override
    public void onMethodCall(MethodCall call, Result result) {
        final byte[]  _key = call.argument("key");
        final byte[] _data = call.argument("data");
        final byte[] _iv = call.argument("iv");
        try {
            if (call.method.equals("decrypt")) {
                result.success(cipherOperation(_data, _key, Cipher.DECRYPT_MODE, _iv));
            }   else if (call.method.equals("encrypt")) {
                result.success(cipherOperation(_data, _key, Cipher.ENCRYPT_MODE, _iv));
            } else {
                result.notImplemented();
            }
        } catch (Exception ex) {
            result.success(null);
        }
    }

    public static byte[] cipherOperation(byte[] contentBytes, byte[] keyBytes, int mode,byte[] iv) throws UnsupportedEncodingException, NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException {
        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, "AES");

        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(mode, secretKey, ivParameterSpec);
        return cipher.doFinal(contentBytes);
    }
}
