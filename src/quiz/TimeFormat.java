package quiz;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeFormat {
	public static final SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("EEEE, MMMM dd, yyyy");

	public static String getTimestamp() {
		Date date = new Date();
		java.sql.Timestamp stamp = new java.sql.Timestamp(date.getTime());
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String timestamp = simpleDateFormat.format(stamp);
		return timestamp;
	}

	public static String prettify(long timestamp) {
		return DATE_FORMAT.format(new Date(timestamp));
	}
}
