package quiz;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class NextPageServlet
 */
@WebServlet("/NextPageServlet")
public class NextPageServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NextPageServlet() {
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
		int prevQNumber = (Integer.parseInt(request.getParameter("qNumber")));
		request.setAttribute("qNumber", prevQNumber + 1);
		ArrayList<String> answers = (ArrayList<String>)(request.getSession().getAttribute("answers"));
		answers.add(request.getParameter(String.valueOf(prevQNumber)));
		request.setAttribute("answers", answers);
		
		RequestDispatcher dispatch = request.getRequestDispatcher("singlePageQuiz.jsp");
		dispatch.forward(request, response);
	}

}
