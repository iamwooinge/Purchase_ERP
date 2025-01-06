package util;

import java.sql.Connection;
import java.sql.DriverManager;

public class DatabaseUtil {

	public static Connection getConnection() {
		try {
			String dbURL = "jdbc:mysql://localhost:3306/purchasing_manage?serverTimezone=UTC";
			String dbid = "root";
	    	String dbpass="1234";
	    	Class.forName("com.mysql.jdbc.Driver");
	    	return DriverManager.getConnection(dbURL, dbid, dbpass);
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}

}
