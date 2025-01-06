package user;

import java.sql.Connection;

import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	private String employee_id;
	private String employee_pw;
	private String employee_name;
	private String rank_name;
	private String dept_name;
	private Connection conn;
	private ResultSet rs;

	public UserDAO() {
		try {
			String jdbcUrl = "jdbc:mysql://localhost:3306/purchasing_manage?serverTimezone=UTC";
	    	String dbid = "root";
	    	String dbpass="1234";
	    	Class.forName("com.mysql.cj.jdbc.Driver");
	    	
	    	conn = DriverManager.getConnection(jdbcUrl, dbid, dbpass);
	    	
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int login(String employee_id, String employee_pw) {
		try {
			PreparedStatement pst = conn.prepareStatement("SELECT employee_pw FROM employee WHERE employee_no = ?");
			pst.setString(1, employee_id);
			rs = pst.executeQuery();
			if (rs.next()) {
				return rs.getString(1).equals(employee_pw) ? 1 : 0;
			} else {
				return -2;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
	}

	public boolean ID_Check(String employee_id) {
		try {
			PreparedStatement pst = conn.prepareStatement("SELECT employee_no, employee_pw FROM employee WHERE employee_no = ?");
			pst.setString(1, employee_id);
			rs = pst.executeQuery();
			if (rs.next()) {
				return false;
			} else {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}



	public UserDAO getUser(String userID) { 
		try {
			PreparedStatement pst = conn.prepareStatement("SELECT employee_no, employee_pw FROM employee WHERE employee_no = ?");
			pst.setString(1, userID);
			rs = pst.executeQuery();
			if (rs.next()) {
				UserDAO userDAO = new UserDAO();
				userDAO.setEmployee_id(rs.getString(1));
				userDAO.setEmployee_pw(rs.getString(2));
				return userDAO;
				}
			}
		catch (Exception e) {
			e.printStackTrace();
			}
		return null;
		}

	public String getEmployee_id() {
		return employee_id;
	}

	public void setEmployee_id(String employee_id) {
		this.employee_id = employee_id;
	}

	public String getEmployee_pw() {
		return employee_pw;
	}

	public void setEmployee_pw(String employee_pw) {
		this.employee_pw = employee_pw;
	}
	

	}
