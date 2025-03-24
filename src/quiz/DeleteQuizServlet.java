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
 * Servlet implementation class DeleteQuiz
 */
@WebServlet("/DeleteQuiz")
public class DeleteQuizServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DeleteQuizServlet() {
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

		int delete = Integer.parseInt(request.getParameter("zID"));

		String doUpdate = "Update quizzes Set zID = zID - 1 Where zID > " + delete + ";";
		String doDelete = "Delete from quizzes Where zID = " + delete + ";";

		Connection con = null;
		Statement statement = null;

		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			statement.execute(doDelete);
			statement.execute(doUpdate);
			getServletContext().setAttribute("message", "Delete successful.");	
		} catch (SQLException e) {
			e.printStackTrace();
			getServletContext().setAttribute("message", "Delete failed.");	
		} finally {
			Database.closeConnections(con, statement, null);
		}

		RequestDispatcher dispatch = request.getRequestDispatcher("DeleteQuiz.jsp");
		dispatch.forward(request, response);
	}
}












