package quiz;

import java.sql.*;
import java.util.ArrayList;

public class Message {
	public static final int SEND_MESSAGE = 0;
	public static final int MARK_AS_READ = 1;
		
	private int id;
	private User sender;
	private User recipient;
	private String content;
	private Timestamp timestamp; 
	
	public Message(
			int id,
			User sender,
			User recipient,
			String content,
			Timestamp timestamp) {
		this.id = id;
		this.sender = sender;
		this.recipient = recipient;
		this.content = content;
		this.timestamp = timestamp;
	}

	public int getID() {
		return id;
	}

	public User getSender() {
		return sender;
	}

	public User getRecipient() {
		return recipient;
	}

	public Timestamp getTimestamp() {
		return timestamp;
	}

	public String getMessage() {
		return content;
	}

	public boolean isRead() throws Exception {
		return readStateColumn("is_read");
	}

	public static void markAsRead(int mID) {
		setStateColumn("messages", "is_read", mID, true);
	}

	public static ArrayList<Message> getMessages(int uID) {
		ArrayList<Message> messages = new ArrayList<Message>();

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			String query = "SELECT * FROM messages WHERE toID=" + uID;
			rs = statement.executeQuery(query);
			while (rs.next()) {
				int id = rs.getInt("mID");
				User sender = User.getUser(rs.getInt("fromID"));
				User recipient = User.getUser(rs.getInt("toID"));
				String message = rs.getString("content");
				Timestamp timestamp = rs.getTimestamp("timestamp");
				messages.add(new Message(id, sender, recipient, message, timestamp));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return messages;
	}
	
	private static Message getMessage(int mID) {
		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			String query = "SELECT * FROM messages WHERE mID=" + mID;
			rs = statement.executeQuery(query);
			while (rs.next()) {
				int id = rs.getInt("mID");
				User sender = User.getUser(rs.getInt("fromID"));
				User recipient = User.getUser(rs.getInt("toID"));
				String message = rs.getString("content");
				Timestamp timestamp = rs.getTimestamp("timestamp");
				return new Message(id, sender, recipient, message, timestamp);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return null;
	}

	public static Message sendMessage(int fromID, int toID, String content) throws Exception {
		Connection con = null;
		PreparedStatement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = con.prepareStatement(
					"INSERT INTO c_cs108_rrb.messages (fromID, toID, content) VALUES (?, ?, ?);",
					Statement.RETURN_GENERATED_KEYS);
			statement.setInt(1, fromID);
			statement.setInt(2, toID);
			statement.setString(3, content);
			
			statement.execute();
			rs = statement.getGeneratedKeys();
			if (rs.next()) {
				int id = rs.getInt("GENERATED_KEY");
				return getMessage(id);
			} else {
				throw new Exception("An error occurred while sending your message. Please try again later.");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			statement.close();
			Database.closeConnections(con, rs);
		}
		return null;
	}
	
	private boolean readStateColumn(String column) throws Exception {
		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			String query = "SELECT " + column + " FROM messages WHERE mID=" + id;
			rs = statement.executeQuery(query);
			if (!rs.next())
				throw new Exception(
						"An error occurred while trying to receive this message's " 
								+ column + " column.");

			return rs.getBoolean(column);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return false;
	}

	protected static void setStateColumn(String table, String column, int mID, boolean value) {
		Connection con = null;
		Statement statement = null;

		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			String query = "UPDATE " + table + " SET " + column + "=" + value + " WHERE mID=" + mID; 
			statement.executeUpdate(query);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement);
		}
	}
}
