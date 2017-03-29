package io.rnkit.codepush;

/**
 * Created by SimMan on 2017/3/21.
 */

import android.bluetooth.BluetoothAdapter;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import android.provider.Settings.Secure;

import android.telephony.TelephonyManager;
import android.util.Base64;
import android.util.Log;

import com.google.android.gms.iid.InstanceID;

import com.facebook.react.bridge.ReactApplicationContext;

import org.json.JSONObject;

import java.net.NetworkInterface;
import java.util.Enumeration;
import java.lang.Exception;
import java.util.HashMap;
import java.util.Locale;
import java.util.TimeZone;

public class DeviceInfo {

    ReactApplicationContext reactContext;

    public DeviceInfo(ReactApplicationContext reactContext) {

        this.reactContext = reactContext;
    }

    private String getCurrentLanguage() {

        Locale current = this.reactContext.getResources().getConfiguration().locale;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            return current.toLanguageTag();
        } else {
            StringBuilder builder = new StringBuilder();
            builder.append(current.getLanguage());
            if (current.getCountry() != null) {
                builder.append("-");
                builder.append(current.getCountry());
            }
            return builder.toString();
        }
    }

    private String getCurrentCountry() {
        Locale current = this.reactContext.getResources().getConfiguration().locale;
        return current.getCountry();
    }

    private String getLocalMacAddress() {
        String mac = "";
        try {
            Enumeration<NetworkInterface> interfaces = NetworkInterface.getNetworkInterfaces();
            while (interfaces.hasMoreElements()) {
                NetworkInterface iF = interfaces.nextElement();
                byte[] addr = iF.getHardwareAddress();
                if (addr == null || addr.length == 0) {
                    continue;
                }
                StringBuilder buf = new StringBuilder();
                for (byte b : addr) {
                    buf.append(String.format("%02X:", b));
                }
                if (buf.length() > 0) {
                    buf.deleteCharAt(buf.length() - 1);
                }
                mac = buf.toString();
                Log.d("mac", "interfaceName=" + iF.getName() + ", mac=" + mac);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return mac;
    }

    public String getDeviceInfo() {
        HashMap<String, Object> constants = new HashMap<String, Object>();

        PackageManager packageManager = this.reactContext.getPackageManager();
        String packageName = this.reactContext.getPackageName();

        constants.put("appVersion", "not available");
        constants.put("buildVersion", "not available");
        constants.put("buildNumber", 0);

        try {
            PackageInfo info = packageManager.getPackageInfo(packageName, 0);
            constants.put("appVersion", info.versionName);
            constants.put("buildNumber", info.versionCode);
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        String deviceName = "Unknown";

        try {
            BluetoothAdapter myDevice = BluetoothAdapter.getDefaultAdapter();
            deviceName = myDevice.getName();
        } catch (Exception e) {
            e.printStackTrace();
        }

        String IMEI = "";
        try {
            TelephonyManager tm = (TelephonyManager) this.reactContext.getSystemService(this.reactContext.TELEPHONY_SERVICE);
            IMEI = tm.getDeviceId();
        } catch (Exception e) {
            e.printStackTrace();
        }

        constants.put("instanceId", InstanceID.getInstance(this.reactContext).getId());
        constants.put("deviceName", deviceName);
        constants.put("systemName", "Android");
        constants.put("systemVersion", Build.VERSION.RELEASE);
        constants.put("model", Build.MODEL);
        constants.put("brand", Build.BRAND);
        constants.put("deviceId", Build.BOARD);
        constants.put("deviceLocale", this.getCurrentLanguage());
        constants.put("deviceCountry", this.getCurrentCountry());
        constants.put("uniqueId", Secure.getString(this.reactContext.getContentResolver(), Secure.ANDROID_ID));
        constants.put("systemManufacturer", Build.MANUFACTURER);
        constants.put("bundleId", packageName);
        constants.put("userAgent", System.getProperty("http.agent"));
        constants.put("timezone", TimeZone.getDefault().getID());
        constants.put("macAddress", this.getLocalMacAddress());
        constants.put("imei", IMEI);

        String jsonString;
        try {
            JSONObject json = new JSONObject(constants);
            jsonString = json.toString();
        } catch (Exception e) {
            jsonString = "{}";
        }
        byte [] encode = Base64.encode(jsonString.toString().getBytes(), Base64.DEFAULT);

        return (new String(encode)).replaceAll("\r|\n", "");
    }

}