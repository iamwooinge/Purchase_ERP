package stock;

import java.sql.Connection;
import java.sql.PreparedStatement;

import util.DatabaseUtil;

public class stockDAO {
   
   public int stock(int stock_num, String stock_no, String product_no, int product_standard, String product_unit, int product_amount, String stock_date, int stock_all) {
      String SQL = "INSERT INTO stock VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?);";
      Connection conn = null;
      PreparedStatement pstmt = null;
         
       try {
           conn = DatabaseUtil.getConnection();
           pstmt = conn.prepareStatement(SQL);
         pstmt.setInt(1, stock_num);  
         pstmt.setString(2, stock_no); //�옱怨� 踰덊샇
         pstmt.setString(3, product_no); //�뭹紐� 肄붾뱶
         pstmt.setInt(4, product_standard); //洹쒓꺽
         pstmt.setString(5, product_unit); //�떒�쐞
         pstmt.setInt(6, product_amount); //�닔�웾
         pstmt.setString(7, "초기"); //�옱怨� �벑濡� ���엯
         pstmt.setString(8, stock_date); //�옱怨� �벑濡� �씪�옄
         pstmt.setInt(9, stock_all);
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