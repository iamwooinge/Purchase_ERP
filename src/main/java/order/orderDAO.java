package order;

import java.sql.*;
import order.orderDAO;
import util.DatabaseUtil;

public class orderDAO {
	
	
	public int order(String order_date, String order_no, String employee_no, String client_name, String product_no, int product_standard, String product_unit, int order_amount, int product_unitprice, int order_supply, int order_vat, int order_price) {
		
		String sql = "INSERT INTO orders VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
		Connection conn = null; 
		PreparedStatement pstmt = null; 
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, order_date);
			pstmt.setString(2, order_no);
			pstmt.setString(3, employee_no);
			pstmt.setString(4, client_name);
			pstmt.setString(5, product_no);
			pstmt.setInt(6, product_standard);
			pstmt.setString(7, product_unit);
			pstmt.setInt(8, order_amount);
			pstmt.setInt(9, product_unitprice);
			pstmt.setInt(10, order_supply);
			pstmt.setInt(11, order_vat);
			pstmt.setInt(12, order_price);
			pstmt.setString(13, "미완료");
			return pstmt.executeUpdate();
		
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
            if ( conn != null ) try{conn.close();}catch(Exception e){}
		}
		return -1;
	}
	
	
	
    
}