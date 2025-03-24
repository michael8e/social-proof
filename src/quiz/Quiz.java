package quiz;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class Quiz {
	private int zID;
	private String quizName;
	private String description;
	private int uID;
	private Timestamp time;
	private boolean random;
	private boolean multiple;
	private boolean immediate;


	public Quiz(int inputzID) throws SQLException {
		String query = "Select * from quizzes where zID =" + inputzID + ";";
		Connection c = Database.openConnection();
		Statement s = Database.getStatement(c);
		ResultSet rs = s.executeQuery(query);
		rs.next();
		zID = inputzID;
		quizName = rs.getString("name");
		description = rs.getString("description");
		uID = rs.getInt("uID");
		time = rs.getTimestamp("time");
		random = rs.getBoolean("random");
		multiple = rs.getBoolean("multiple");
		immediate = rs.getBoolean("immediate");

		Database.closeConnections(c, s, rs);
		// close database connection
	}

	public boolean getRandom() {
		return random;
	}

	public boolean getMultiple() {
		return multiple;
	}

	public boolean getImmediate() {
		return immediate;
	}

	public int getID() {
		return zID;
	}

	public String getName() {
		return quizName;
	}

	public String getDescription() {
		return description;
	}

	public int getuID() {
		return uID;
	}

	public Timestamp getTime() {
		return time;
	}

	public int getQuestionCount() throws SQLException{
		String query = "Select count(*) as count from questions where zID =" + zID + ";";
		Connection c = Database.openConnection();
		Statement s = Database.getStatement(c);
		ResultSet rs = s.executeQuery(query);
		rs.next();
		int count = rs.getInt("count");
		Database.closeConnections(c, s, rs);

		return count;
	}

	public String getQuestion(int sID) throws SQLException{
		String query = "Select * from questions where zID =" + zID + " and sID=" + sID + ";";
		Connection c = Database.openConnection();
		Statement s = Database.getStatement(c);
		ResultSet rs = s.executeQuery(query);
		rs.next();
		String question = rs.getString("question");
		Database.closeConnections(c, s, rs);

		return question;
	}

	public Integer getQuestionType(int sID) throws SQLException{
		String query = "Select * from questions where zID =" + zID + " and sID=" + sID + ";";
		Connection c = Database.openConnection();
		Statement s = Database.getStatement(c);
		ResultSet rs = s.executeQuery(query);
		rs.next();
		int type = rs.getInt("type");
		Database.closeConnections(c, s, rs);

		return type;
	}

	public ArrayList<Integer> getQuestionTypes() throws SQLException{
		String query = "Select * from questions where zID =" + zID + " order by sID ASC;";
		Connection c = Database.openConnection();
		Statement s = Database.getStatement(c);
		ResultSet rs = s.executeQuery(query);

		ArrayList<Integer> types = new ArrayList<Integer>();
		while(rs.next()){
			types.add(rs.getInt("type"));
		}
		Database.closeConnections(c, s, rs);

		return types;
	}


	public ArrayList<String> getChoices(int sID) throws SQLException{
		String query = "Select * from choices where zID =" + zID + " and sID=" + sID + ";";
		Connection c = Database.openConnection();
		Statement s = Database.getStatement(c);
		ResultSet rs = s.executeQuery(query);
		ArrayList<String> choices = new ArrayList<String>();


		while(rs.next()){
			choices.add(rs.getString("choice"));

		}
		Database.closeConnections(c, s, rs);

		return choices;
	}

	public ArrayList<String> getAnswers(int sID) throws SQLException{
		String query = "Select * from answers where zID =" + zID + " and sID=" + sID + ";";
		Connection c = Database.openConnection();
		Statement s = Database.getStatement(c);
		ResultSet rs = s.executeQuery(query);

		ArrayList<String> answers = new ArrayList<String>();

		while(rs.next()){
			answers.add(rs.getString("answer"));
		}

		Database.closeConnections(c, s, rs);

		return answers;
	}

	public String getAnswersString(int sID) throws SQLException{
		ArrayList<String> answerArr = getAnswers(sID);
		String answers = "";
		for(int i=0; i<answerArr.size(); i++){
			answers += answerArr.get(i);
			if(i != answerArr.size() - 1) answers += ", ";
		}

		return answers;
	}

	public Integer getChoicesCount(int sID) throws SQLException{
		String query = "Select count(*) as count from choices where zID =" + zID + " and sID=" + sID + ";";
		Connection c = Database.openConnection();
		Statement s = Database.getStatement(c);
		ResultSet rs = s.executeQuery(query);
		rs.next();

		int count = rs.getInt("count");

		Database.closeConnections(c, s, rs);

		return count;
	}

	public static ArrayList<Quiz> getRecentQuizzes(int limit) {
		ArrayList<Quiz> quizzes = new ArrayList<Quiz>();

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			String query = "Select zID From quizzes ORDER BY time DESC LIMIT " + limit + ";";
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

	public static ArrayList<Quiz> getPopularQuizzes(int limit) {
		ArrayList<Quiz> quizzes = new ArrayList<Quiz>();

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			String query = "Select zID, count(*) as Count From scores Group By zID Order By Count DESC LIMIT " + limit + ";";
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

	public static ArrayList<Quiz> findQuizzes(String queryTerm) {
		ArrayList<Quiz> quizzes = new ArrayList<Quiz>();

		String query = "SELECT zID FROM quizzes WHERE " 
				+ "name like '%" + queryTerm + "%'" 
				+ "OR description like '%" + queryTerm + "%'";

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
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

	public int getNumAttempts() {

		String query = "SELECT COUNT(*) as Count FROM scores WHERE zID=" + zID; 

		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			rs = statement.executeQuery(query);
			if (rs.next()) {
				return rs.getInt("Count");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return -1;
	}
}