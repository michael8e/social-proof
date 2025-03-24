package quiz;

import java.io.IOException;
import java.sql.*;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AdminAnnoucement
 */
@WebServlet("/AdminAnnouncement")
public class AdminAnnouncement extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AdminAnnouncement() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Connection con = null;
		Statement statement = null;
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);

			String text = request.getParameter("announcement");
			User user = (User)request.getSession().getAttribute("user");
			int uID = user.getID();

			String timestamp = TimeFormat.getTimestamp();

			String insertQuery =
					"INSERT INTO announcements VALUES (" 
					+ uID + ", '"
					+ text + "', '"
					+ timestamp + "');";

			if (!text.equals("")){
				try {
					statement.execute(insertQuery);
				} catch (SQLException e) {
					e.printStackTrace();
				}
			}

			RequestDispatcher dispatch = request.getRequestDispatcher("AdminPage.jsp");
			dispatch.forward(request, response);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			Database.closeConnections(con, statement, null);
		}
	}

}
