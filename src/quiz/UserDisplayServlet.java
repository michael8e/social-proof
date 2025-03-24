package quiz;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UserSearch
 */
@WebServlet("/user")
public class UserDisplayServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserDisplayServlet() {
		super();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String[] userIDs = request.getParameterValues("uid");
		if (userIDs == null || userIDs.length != 1) {
			response.sendRedirect(Constants.INDEX);
		} else {
			int uID = Integer.parseInt(userIDs[0]);
			User user = User.getUser(uID);
			request.setAttribute("user", user);
			RequestDispatcher dispatch = request.getRequestDispatcher("profile.jsp");
			dispatch.forward(request, response);
		}
	}
}