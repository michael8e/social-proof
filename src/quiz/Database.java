package quiz;

import java.sql.*;

public class Database {
	public static final String USE_STATEMENT = "USE " + DatabaseInfo.MYSQL_DATABASE_NAME;

	public static Connection openConnection() throws SQLException {
		return (Connection) DriverManager.getConnection(
				"jdbc:mysql://" + DatabaseInfo.MYSQL_DATABASE_SERVER,
				DatabaseInfo.MYSQL_USERNAME,
				DatabaseInfo.MYSQL_PASSWORD);
	}

	public static Statement getStatement(Connection con) throws SQLException {
		Statement statement = (Statement) con.createStatement();
		statement.executeQuery(USE_STATEMENT);
		return statement;
	}

	public static void closeConnections(Object... sqlObjects) {
		for (int i = 0; i < sqlObjects.length; i++) {
			try {
				if (sqlObjects[i] instanceof Connection) {
					((Connection) sqlObjects[i]).close();
				} else if (sqlObjects[i] instanceof Statement) {
					((Statement) sqlObjects[i]).close();
				} else if (sqlObjects[i] instanceof ResultSet) {
					((ResultSet) sqlObjects[i]).close();
				} else if (sqlObjects[i] != null){
					throw new IllegalArgumentException(
							"Object must be a Connection, Statement, or ResultSet.");
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}
}