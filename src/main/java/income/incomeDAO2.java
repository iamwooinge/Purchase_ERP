package income;

import java.sql.Connection;
import java.sql.PreparedStatement;
import util.DatabaseUtil;

public class incomeDAO2 { /* 재고 테이블 INSERT */
   public int stock(int stock_num, String stock_no, String product_no, int product_standard, String product_unit, int product_amount, 
         String product_type, String stock_date, int stock_all) {
      String SQL = "INSERT INTO STOCK VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?)";
      try {
         Connection conn = DatabaseUtil.getConnection();
         PreparedStatement pstmt = conn.prepareStatement(SQL);
         pstmt.setInt(1, stock_num); 
         pstmt.setString(2, stock_no); //
         pstmt.setString(3, product_no); 
         pstmt.setInt(4, product_standard);
         pstmt.setString(5, product_unit);
         pstmt.setInt(6, product_amount); //
         pstmt.setString(7, product_type); //
         pstmt.setString(8, stock_date); //
         pstmt.setInt(9, stock_all); //
         return pstmt.executeUpdate();
      }catch(Exception e) {
         e.printStackTrace();
      }
      return -1;
   }
}