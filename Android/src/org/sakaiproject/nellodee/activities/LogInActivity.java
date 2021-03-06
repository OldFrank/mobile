package org.sakaiproject.nellodee.activities;


import org.apache.http.client.CookieStore;
import org.sakaiproject.nellodee.NellodeeApplication;
import org.sakaiproject.nellodee.auth.Authorization;

import com.immutable.nellodee.R;
import com.immutable.nellodee.R.layout;


import android.app.Activity;
import android.app.AlertDialog;
import android.app.Application;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;

public class LogInActivity extends Activity {

	private AlertDialog alertDialog;
	private Button loginButton;
	//private CheckBox rememberButton;
	private NellodeeApplication app;



	/** Called when the activity is first created. */
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        app = ((NellodeeApplication)getApplication());
        
        setContentView(R.layout.authorization);
        Log.v("LOG IN:","set login activity");
    }
    
    protected void onResume() {
		super.onResume();
        loginButton = (Button) findViewById(R.id.login_button);
        loginButton.setOnClickListener(onLogin);

	}
 
    
    private View.OnClickListener onLogin = new View.OnClickListener() {
		public void onClick(View v) {
			EditText username_EditText = (EditText) findViewById(R.id.username);
			EditText password_EditText = (EditText) findViewById(R.id.password);
			String username = username_EditText.getText().toString();
			String password = password_EditText.getText().toString();
			Log.v("CREDENTIALS: ", "Clicked the sign in button. This is the username: "+ username+ " and pass:" + password);

			if(username_EditText == null || password_EditText == null){
				notLogin(0);
            }else{
            	String url = app.getURL(app.getApplicationContext());
    			Log.v("CREDENTIALS: ", "URL: "+ url); 
            	Authorization auth = new Authorization(url,username,password);
            	try {
        			CookieStore store = auth.formBasedAuth();
            		if(store!=null){
            			Log.w("CREDENTIALS: ", "Authentication worked");
            			saveCookies(store);
            			loadBasicProfile();
            		}
            		else{
            			Log.w("CREDENTIALS: ", "Authentication has failed");
            			notLogin(1);

            		}
            	} catch (Exception e) {
            		e.printStackTrace();
            	}
			}
		}
	};
	
	public void  notLogin(int error){
		alertDialog = new AlertDialog.Builder(this).create();
		alertDialog.setTitle("Not login");
		if(error == 0){
			alertDialog.setMessage("There are missing fields");			
		}
		else{
			alertDialog.setMessage("Authentification has failed");
		}
		alertDialog.setButton("OK", new DialogInterface.OnClickListener() {
             public void onClick(DialogInterface dialog, int which) {
                     return;
             }
         }); 
		alertDialog.show();

	}
	
	private void loadBasicProfile(){
		Intent intent = new Intent(this,TabsActivity.class);
		startActivity(intent);
	}
	
	private Boolean saveCookies(CookieStore cookies){
		app.setCookies(cookies);
		Log.i("CREDENTIALS", "Saved cookies");
		return true;
	}
}