package com.paulmojicatech;

import android.util.Log;

public class ApplePay {

    public String echo(String value) {
        Log.i("Echo", value);
        return value;
    }

    public Boolean canMakePayments() {
        Log.i("canMakePayments", "false");
        return false;
    }
}
