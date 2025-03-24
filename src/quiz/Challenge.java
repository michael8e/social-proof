package quiz;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Challenge {
	private int id;
	private User sender;
	private Quiz quiz;
	private String content;

	public Challenge(int cID, User sender, User recipient, Quiz zID, String content, boolean completed) {
		this.id = cID;
		this.sender = sender;
		this.quiz = zID;
		this.content = content;
	}

	public int getID() {
		return id;
	}

	public User getSender() {
		return sender;
	}

	public Quiz getQuiz() {
		return quiz;
	}

	public String getMessage() {
		return content;
	}

	public static ArrayList<Challenge> getChallenges(int uID) {
		ArrayList<Challenge> challenges = new ArrayList<Challenge>();

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			String query = "SELECT * FROM challenges WHERE toID=" + uID;
			rs = statement.executeQuery(query);
			while (rs.next()) {
				int cID = rs.getInt("cID");
				User sender = User.getUser(rs.getInt("fromID"));
				User recipient = User.getUser(rs.getInt("toID"));
				Quiz quiz;
				try {
					quiz = new Quiz(rs.getInt("zID"));
				} catch (SQLException ex) {
					continue; // quiz no longer exists
				}
				String content = rs.getString("content");
				boolean completed = rs.getBoolean("completed");
				if (!completed) {
					challenges.add(new Challenge(cID, sender, recipient, quiz, content, completed));
				}
			}
		} catch (SQLException e) {

		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return challenges;
	}

	public static void sendChallenge(int fromID, int toID, int zID, String content) {
		Connection con = null;
		Statement statement = null;

		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			String query = "INSERT INTO challenges (fromID, toID, zID, content) VALUES("
					+ fromID + ", "
					+ toID + ", "
					+ zID + ", "
					+ "'" + content + "');";

			statement.executeUpdate(query);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement);
		}
	}

	public static void markAsCompleted(int id) {
		Connection con = null;
		Statement statement = null;

		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			String query = "UPDATE challenges SET completed=true WHERE cID=" + id; 
			statement.executeUpdate(query);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement);
		}
	}

	public static void ignoreChallenge(int id) {
		markAsCompleted(id);		
	}
}