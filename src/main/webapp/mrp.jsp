<%@page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="common.common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.2.0/dist/sweetalert2.all.min.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

  <meta http-equiv="X-UA-Compatible" content="IE=edge">

  <meta name="copyright" content="MACode ID, https://macodeid.com/">

  <link rel="stylesheet" href="<%=common.url%>/assets/css/bootstrap.css">
  
  <link rel="stylesheet" href="<%=common.url%>/assets/css/maicons.css">

  <link rel="stylesheet" href="<%=common.url%>/assets/vendor/animate/animate.css">

  <link rel="stylesheet" href="<%=common.url%>/assets/vendor/owl-carousel/css/owl.carousel.css">

  <link rel="stylesheet" href="<%=common.url%>/assets/vendor/fancybox/css/jquery.fancybox.css">

  <link rel="stylesheet" href="<%=common.url%>/assets/css/theme.css">

  <link href = "<%=common.url%>/h2.css" rel = "stylesheet" type = "text/css"> 
  <link href = "<%=common.url%>/style.css" rel = "stylesheet" type = "text/css"> <!-- 네비게이션 css --> 
  
  <link href = "hj.css" rel = "stylesheet" type = "text/css">  
  <!-- Required meta tags tables-->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="table/fonts/icomoon/style.css">
    <link rel="stylesheet" href="table/css/owl.carousel.min.css">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="table/css/bootstrap.min.css">
    <link rel="stylesheet" href="table/css/style.css"> 
   <link href = "hj.css" rel = "stylesheet" type = "text/css">  
   
<title>MRP</title>
   <style>
      table, th, td {     /* border: 1px solid silver; */  text-align: center;}
      table th:first-child,
   table td:first-child {
   border-left: 0;
   }
   table th:last-child,
   table td:last-child {
   border-right: 0;
   }
   *{
   text-align: center;
   }
   
   #all{
      width: 1000px;
      position: absolute;
      left:80px;

   }
   
   #d1, #d2, #d3{
   width: 1200px;
   }
   th{
   background: #eaeaea;
   }
   
   #searchBtn{

  background:#454545;
  color:#fff;
  border:none;
  width: 100px;
  height:25px;
  font-size:0.85em;
  line-height:25px;
  padding:0 2em;
  cursor:pointer;
  transition:800ms ease all;
  outline:none;
   }
   
   #searchBtn:hover{
    background:#8b8b8b;}
    
   .inputG{
   width: 100px;
   height:25px;
   }

   </style>
   
<!-- <link href = "design.css" rel = "stylesheet" type = "text/css">    -->
</head>
<body>
   <section id = "content">
   
   <form method = "post" action = "mrp.jsp">
    <input type = "radio" id = "product" name = "product" onclick = 'Check(this.value)' value = "1" checked>배추 &nbsp;&nbsp;&nbsp;
    <input type = "radio" id = "product" name = "product"onclick = 'Check(this.value)' value = "2">무 <br><br>
    <input type="text" placeholder="규격" id="inMRPkg" name = "inMRPkg" class="inputG"> Box/10kg
    <input type="submit" value="검색" id="searchBtn"><br><br>
   </form>
   
   <div id="all">
       <div id="d1">
         <table style="width:80%" border="1" style="border-bottom: none;">
            <tr>
               <th>소요량 계산 및 필요량 계산</th>
            </tr>
         </table>
      </div>
      <br>
      
      <%
      PreparedStatement ps = null;
      ResultSet rs = null; //mrp 테이블
      PreparedStatement ps2 = null;
      ResultSet rs2 = null;//배추
      PreparedStatement ps3 = null;
      ResultSet rs3 = null;//무
      PreparedStatement ps4 = null;
      ResultSet rs4 = null;//사과
      PreparedStatement ps5 = null;
      ResultSet rs5 = null;//박스테이프
      PreparedStatement ps6 = null;
      ResultSet rs6 = null;//액젓
      PreparedStatement ps7 = null;
      ResultSet rs7 = null;//마늘
      PreparedStatement ps8 = null;
      ResultSet rs8 = null;//아이스박스
      PreparedStatement ps9 = null;
      ResultSet rs9 = null;//배
      PreparedStatement ps10 = null;
      ResultSet rs10 = null;//고춧가루
      PreparedStatement ps11 = null;
      ResultSet rs11 = null;//소금
      PreparedStatement ps12 = null;
      ResultSet rs12 = null;//젓갈
      PreparedStatement ps13 = null;
      ResultSet rs13 = null;//비닐
      
 
      String product_no = null; // 품목코드 넣는 변수
      
      //수량
      int rd_num = 0;//무 
      int cb_num = 0;//배추
      int ap_num = 0;//사과
      int bt_num = 0;//박스테이프
      int fs_num = 0;//액젓
      int ga_num = 0;//마늘
      int ib_num = 0;//아이스박스
      int pe_num = 0;//배
      int rp_num = 0;//고춧가루
      int sa_num = 0;//소금
      int sf_num = 0;//액젓
      int vi_num = 0;//비닐
      
      //규격
      int cb_st = 0;//배추
      int rd_st = 0;//무
      int ap_st = 0;//사과
      int bt_st = 0;//박스테이프
      int fs_st = 0;//액젓
      int ga_st = 0;//마늘
      int ib_st = 0;//아이스박스
      int pe_st = 0;//배
      int rp_st = 0;//고춧가루
      int sa_st = 0;//소금
      int sf_st = 0;//액젓
      int vi_st = 0;//비닐
      
      try{
             Class.forName("com.mysql.cj.jdbc.Driver");
             
             String jdbcUrl = "jdbc:mysql://localhost:3306/purchasing_manage?serverTimezone=UTC";
             String dbid = "root";
             String dbpass="1234";
             
             Connection conn = DriverManager.getConnection(jdbcUrl, dbid, dbpass);
             
             System.out.println("Success");
             
             String product = request.getParameter("product");
             System.out.println(product);
             if(product == null){
                product = "0";
             }
             
           String mrp_kg= request.getParameter("inMRPkg");
           if(mrp_kg == null){
              mrp_kg  = "1";
           }
           int kg = Integer.parseInt(mrp_kg);
           System.out.println(mrp_kg);
           System.out.println(kg);
           
           for(int i = 0;i<12;i++){
               switch(i){
               case 0:
                  product_no = "CB"; //배추
                  String sql2 = "select * from initialstock where product_no ='" + product_no + "';";
                  System.out.println(sql2);
                  ps2 = conn.prepareStatement(sql2);
                    rs2 = ps2.executeQuery(sql2);
                    while(rs2.next()){
                    cb_num = rs2.getInt("product_amount");
                    System.out.println(cb_num);
                    cb_st = rs2.getInt("product_standard");
                    System.out.println(cb_st);
                    }
                    break;
               
                 case 1: 
                 product_no = "RD"; //무
                 String sql3 = "select * from initialstock where product_no ='" + product_no + "';";
                 ps3 = conn.prepareStatement(sql3);
                   rs3 = ps3.executeQuery(sql3);
                   while(rs3.next()){
                    rd_num = rs3.getInt("product_amount");
                     System.out.println(rd_num);
                     rd_st = rs3.getInt("product_standard");
                     System.out.println(rd_st);
                   }
                   break;
                
                 case 2: 
                 product_no = "AP"; //사과
                 String sql4 = "select * from initialstock where product_no ='" + product_no + "';";
               ps4 = conn.prepareStatement(sql4);
                rs4 = ps4.executeQuery(sql4);
                   while(rs4.next()){
                      ap_num = rs4.getInt("product_amount");
                        System.out.println(ap_num);
                        ap_st = rs4.getInt("product_standard");
                        System.out.println(ap_st);
                   }
                   break;
                   
                 case 3: 
                    product_no = "BT"; //박스테이프
                     String sql5 = "select * from initialstock where product_no ='" + product_no + "';";
                   ps5 = conn.prepareStatement(sql5);
                    rs5 = ps5.executeQuery(sql5);
                       while(rs5.next()){
                          bt_num = rs5.getInt("product_amount");
                            System.out.println(bt_num);
                            bt_st = rs5.getInt("product_standard");
                            System.out.println(bt_st);
                       }
                   break;
                   
                 case 4: 
                    product_no = "FS"; //액젓
                     String sql6 = "select * from initialstock where product_no ='" + product_no + "';";
                   ps6 = conn.prepareStatement(sql6);
                    rs6 = ps6.executeQuery(sql6);
                       while(rs6.next()){
                          fs_num = rs6.getInt("product_amount");
                            System.out.println(fs_num);
                            fs_st = rs6.getInt("product_standard");
                            System.out.println(fs_st);
                       }
                   break;

                 case 5: 
                    product_no = "GA"; //마늘
                     String sql7 = "select * from initialstock where product_no ='" + product_no + "';";
                   ps7 = conn.prepareStatement(sql7);
                    rs7 = ps7.executeQuery(sql7);
                       while(rs7.next()){
                          ga_num = rs7.getInt("product_amount");
                            System.out.println(ga_num);
                            ga_st = rs7.getInt("product_standard");
                            System.out.println(ga_st);
                       }
                   break;

                 case 6: 
                    product_no = "IB"; //아이스박스
                     String sql8 = "select * from initialstock where product_no ='" + product_no + "';";
                   ps8 = conn.prepareStatement(sql8);
                    rs8 = ps8.executeQuery(sql8);
                       while(rs8.next()){
                          ib_num = rs8.getInt("product_amount");
                            System.out.println(ib_num);
                            ib_st = rs8.getInt("product_standard");
                            System.out.println(ib_st);
                       }
                   break;

                 case 7: 
                    product_no = "PE"; //배
                     String sql9 = "select * from initialstock where product_no ='" + product_no + "';";
                   ps9 = conn.prepareStatement(sql9);
                    rs9 = ps9.executeQuery(sql9);
                       while(rs9.next()){
                          pe_num = rs9.getInt("product_amount");
                            System.out.println(pe_num);
                            pe_st = rs9.getInt("product_standard");
                            System.out.println(pe_st);
                       }
                   break;
                   
                 case 8: 
                    product_no = "RP"; //고춧가루
                     String sql10 = "select * from initialstock where product_no ='" + product_no + "';";
                   ps10 = conn.prepareStatement(sql10);
                    rs10 = ps10.executeQuery(sql10);
                       while(rs10.next()){
                          rp_num = rs10.getInt("product_amount");
                            System.out.println(rp_num);
                            rp_st = rs10.getInt("product_standard");
                            System.out.println(rp_st);
                       }
                   break;
                   
                 case 9: 
                    product_no = "SA"; //소금
                     String sql11 = "select * from initialstock where product_no ='" + product_no + "';";
                   ps11 = conn.prepareStatement(sql11);
                    rs11 = ps11.executeQuery(sql11);
                       while(rs11.next()){
                          sa_num = rs11.getInt("product_amount");
                            System.out.println(sa_num);
                            sa_st = rs11.getInt("product_standard");
                            System.out.println(sa_st);
                       }
                   break;
                   
                 case 10: 
                    product_no = "SF"; //젓갈
                     String sql12 = "select * from initialstock where product_no ='" + product_no + "';";
                   ps12 = conn.prepareStatement(sql12);
                    rs12 = ps12.executeQuery(sql12);
                       while(rs12.next()){
                          sf_num = rs12.getInt("product_amount");
                            System.out.println(sf_num);
                            sf_st = rs12.getInt("product_standard");
                            System.out.println(sf_st);
                       }
                   break;

                 case 11: 
                    product_no = "VI"; //비닐
                     String sql13 = "select * from initialstock where product_no ='" + product_no + "';";
                   ps13 = conn.prepareStatement(sql13);
                    rs13 = ps13.executeQuery(sql13);
                       while(rs13.next()){
                          vi_num = rs13.getInt("product_amount");
                            System.out.println(vi_num);
                            vi_st = rs13.getInt("product_standard");
                            System.out.println(vi_st);
                       }
                   break;
            
                   default:
                      break;
                 
           
               }
            }
               

       if(product.equals("1")){
              String sql = "SELECT * FROM mrp where mrp_id = 'CB' ;";
              ps = conn.prepareStatement(sql);
              rs = ps.executeQuery(sql);
              while(rs.next()){
                 int main = rs.getInt("main") * kg;
                  double salt = ((double)rs.getInt("salt")*(double)kg*0.001);
                  double garlic = (double)rs.getInt("garlic")*(double)kg*0.001;
                  int pear = rs.getInt("pear") * kg;
                  int apple = rs.getInt("apple") * kg;
                  double pepper_powder = (double)rs.getInt("peppper_powder")*(double)kg*0.001;
                  double salted_seafood = (double)rs.getInt("salted_seafood")*(double)kg*0.001;
                  double fish_sauce = (double)rs.getInt("fish_sauce")*(double)kg*0.001; 
                  int icebox = rs.getInt("icebox")* kg;
                  int vinly = rs.getInt("vinly") * kg;
                  int boxtape = rs.getInt("boxtape") * kg;
       %> 
             
      <div id="d2">
          <table width="80%" height="100" border="0" cellpadding="0" cellspacing="0">

            <tr>
               <td>
               <table width="100%"  border="1">
                        
                        <tr>
                              <th colspan="11">총 소요량</th>      
                        </tr>
                        <tr>
                              <th colspan="11">배추김치</th>      
                        </tr>
                     
                        <tr>
                              <th colspan="2">절인배추</th>
                               <th colspan="6">김치양념</th>
                             <th colspan="3">포장재료</th>
                        </tr>
                             <tr>
                        
                              <td>배추<br><b><%=main %>KG</b></td>
                              <td>소금<br><b><%=String.format("%.2f", salt) %>KG</b></td>      
                              <td>마늘<br><b><%=String.format("%.2f", garlic) %>KG</b></td>
                               <td>배<br><b><%=pear %>개</b></td>
                              <td>사과<br><b><%=apple %>개</b></td>      
                              <td>고춧가루<br><b><%=String.format("%.2f", pepper_powder)%>KG</b></td>
                               <td>젓갈<br><b><%=String.format("%.2f", salted_seafood) %>KG</b></td>
                              <td>액젓<br><b><%=String.format("%.2f", fish_sauce) %>KG</b></td>      
                              <td>아이스박스<br><b><%=icebox %>개</b></td>
                               <td>비닐<br><b><%=vinly %>개</b></td>
                              <td>박스테이프<br><b><%=boxtape %>m</b></td>
                        </tr>
                        
                     </table>
                        

                     
                     <br><br>
                    <!--  <hr>가로줄 -->
                     <br><br>
                     <table style="width:100%" border="1">
                        
                        <tr>
                        	<th colspan="11">필요량</th>
                        </tr>
                        <tr>
                              <th colspan="11">배추김치</th>      
                          </tr>
                          
                        <tr>
                              <th colspan="2">절인배추</th>
                              <th colspan="6">김치양념</th>
                              <th colspan="3">포장재료</th>
                        </tr>
<%
int ph_main = main - (cb_num * cb_st);
if(ph_main < 0)
   ph_main = 0;
   
double ph_salt = salt - (sa_num * sa_st);
if(ph_salt < 0)
   ph_salt = 0;

double ph_garlic = garlic - (ga_num * ga_st);
if(ph_garlic < 0)
   ph_garlic = 0;

int ph_pear = pear - (pe_num * pe_st);
if(ph_pear < 0) 
   ph_pear = 0;

int ph_apple = apple - (ap_num * ap_st);
if(ph_apple < 0) 
   ph_apple = 0;

double ph_pepper_powder = pepper_powder - (rp_num * rp_st);
if(ph_pepper_powder < 0)
   ph_pepper_powder = 0;

double ph_salted_seafood = salted_seafood - (sf_num * sf_st);
if(ph_salted_seafood < 0)
   ph_salted_seafood = 0;

double ph_fish_sauce = fish_sauce - (fs_num * fs_st);
if(ph_fish_sauce < 0)
   ph_fish_sauce = 0;

int ph_icebox = icebox - (ib_num * ib_st);
if(ph_icebox < 0) 
   ph_icebox = 0;

int ph_vinly = vinly - (vi_num * vi_st);
if(ph_vinly < 0) 
   ph_vinly = 0;

int ph_boxtape = boxtape - (bt_num * bt_st);
if(ph_boxtape < 0) 
   ph_boxtape = 0;

//unit amount 계산
//main
int ph_main_box = 0;
if(ph_main == 0){
   ph_main_box = 0;
}
else if(ph_main % 10 == 0){
   ph_main_box = ph_main / 10;
}
else if(ph_main % 10 != 0){
   ph_main_box = (ph_main / 10) + 1 ; 
}

//소금
int ph_salt_box = 0;
if(ph_salt == 0){
   ph_salt_box = 0;
}
else if(ph_salt % 5 == 0){
   ph_salt_box = (int)(ph_salt / 5);
}
else if(ph_salt % 5 != 0){
   ph_salt_box = (int)(ph_salt / 5) + 1 ; 
}

//마늘
int ph_garlic_box = 0;
if(ph_garlic == 0){
   ph_garlic_box = 0;
}
else{
   ph_garlic_box = (int)(ph_garlic / 1);
}

//배
int ph_pear_box = 0;
if(ph_pear == 0){
   ph_pear_box = 0;
}
else if(ph_pear % 5 == 0){
   ph_pear_box = ph_pear / 5;
}
else if(ph_pear % 5 != 0){
   ph_pear_box = (ph_pear / 5) + 1 ; 
}

//사과
int ph_apple_box = 0;
if(ph_apple == 0){
   ph_apple_box = 0;
}
else if(ph_apple % 5 == 0){
   ph_apple_box = ph_apple / 5;
}
else if(ph_apple % 5 != 0){
   ph_apple_box = (ph_apple / 5) + 1 ; 
}

//고춧가루
int ph_pepper_powder_box = 0;
if(ph_pepper_powder == 0){
   ph_pepper_powder_box = 0;
}
else if(ph_pepper_powder % 10 == 0){
   ph_pepper_powder_box = (int)(ph_pepper_powder / 10);
}
else if(ph_pepper_powder % 5 != 0){
   ph_pepper_powder_box = (int)(ph_pepper_powder / 10) + 1 ; 
}


//젓갈
int ph_salted_seafood_box = 0;
if(ph_salted_seafood == 0){
   ph_salted_seafood_box = 0;
}
else if(ph_salted_seafood % 5 == 0){
   ph_salted_seafood_box = (int)(ph_salted_seafood / 5);
}
else if(ph_salted_seafood % 5 != 0){
   ph_salted_seafood_box = (int)(ph_salted_seafood / 5) + 1 ; 
}

//액젓
int ph_fish_sauce_box = 0;
if(ph_fish_sauce == 0){
   ph_fish_sauce_box = 0;
}
else if(ph_fish_sauce % 5 == 0){
   ph_fish_sauce_box = (int)(ph_fish_sauce / 5);
}
else if(ph_fish_sauce % 5 != 0){
   ph_fish_sauce_box = (int)(ph_fish_sauce / 5) + 1 ; 
}

//아이스박스
int ph_icebox_box = 0;
if(ph_icebox == 0){
   ph_icebox_box = 0;
}
else if(ph_icebox % 15 == 0){
   ph_icebox_box = ph_icebox / 15;
}
else if(ph_icebox % 15 != 0){
   ph_icebox_box = (ph_icebox / 15) + 1 ; 
}

//비닐
int ph_vinly_box = 0;
if(ph_vinly == 0){
   ph_vinly_box = 0;
}
else if(ph_vinly % 50 == 0){
   ph_vinly_box = ph_vinly / 50;
}
else if(ph_vinly % 50 != 0){
   ph_vinly_box = (ph_vinly / 50) + 1 ; 
}

//박스테이프
int ph_boxtape_box = 0;
if(ph_boxtape == 0){
   ph_boxtape_box = 0;
}
else if(ph_boxtape % 30 == 0){
   ph_boxtape_box = ph_boxtape / 30;
}
else if(ph_boxtape % 30 != 0){
   ph_boxtape_box = (ph_boxtape / 30) + 1 ; 
}

%>
                        <tr>
                              <td>배추<br><b><%=ph_main %>KG<br><%=ph_main_box %>Box</b></td>
                              <td>소금<br><b><%=ph_salt %>KG<br><%=ph_salt_box %>Box</b></td>      
                              <td>마늘<br><b><%=ph_garlic %>KG<br><%=ph_garlic_box %>Box</b></td>
                               <td>배<br><b><%=ph_pear %>개<br><%=ph_pear_box %>Box</b></td>
                              <td>사과<br><b><%=ph_apple %>개<br><%=ph_apple_box %>Box</b></td>      
                              <td>고춧가루<br><b><%=ph_pepper_powder %>KG<br><%=ph_pepper_powder_box %>Box</b></td>
                               <td>젓갈<br><b><%=ph_salted_seafood %>KG<br><%=ph_salted_seafood_box %>Box</b></td>
                              <td>액젓<br><b><%=ph_fish_sauce %>KG<br><%=ph_fish_sauce_box %>Box</b></td>      
                              <td>아이스박스<br><b><%=ph_icebox %>개<br><%=ph_icebox_box %>Box</b></td>
                               <td>비닐<br><b><%=ph_vinly %>개<br><%=ph_vinly_box %>Box</b></td>
                              <td>박스테이프<br><b><%=ph_boxtape %>m<br><%=ph_boxtape_box %>Box</b></td>

                        </tr>
                     </table>
               </td>
            </tr>
         </table>
      </div>
<%
              }
}
      else if(product.equals("2")){
             String sql = "SELECT * FROM mrp where mrp_id = 'RD';";
             ps = conn.prepareStatement(sql);
             rs = ps.executeQuery(sql);
          while(rs.next()){
             int main = rs.getInt("main") * kg;
              double salt = (double)rs.getInt("salt")*(double)kg*0.001 ;
              double garlic = (double)rs.getInt("garlic")*(double)kg*0.001;
              int pear = rs.getInt("pear") * kg;
              int apple = rs.getInt("apple") * kg;
              double pepper_powder = (double)rs.getInt("peppper_powder")*(double)kg*0.001;
              double salted_seafood = (double)rs.getInt("salted_seafood")*(double)kg*0.001;
              double fish_sauce = (double)rs.getInt("fish_sauce")*(double)kg*0.001; 
              int icebox = rs.getInt("icebox")* kg;
              int vinly = rs.getInt("vinly") * kg;
              int boxtape = rs.getInt("boxtape") * kg;
       %>
      <div id="d3">
          <table width="80%" height="100" cellpadding="0" cellspacing="0">

            <tr>
               <td>
               <table style="width:100%;"  border="1">
                     
                     <tr>
                     	<th colspan="11">총 소요량</th>
                     </tr>
                     <tr>
                              <th colspan="11">깍두기</th>      
                        </tr>
                     
                        <tr>
                              <th colspan="2">절인무</th>
                               <th colspan="6">김치양념</th>
                             <th colspan="3">포장재료</th>
                        </tr>
                     
                        <tr>
                              <td>무<br><b><%=main %>KG</b></td>
                              <td>소금<br><b><%=String.format("%.2f", salt) %>KG</b></td>      
                              <td>마늘<br><b><%=String.format("%.2f", garlic) %>KG</b></td>
                               <td>배<br><b><%=pear %>개</b></td>
                              <td>사과<br><b><%=apple %>개</b></td>      
                              <td>고춧가루<br><b><%=String.format("%.2f", pepper_powder)%>KG</b></td>
                               <td>젓갈<br><b><%=String.format("%.2f", salted_seafood) %>KG</b></td>
                              <td>액젓<br><b><%=String.format("%.2f", fish_sauce) %>KG</b></td>      
                              <td>아이스박스<br><b><%=icebox %>개</b></td>
                               <td>비닐<br><b><%=vinly %>개</b></td>
                              <td>박스테이프<br><b><%=boxtape %>m</b></td>
                        </tr>
                     </table>
                     
                     <br><br>
                     <!-- <hr>가로줄 -->
                     <br><br>
                     <table style="width:100%" border="1">
                        
                        <tr>
                        	<th colspan="11">필요량</th>
                        </tr>
                        <tr>
                              <th colspan="11">깍두기</th>      
                          </tr>
                          
                        <tr>
                              <th colspan="2">절인무</th>
                               <th colspan="6">김치양념</th>
                               <th colspan="3">포장재료</th>
                        </tr>
                        <%
int ph_main = main - (rd_num * rd_st);
if(ph_main < 0)
   ph_main = 0;
   
double ph_salt = salt - (sa_num * sa_st);
if(ph_salt < 0)
   ph_salt = 0;

double ph_garlic = garlic - (ga_num * ga_st);
if(ph_garlic < 0)
   ph_garlic = 0;

int ph_pear = pear - (pe_num * pe_st);
if(ph_pear < 0) 
   ph_pear = 0;

int ph_apple = apple - (ap_num * ap_st);
if(ph_apple < 0) 
   ph_apple = 0;

double ph_pepper_powder = pepper_powder - (rp_num * rp_st);
if(ph_pepper_powder < 0)
   ph_pepper_powder = 0;

double ph_salted_seafood = salted_seafood - (sf_num * sf_st);
if(ph_salted_seafood < 0)
   ph_salted_seafood = 0;

double ph_fish_sauce = fish_sauce - (fs_num * fs_st);
if(ph_fish_sauce < 0)
   ph_fish_sauce = 0;

int ph_icebox = icebox - (ib_num * ib_st);
if(ph_icebox < 0) 
   ph_icebox = 0;

int ph_vinly = vinly - (vi_num * vi_st);
if(ph_vinly < 0) 
   ph_vinly = 0;

int ph_boxtape = boxtape - (bt_num * bt_st);
if(ph_boxtape < 0) 
   ph_boxtape = 0;

//unit amount 계산
//main
int ph_main_box = 0;
if(ph_main == 0){
   ph_main_box = 0;
}
else if(ph_main % 10 == 0){
   ph_main_box = ph_main / 10;
}
else if(ph_main % 10 != 0){
   ph_main_box = (ph_main / 10) + 1 ; 
}

//소금
int ph_salt_box = 0;
if(ph_salt == 0){
   ph_salt_box = 0;
}
else if(ph_salt % 5 == 0){
   ph_salt_box = (int)(ph_salt / 5);
}
else if(ph_salt % 5 != 0){
   ph_salt_box = (int)(ph_salt / 5) + 1 ; 
}

//마늘
int ph_garlic_box = 0;
if(ph_garlic == 0){
   ph_garlic_box = 0;
}
else{
   ph_garlic_box = (int)(ph_garlic / 1);
}

//배
int ph_pear_box = 0;
if(ph_pear == 0){
   ph_pear_box = 0;
}
else if(ph_pear % 5 == 0){
   ph_pear_box = ph_pear / 5;
}
else if(ph_pear % 5 != 0){
   ph_pear_box = (ph_pear / 5) + 1 ; 
}

//사과
int ph_apple_box = 0;
if(ph_apple == 0){
   ph_apple_box = 0;
}
else if(ph_apple % 5 == 0){
   ph_apple_box = ph_apple / 5;
}
else if(ph_apple % 5 != 0){
   ph_apple_box = (ph_apple / 5) + 1 ; 
}

//고춧가루
int ph_pepper_powder_box = 0;
if(ph_pepper_powder == 0){
   ph_pepper_powder_box = 0;
}
else if(ph_pepper_powder % 10 == 0){
   ph_pepper_powder_box = (int)(ph_pepper_powder / 10);
}
else if(ph_pepper_powder % 5 != 0){
   ph_pepper_powder_box = (int)(ph_pepper_powder / 10) + 1 ; 
}


//젓갈
int ph_salted_seafood_box = 0;
if(ph_salted_seafood == 0){
   ph_salted_seafood_box = 0;
}
else if(ph_salted_seafood % 5 == 0){
   ph_salted_seafood_box = (int)(ph_salted_seafood / 5);
}
else if(ph_salted_seafood % 5 != 0){
   ph_salted_seafood_box = (int)(ph_salted_seafood / 5) + 1 ; 
}

//액젓
int ph_fish_sauce_box = 0;
if(ph_fish_sauce == 0){
   ph_fish_sauce_box = 0;
}
else if(ph_fish_sauce % 5 == 0){
   ph_fish_sauce_box = (int)(ph_fish_sauce / 5);
}
else if(ph_fish_sauce % 5 != 0){
   ph_fish_sauce_box = (int)(ph_fish_sauce / 5) + 1 ; 
}

//아이스박스
int ph_icebox_box = 0;
if(ph_icebox == 0){
   ph_icebox_box = 0;
}
else if(ph_icebox % 15 == 0){
   ph_icebox_box = ph_icebox / 15;
}
else if(ph_icebox % 15 != 0){
   ph_icebox_box = (ph_icebox / 15) + 1 ; 
}

//비닐
int ph_vinly_box = 0;
if(ph_vinly == 0){
   ph_vinly_box = 0;
}
else if(ph_vinly % 50 == 0){
   ph_vinly_box = ph_vinly / 50;
}
else if(ph_vinly % 50 != 0){
   ph_vinly_box = (ph_vinly / 50) + 1 ; 
}

//박스테이프
int ph_boxtape_box = 0;
if(ph_boxtape == 0){
   ph_boxtape_box = 0;
}
else if(ph_boxtape % 30 == 0){
   ph_boxtape_box = ph_boxtape / 30;
}
else if(ph_boxtape % 30 != 0){
   ph_boxtape_box = (ph_boxtape / 30) + 1 ; 
}
%>
                        <tr>
                              <td>무<br><b><%=ph_main %>KG<br><%=ph_main_box %>Box</b></td>
                              <td>소금<br><b><%=ph_salt %>KG<br><%=ph_salt_box %>Box</b></td>      
                              <td>마늘<br><b><%=ph_garlic %>KG<br><%=ph_garlic_box %>Box</b></td>
                               <td>배<br><b><%=ph_pear %>개<br><%=ph_pear_box %>Box</b></td>
                              <td>사과<br><b><%=ph_apple %>개<br><%=ph_apple_box %>Box</b></td>      
                              <td>고춧가루<br><b><%=ph_pepper_powder %>KG<br><%=ph_pepper_powder_box %>Box</b></td>
                               <td>젓갈<br><b><%=ph_salted_seafood %>KG<br><%=ph_salted_seafood_box %>Box</b></td>
                              <td>액젓<br><b><%=ph_fish_sauce %>KG<br><%=ph_fish_sauce_box %>Box</b></td>      
                              <td>아이스박스<br><b><%=ph_icebox %>개<br><%=ph_icebox_box %>Box</b></td>
                               <td>비닐<br><b><%=ph_vinly %>개<br><%=ph_vinly_box %>Box</b></td>
                              <td>박스테이프<br><b><%=ph_boxtape %>m<br><%=ph_boxtape_box %>Box</b></td>

                        </tr>
                     </table>
               </td>
            </tr>
         </table>
      </div>
      </div>
                <%} %>                   
                 <%}
      }catch(NumberFormatException e){
         e.printStackTrace();
    %>
         <script>
         swal.fire({
            title : '숫자를 입력하세요',
            icon : 'warning'
         }).then((result) => {
            if(result.isConfirmed) {
               window.history.back();
            }
         })
		</script>
<%
 }

      catch(Exception e){
                              e.printStackTrace();
                              }
                    // finally {
                 //if ( rs != null ) try{rs.close();}catch(Exception e){} 
                  //if ( ps != null ) try{ps.close();}catch(Exception e){}
              //}
                              %>
   </section>
   
   <script type="text/javascript">
    function Check(value){
     if(value.equals("1")){
             document.all["d1"].style.display="none";
           document.all["d2"].style.display="block";
           document.all["d3"].style.display="none";
     }
     
     else if(value.equals("2")) {
        document.all["d1"].style.display="none";
        document.all["d2"].style.display="none";
        document.all["d3"].style.display="block";
     }
     else if{
       document.all["d1"].style.display="block";
     document.all["d2"].style.display="none";
     document.all["d3"].style.display="none";  
     }
    }
    
    

    
   </script>
   
</body>
</html>