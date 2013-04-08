package cloudfoundry.activity.util;

import java.io.IOException;
import java.net.URL;
import java.net.HttpURLConnection;

public class URLChecker {

	public static synchronized boolean isValid(String url) {
		boolean flag = false;
		int counts = 0;
		if (url == null || url.length() <= 0) {
			return flag;
		}
		if(!url.startsWith("http://"))
			url = "http://"+url;
		while (counts < 5) {
			try {
				HttpURLConnection connection = (HttpURLConnection) new URL(url).openConnection();
				int state = connection.getResponseCode();
				if (state == 200) {
					flag = true;
				}
				break;
			} catch (IOException e) {
				counts++;
				continue;
			}
		}
		return flag;
	}
}
