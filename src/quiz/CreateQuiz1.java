package quiz;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Date;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CreateQuiz1
 */
@WebServlet("/CreateQuiz1")
public class CreateQuiz1 extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CreateQuiz1() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException { }


	private int getNumberOfQuizzes() throws SQLException{
		Connection con = null;
		Statement statement = null;
		ResultSet rs = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			String query = "Select max(zID) as Count From quizzes;";
			rs = statement.executeQuery(query);
			rs.next();
			return rs.getInt("Count") + 1;
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, rs);
		}
		return -1;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
		name = name.replaceAll("'", "''");
		Boolean random = request.getParameter("random").equals("yes");
		Boolean multiple = request.getParameter("multiple").equals("yes");
		Boolean immediate = request.getParameter("immediate").equals("yes");
		String description = request.getParameter("description");
		description = description.replaceAll("'", "''");
		int user = -1;
		
		Object j = request.getSession().getAttribute("user");
		if(j != null){
			User u = (User)j;
			user = u.getID();
		}
		
		String ts = TimeFormat.getTimestamp();

		Connection con = null;
		Statement statement = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			int quizNumber = getNumberOfQuizzes();
			
			
			PreparedStatement s = con.prepareStatement("INSERT INTO quizzes (zID, name, description, uID, time, random, multiple, immediate) values (?, ?, ?, ?, ?, ?, ?, ?)");
		    s.setInt(1, quizNumber);
			s.setString(2, name);
		    s.setString(3, description);
		    s.setInt(4, user);
		    s.setString(5, ts);
		    s.setBoolean(6, random);
		    s.setBoolean(7, multiple);
		    s.setBoolean(8, immediate);
		    s.executeUpdate();
			
			/*
			String insertValues= "'" + name + "', '" 
					+ description + "', "
					+ user + ", '" + 
					timestamp + "', "
					+ random + ", "
					+ multiple + ", "
					+ immediate;
			String insertQuery = "INSERT INTO quizzes VALUES (" +  quizNumber + ", " + insertValues + ");";
			statement.execute(insertQuery);
			*/

			//add tuple to achievements
			int AUTHOR_TYPE = 0;
			
			String insertQuery = "INSERT INTO achievements VALUES (" + user + ", " + AUTHOR_TYPE + ", '" + name + "');";
			statement.execute(insertQuery);
			request.getSession().setAttribute("quizNumber", quizNumber);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, null);
		}

		RequestDispatcher dispatch = request.getRequestDispatcher("CreateQuizType.jsp");
		dispatch.forward(request, response);
	}

}
