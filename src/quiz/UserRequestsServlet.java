package quiz;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
/**
 * Servlet implementation class UserRequestsServlet
 */
@WebServlet("/request")
public class UserRequestsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserRequestsServlet() {
		super();
	}
	
	private int getIntParameter(HttpServletRequest request, String param) {
		String[] valueParam = request.getParameterValues(param);
		if (valueParam == null || valueParam.length != 1) {
			throw new IllegalAccessError("Missing required parameter: " + param);
		}
		return Integer.parseInt(valueParam[0]);
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User currentUser = (User) request.getSession().getAttribute("user");
		if (currentUser == null) {
			throw new IllegalAccessError("Must be logged in to do this.");
		}
		
		int requestType = getIntParameter(request, "request");
		int friendID = getIntParameter(request, "friendid");
		
		switch(requestType) {
		case Constants.SEND_REQUEST:
			currentUser.sendFriendRequest(friendID);
			break;
		case Constants.ACCEPT_REQUEST:
			currentUser.acceptFriendRequest(friendID);
			break;
		case Constants.REJECT_REQUEST:
			currentUser.rejectFriendRequest(friendID);
			response.sendRedirect("inbox.jsp");
			return;
		case Constants.DELETE_FRIEND_REQUEST:
			currentUser.deleteFriend(friendID);
			response.sendRedirect("user?uid=" + currentUser.getID());
			return;
		}
		
		response.sendRedirect("user?uid=" + friendID);
	}
}