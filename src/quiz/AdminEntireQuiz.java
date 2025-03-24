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
 * Servlet implementation class AdminEntireQuiz
 */
@WebServlet("/AdminEntireQuiz")
public class AdminEntireQuiz extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminEntireQuiz() {
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
		int zID = Integer.parseInt(request.getParameter("removeQuiz"));
		
		
		Connection con = null;
		Statement statement = null;
		String queryQuiz = "Delete from quizzes where zID=" + zID + ";";
		String queryScores = "Delete from scores where zID=" + zID + ";";
		String queryQuestions = "Delete from questions where zID=" + zID + ";";
		String queryChoices = "Delete from choices where zID=" + zID + ";";
		String queryAnswers = "Delete from answers where zID=" + zID + ";";
		
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			statement.execute(queryScores);
			statement.execute(queryQuestions);
			statement.execute(queryChoices);
			statement.execute(queryAnswers);
			statement.execute(queryQuiz);
	
		} catch (SQLException e) {
			e.printStackTrace();
			return;
		}
		
		Database.closeConnections(con, statement);
		RequestDispatcher dispatch = request.getRequestDispatcher("AdminPage.jsp");
		dispatch.forward(request, response);
		
		
		
		
		
	}

}
