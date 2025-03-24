package quiz;

import java.security.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Random;

public class User {
	private static final int SALT_LENGTH = 20;
	private static final int PASSWORD_MINIMUM = 8;
	
	private static final int PRODIGIOUS_AUTHOR = 10;
	private static final int PROLIFIC_AUTHOR = 5;
	private static final int AMATEUR_AUTHOR = 1;
	private final int id;
	private final String username;

	// Empty User object should never be constructed.
	private User() {
		throw new IllegalAccessError();
	}

	/* 
	 * Private because User objects should only be obtained via getUser, 
	 * which validates against the database.
	 */
	private User(int uID, String username) {
		this.id = uID;
		this.username = username;	
	}

	public boolean isAdmin(){
		String query = "Select uID from administrators where uID=" + this.id + ";";

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		boolean admin = false;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			rs = statement.executeQuery(query);
			if(rs.next()){
				admin = true;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return admin;

	}

	public int getID() {
		return id;
	}

	public String getUsername() {
		return username;
	}

	private static User getUser(Integer requestedUID, String requestedUsername) {
		String query = "";
		if (requestedUID != null && requestedUsername != null) {
			throw new IllegalArgumentException();
		} else if (requestedUID == null) {
			query = "SELECT * FROM users WHERE " + Constants.USERNAME_KEY + "='" + requestedUsername + "';";
		} else {
			query = "SELECT * FROM users WHERE uID='" + requestedUID + "';";
		}

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			rs = statement.executeQuery(query);
			if (!rs.next()) return null;
			int uID = rs.getInt("uID");
			String username = rs.getString(Constants.USERNAME_KEY);
			return new User(uID, username);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return null;
	}

	public static User getUser(int uID) {
		return getUser(uID, null);
	}

	public static User getUser(String username) {
		return getUser(null, username.toLowerCase());
	}

	/**
	 * @param username
	 * @param passwordText
	 * @return
	 */
	public static User addUserToDatabase(String username, String passwordText) throws Exception {
		Connection con = null;
		Statement insertStatement = null;
		ResultSet rs = null;
		username = username.toLowerCase();
		try {
			con = Database.openConnection();

			// The user already exists.
			if (getUser(username) != null) {
				throw new Exception("User already exists.");
			}

			//validatePassword(passwordText);

			String salt = generateSalt();
			String passwordHash = generateSaltedHash(passwordText, salt);
			if (passwordHash == null) {
				throw new Exception("An error occurred. Please try again later.");
			}

			String insertQuery = "INSERT INTO users (username, password, salt) VALUES ("
					+ "'" + username + "', "
					+ "'" + passwordHash + "', "
					+ "'" + salt + "');";
			insertStatement = Database.getStatement(con);
			insertStatement.execute(insertQuery, Statement.RETURN_GENERATED_KEYS);
			rs = insertStatement.getGeneratedKeys();
			if (rs.next()) {
				int id = rs.getInt("GENERATED_KEY");
				return new User(id, username);
			} else {
				throw new Exception("An error occurred. Please try again later.");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new Exception("An error occurred while accessing the database. Please try again later.");
		} finally {
			Database.closeConnections(con, insertStatement);
		}
	}

	private static void validatePassword(String passwordText) throws Exception {
		if (passwordText.length() < PASSWORD_MINIMUM) {
			throw new Exception("Password must be greater than 8 characters.");
		} else {
			boolean containsLower = false;
			boolean containsUpper = false;
			boolean containsPunct = false;
			for (int i = 0; i < passwordText.length(); i++) {
				char ch = passwordText.charAt(i);
				if (Character.isLowerCase(ch)) {
					containsLower = true;
				} else if (Character.isUpperCase(ch)) {
					containsUpper = true;
				} else {
					switch (ch) {
					case '.': case ',': case '!': case '?': case ';': case ':':
						containsPunct = true;
					}
				}
			}
			if (!(containsLower && containsUpper && containsPunct)) {
				throw new Exception("Password must contain at least one lowercase letter, uppercase letter, and punctuation character.");
			}
		}
	}

	public static int validateUser(String username, String passwordAttemptText) {
		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		username = username.toLowerCase();
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			String userQuery = "SELECT uID, password, salt FROM users WHERE username='" + username + "';";
			rs = statement.executeQuery(userQuery);
			if (!rs.next()) return -1;
			int uID = rs.getInt("uID");
			String passwordInDatabase = rs.getString("password");
			String salt = rs.getString("salt");

			String passwordAttempt = generateSaltedHash(passwordAttemptText, salt);
			if (passwordInDatabase.equals(passwordAttempt)) {
				return uID;
			} else {
				return -1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return -1;
		} finally {
			Database.closeConnections(con, statement, rs);
		}
	}

	/**
	 * @param plaintext The text to hash.
	 * @param salt The salt to use. If null, this method will not use a salt.
	 * @return A String representation of the plaintext bytes hashed with a salt.
	 */
	public static String generateSaltedHash(String plaintext, String salt) {
		if (salt == null)
			salt = "";

		try {
			MessageDigest md = MessageDigest.getInstance("SHA");
			md.update((plaintext + salt).getBytes());
			byte[] hash = md.digest();
			return hexToString(hash);
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * Randomly generates a String representation of randomly generated bytes.
	 */
	private static String generateSalt() {
		byte[] salt = new byte[SALT_LENGTH];
		new Random().nextBytes(salt);
		return hexToString(salt);
	}

	/**
	 * Given a byte[] array, produces a hex String, such as "234a6f"
	 * with 2 chars for each byte in the array.
	 * (provided code from CS 108 hw4)
	 */ 
	private static String hexToString(byte[] bytes) { 
		StringBuffer buff = new StringBuffer(); 
		for (int i = 0; i < bytes.length; i++) { 
			int val = bytes[i]; 
			val = val & 0xff;  // remove higher bits, sign 
			if (val<16) buff.append('0'); // leading 0 
			buff.append(Integer.toString(val, 16)); 
		} 
		return buff.toString(); 
	}

	public static HashMap<Integer, User> findUsers(String queryTerm) {
		HashMap<Integer, User> users = new HashMap<Integer, User>();
		String query = "SELECT * FROM users WHERE username like '%" + queryTerm + "%'";

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			rs = statement.executeQuery(query);
			while (rs.next()) {
				int uID = rs.getInt("uID");
				String username = rs.getString(Constants.USERNAME_KEY);
				users.put(uID, new User(uID, username));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return users;
	}

	public HashMap<Integer, User> getFriends() {
		String query = "SELECT friendID FROM friendships WHERE uID=" + id + ";";
		return getUsersFromQuery(query, "friendID");
	}

	public HashMap<Integer, User> getFriendRequests() {
		String query = "SELECT fromID FROM friend_requests WHERE toID=" + id + ";";
		return getUsersFromQuery(query, "fromID");
	}

	public HashMap<Integer, User> getUsersFromQuery(String query, String idKey) {
		HashMap<Integer, User> users = new HashMap<Integer, User>();

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			rs = statement.executeQuery(query);
			while (rs.next()) {
				int uID = rs.getInt(idKey);
				User user = getUser(uID);
				if (user == null) {
					throw new IllegalStateException("There is an inconsistency in the database! Please fix it before moving forward.");
				}
				users.put(uID, getUser(uID));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return users;
	}

	private static void executeSimpleQuery(String query) {
		Connection con = null;
		Statement statement = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			statement.execute(query);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement);
		}
	}

	private void removeFromFriendRequestTable(int fromID, int toID) {
		String query = "DELETE FROM friend_requests WHERE fromID=" + fromID + " AND toID=" + toID;
		executeSimpleQuery(query);
	}

	private static void addOneWayFriend(int uID, int friendID) {
		String query = "INSERT INTO friendships VALUES (" + uID + ", " + friendID + ")";
		executeSimpleQuery(query);
	}

	public void sendFriendRequest(int friendID) {
		String query = "INSERT INTO friend_requests VALUES (" + id + ", " + friendID + ")";
		executeSimpleQuery(query);		
	}

	public void acceptFriendRequest(int friendID) {
		removeFromFriendRequestTable(friendID, id);
		addOneWayFriend(id, friendID);
		addOneWayFriend(friendID, id);
	}

	public void rejectFriendRequest(int friendID) {
		removeFromFriendRequestTable(friendID, id);
	}

	public int getNotificationCount() throws Exception {
		return getChallenges().size() + getMessages().size() +  getFriendRequests().size();
	}

	public void deleteFriend(int friendID) {
		String first = "DELETE FROM friendships WHERE uID=" + id + " AND " + "friendID=" + friendID;
		String second = "DELETE FROM friendships WHERE uID=" + friendID + " AND " + "friendID=" + id;
		executeSimpleQuery(first);
		executeSimpleQuery(second);
	}

	public ArrayList<Message> getMessages() throws Exception {
		ArrayList<Message> messages = Message.getMessages(id);
		Iterator<Message> it = messages.iterator();
		while (it.hasNext()) {
			Message m = it.next();
			if (m.isRead()) it.remove();
		}
		return messages;
	}

	public ArrayList<Challenge> getChallenges() {
		return Challenge.getChallenges(id);
	}

	public ArrayList<String> getAchievements() {
		ArrayList<String> achievements = new ArrayList<String>();
		
		ArrayList<Quiz> taken = getRecentlyTakenQuizzes(-1);
		ArrayList<Quiz> created = getRecentlyCreatedQuizzes(-1);
		
		switch(created.size()) {
		case PRODIGIOUS_AUTHOR:
			achievements.add("Prodigious Author");
		case PROLIFIC_AUTHOR:
			achievements.add("Prolific Author");
		case AMATEUR_AUTHOR:
			achievements.add("Amateur Author");
		}
		
		if (taken.size() > 10) {
			achievements.add("Quiz Machine");
		}

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			String query = "SELECT name FROM achievements WHERE uID=" + id;
			
			rs = statement.executeQuery(query);
			while (rs.next()) {
				String name = rs.getString("name");
				achievements.add(name);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return achievements;
	}

	public ArrayList<Quiz> getRecentlyTakenQuizzes(int limit) {
		ArrayList<Quiz> quizzes = new ArrayList<Quiz>();
		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			String query = "Select zID from scores where uID="
					+ id + " order by time DESC";
			if (limit != -1) {
				query += " LIMIT " + limit;
			}
			query += ";";
			
			rs = statement.executeQuery(query);
			while (rs.next()) {
				int zID = rs.getInt("zID");
				quizzes.add(new Quiz(zID));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return quizzes;
	}
	
	public ArrayList<Quiz> getRecentlyCreatedQuizzes(int limit) {
		ArrayList<Quiz> quizzes = new ArrayList<Quiz>();
		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			String query = "Select zID from quizzes where uID="
					+ id + " order by time DESC";
			if (limit != -1) {
				query += " LIMIT " + limit;
			}
			query += ";";
			
			rs = statement.executeQuery(query);
			while (rs.next()) {
				int zID = rs.getInt("zID");
				quizzes.add(new Quiz(zID));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return quizzes;
	}
	
	public HashMap<Integer, ArrayList<Quiz>> getFriendActivities() {
		HashMap<Integer, ArrayList<Quiz>> activities = new HashMap<Integer, ArrayList<Quiz>>();
		Iterator<Integer> friends = getFriends().keySet().iterator();
		
		if (!friends.hasNext())
			return activities;
		
		String friendIDs = "(";
		friendIDs += friends.next();
		while (friends.hasNext()) {
			friendIDs += ", " + friends.next();
		}
		friendIDs += ")";
		
		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			String query = "Select uID, zID from scores where uID IN " + friendIDs + " order by timeTaken DESC LIMIT 5;";
			
			rs = statement.executeQuery(query);
			while (rs.next()) {
				int uID = rs.getInt("uID");
				int zID = rs.getInt("zID");
				if (!activities.containsKey(uID)) {
					activities.put(uID, new ArrayList<Quiz>());
				}
				activities.get(uID).add(new Quiz(zID));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return activities;
	}
}
