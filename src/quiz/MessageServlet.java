package quiz;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class MessageServlet
 */
@WebServlet("/message")
public class MessageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public MessageServlet() {
		super();
	}

	private String getParameter(HttpServletRequest request, String param) {
		String[] valueParam = request.getParameterValues(param);
		if (valueParam == null || valueParam.length != 1) {
			return "" + Constants.SEND_CHALLENGE;
		}
		return valueParam[0];
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User currentUser = (User) request.getSession().getAttribute("user");
		if (currentUser == null) {
			throw new IllegalAccessError("Must be logged in to do this.");
		}

		int requestType = Integer.parseInt(getParameter(request, "request"));
		int mID = Integer.parseInt(getParameter(request, "mID"));

		// more types can be added in the future
		switch(requestType) {
		case Message.MARK_AS_READ:
			Message.markAsRead(mID);
			break;
		case Constants.IGNORE_CHALLENGE:
			Challenge.ignoreChallenge(Integer.parseInt(getParameter(request, "cID")));
			break;
		}

		response.sendRedirect("inbox.jsp");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute("user");
		if (currentUser == null) {
			throw new IllegalAccessError("Must be logged in to do this.");
		}

		int fromID = currentUser.getID();
		int requestType = Integer.parseInt(getParameter(request, "request"));
		int toID = Integer.parseInt(getParameter(request, "toID"));
		String content = getParameter(request, "content");
		
		if (requestType == Constants.SEND_CHALLENGE) {
			System.out.println("to: " + toID);
			System.out.println("from: " + fromID);
			int zID = Integer.parseInt(getParameter(request, "zID"));
			System.out.println("zID: " + zID);
			try {
				Challenge.sendChallenge(fromID, toID, zID, content);
				System.out.println(zID);
			} catch (Exception e) {
				e.printStackTrace();
				session.setAttribute("message", e.getMessage());
			}

			response.sendRedirect("index.jsp");
		} else {
			try {
				Message.sendMessage(fromID, toID, content);
			} catch (Exception e) {
				e.printStackTrace();
				session.setAttribute("message", e.getMessage());
			}

			response.sendRedirect("inbox.jsp");
		}

	}
}
