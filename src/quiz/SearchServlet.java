package quiz;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class SearchServlet
 */
@WebServlet("/search")
public class SearchServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SearchServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] queryParams = request.getParameterValues("query");
		String query = queryParams == null ? "" : queryParams[0];

		request.setAttribute("users", User.findUsers(query));
		request.setAttribute("quizzes", Quiz.findQuizzes(query));
		
		RequestDispatcher dispatch = request.getRequestDispatcher("search.jsp");
		dispatch.forward(request, response);
	}
}