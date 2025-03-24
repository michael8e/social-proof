package quiz;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AdminNew
 */
@WebServlet("/AdminNew")
public class AdminNew extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminNew() {
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
		int newID = Integer.parseInt(request.getParameter("newAdmin"));
		
		Connection con = null;
		Statement statement = null;
		String query = "Select * from administrators where uID=" + newID + ";";
		ResultSet rs = null;
		
		try {
			con = Database.openConnection();
			statement = Database.getStatement(con);
			rs = statement.executeQuery(query);
			if(rs.next()){
				Database.closeConnections(con, statement, rs);
				RequestDispatcher dispatch = request.getRequestDispatcher("AdminPage.jsp");
				dispatch.forward(request, response);
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return;
		}
		
		String insert = "Insert into administrators value(" + newID + ");";
		try {
			statement.execute(insert);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		Database.closeConnections(con, statement, rs);
		RequestDispatcher dispatch = request.getRequestDispatcher("AdminPage.jsp");
		dispatch.forward(request, response);
		
		
	}

}
