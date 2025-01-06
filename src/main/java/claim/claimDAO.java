package claim;

import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DatabaseUtil;

public class claimDAO {
   
   public int claim(String claim_no, String claim_date, String product_no, String employee_no, int product_amount, int product_standard, String product_unit) {
      String SQL = "INSERT INTO CLAIM VALUES(?, ?, ?, ?, ?, ?, ?, ?)";
      Connection conn = null;
      PreparedStatement pstmt = null;
         
       try {
           conn = DatabaseUtil.getConnection();
           pstmt = conn.prepareStatement(SQL);
         pstmt.setString(1, claim_no); //claim_no
         pstmt.setString(2, claim_date); //claim_date
         pstmt.setString(3, product_no); //product_no
         pstmt.setString(4, employee_no); //employee_no "AB2c01"
         pstmt.setInt(5, product_amount); //product_amount
         pstmt.setInt(6, product_standard); //product_standard
         pstmt.setString(7, product_unit); //product_unit
         pstmt.setString(8, "미접수"); //claim_state
         return pstmt.executeUpdate();
      }catch(Exception e) {
         e.printStackTrace();
      }finally {
             if ( pstmt != null ) try{pstmt.close();}catch(Exception e){}
             if ( conn != null ) try{conn.close();}catch(Exception e){}
       }
      return -1;
   }
}