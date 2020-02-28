package com.babisoft.ReactNativeLocalization;

import android.content.Context;
import android.content.SharedPreferences;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

/**
 * Created by stefano on 20/09/15.
 */
public class ReactNativeLocalization extends ReactContextBaseJavaModule {

    /**
     * Name of the exported variable
     */
    private static final String LANGUAGE = "language";
    private static final String REGION = "region";
    private static final String LOCALE_OVERRIDE = "locale_override";
    private static final String REGION_OVERRIDE = "region_override";

    public ReactNativeLocalization(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "ReactLocalization";
    }

    /**
     * Return the current language
     *
     * @return
     */
    private String getCurrentLanguage() {

        // user locale takes precedence
        String userLocale = this.getUserLocale();
        if (userLocale != null) {
            return userLocale;
        }

        Locale current = getReactApplicationContext().getResources().getConfiguration().locale;
        return current.getLanguage() + "-" + current.getCountry();
    }

    private String getCurrentRegion() {

        // user region takes precedence
        String userRegion = this.getUserRegion();
        if (userRegion != null) {
            return userRegion;
        }

        Locale current = getReactApplicationContext().getResources().getConfiguration().locale;
        return current.getCountry();
    }

    public String getUserRegion() {
        return getPreferences().getString(REGION_OVERRIDE, null);
    }

    public String getUserLocale() {
        return getPreferences().getString(LOCALE_OVERRIDE, null);
    }

    /**
     * Export to Javascript the variable language containing the current language
     *
     * @return
     */
    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(LANGUAGE, getCurrentLanguage());
        constants.put(REGION, getCurrentRegion());
        return constants;
    }

    /*
     * Export a method callable from javascript that a Promise which resolves in
     * case of successfully setting the language constant
     */
    @ReactMethod
    public void setAppLanguage(String languageCode, final Promise promise) {
        SharedPreferences.Editor editor = getEditor();

        editor.putString(LOCALE_OVERRIDE, languageCode);
        editor.commit();

        System.out.println("Successfully committed locale_override preference of: " + languageCode);

        promise.resolve(languageCode);
    }

    @ReactMethod
    public void setAppRegion(String regionCode, final Promise promise) {
        SharedPreferences.Editor editor = getEditor();

        editor.putString(REGION_OVERRIDE, regionCode);
        editor.commit();

        System.out.println("Successfully committed region_override preference of: " + regionCode);

        promise.resolve(regionCode);
    }

    /**
     * Export a method callable from javascript that returns the current language
     *
     * @param callback
     */
    @ReactMethod
    public void getLanguage(Callback callback) {
        String language = getCurrentLanguage();
        System.out.println("The current language is " + language);
        callback.invoke(null, language);
    }

    @ReactMethod
    public void getRegion(final Promise promise) {
        String region = getCurrentRegion();
        System.out.println("The current region is " + region);
        promise.resolve(region);
    }

    /**
     * SharedPreferences
     */
    private SharedPreferences getPreferences() {
        return getReactApplicationContext().getSharedPreferences("react-native", Context.MODE_PRIVATE);
    }

    private SharedPreferences.Editor getEditor() {
        return getPreferences().edit();
    }
}
