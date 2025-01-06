package income;

import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DatabaseUtil;

public class incomeDAO {
	
	public int income(int income_num, String income_no, String income_return_no, String employee_no, String client_name, String product_no, int product_standard, String product_unit, String order_date, int product_count, int product_unitprice, int product_supply, int order_vat, int order_price, String income_date, int income_count,int nincome_count, String income_state, String income_category ) {
		String SQL = "INSERT INTO INCOME VALUES(?,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?, ?)";
		try {
			Connection conn = DatabaseUtil.getConnection();
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, income_num); //income_num
			pstmt.setString(2, income_no); //income_no
			pstmt.setString(3, income_return_no); //income_return_no
			pstmt.setString(4, employee_no); //employee_no
			pstmt.setString(5, client_name); //client_name
			pstmt.setString(6, product_no); //product_no
			pstmt.setInt(7, product_standard); //product_standard
			pstmt.setString(8, product_unit); // product_unit
			pstmt.setString(9, order_date); //order_date
			pstmt.setInt(10,product_count); //product_count
			pstmt.setInt(11,product_unitprice); //product_unitprice
			pstmt.setInt(12,product_supply); //product_supply
			pstmt.setInt(13,order_vat); //order_vat
			pstmt.setInt(14,order_price); //order_price
			pstmt.setString(15, income_date); //income_date
			pstmt.setInt(16, income_count); //income_count
			pstmt.setInt(17, nincome_count); //nincome_count
			pstmt.setString(18, income_state); //income_state
			pstmt.setString(19, income_category); //income_category
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}
