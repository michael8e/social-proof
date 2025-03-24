package quiz;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AdminUser
 */
@WebServlet("/AdminUser")
public class AdminUser extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminUser() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int uID = Integer.parseInt(request.getParameter("removeUser"));
		
		Connection con = null;
		Statement statement = null;
		String queryUser = "Delete from users where uID=" + uID + ";";
		String queryAnn = "Delete from announcements where uID=" + uID + ";";
		String queryScores = "Delete from scores where uID=" + uID + ";";
		String queryAch = "Delete from achievements where uID=" + uID + ";";
		String queryOne = "Delete from friendships where friendID=" + uID + ";";
		String queryTwo = "Delete from friendships where uID=" + uID + ";";
		
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			statement.execute(queryUser);
			statement.execute(queryAnn);
			statement.execute(queryScores);
			statement.execute(queryAch);
			statement.execute(queryOne);
			statement.execute(queryTwo);
	
		} catch (SQLException e) {
			e.printStackTrace();
			return;
		}
		
		Database.closeConnections(con, statement);
		RequestDispatcher dispatch = request.getRequestDispatcher("AdminPage.jsp");
		dispatch.forward(request, response);
	}

}
