package quiz;

import java.sql.*;
import java.util.ArrayList;

public class Announcement {
	private String announcementText;
	private long timestamp;

	@SuppressWarnings("unused")
	private Announcement() {
		throw new IllegalAccessError();
	}

	public Announcement(String announcementText, long timestamp) {
		this.announcementText = announcementText;
		this.timestamp = timestamp;
	}

	public String getAnnouncementText() {
		return announcementText;
	}

	public void setAnnouncementText(String announcementText) {
		this.announcementText = announcementText;
	}

	public String getHumanTime() {
		return TimeFormat.prettify(timestamp);
	}
	
	public static ArrayList<Announcement> getAnnouncements(int amount) {
		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			
			String query = "Select announcement, timestamp From announcements order by timestamp DESC";
			rs = statement.executeQuery(query);
			
			ArrayList<Announcement> announcements = new ArrayList<Announcement>();
			for (int i = 0; i < amount && rs.next(); i++) {
				String announcementText = rs.getString("announcement");
				Timestamp time = rs.getTimestamp("timestamp");
				long timestamp = time.getTime();
				announcements.add(new Announcement(announcementText, timestamp));
			}
			return announcements;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return new ArrayList<Announcement>();
	}
}
