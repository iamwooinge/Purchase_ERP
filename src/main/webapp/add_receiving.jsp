<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="income.incomeDAO" %>
<%@page import="income.incomeDAO2" %>
<%@page import="java.util.*" %>
<%@page import="util.DatabaseUtil" %>
<%@page import="java.sql.*" %>

<%@page import="common.common" %>

<!DOCTYPE html>
<script src ="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<!-- bootstrap JS -->
   <script src="https://netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
   
   <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.0.min.js" ></script>

<html>
<head>
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


<title>입고 등록</title>
   <script>   
   
    // html dom 이 다 로딩된 후 실행된다.
    $(document).ready(function(){
        // menu 클래스 바로 하위에 있는 a 태그를 클릭했을때
        $(".menu>a").click(function(){
            var submenu = $(this).next("ul");
 
            // submenu 가 화면상에 보일때는 위로 보드랍게 접고 아니면 아래로 보드랍게 펼치기
            if( submenu.is(":visible") ){
                submenu.slideUp();
            }else{
                submenu.slideDown();
            }
        });
    });
   </script>
<link href = "design.css" rel = "stylesheet" type = "text/css">   

 <!-- Required meta tags tables-->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="table/fonts/icomoon/style.css">
    <link rel="stylesheet" href="table/css/owl.carousel.min.css">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="table/css/bootstrap.min.css">
    <link rel="stylesheet" href="table/css/style.css">

   <link href = "hj.css" rel = "stylesheet" type = "text/css">  
</head>
<body>
<% //로그인 할 때 employ__no를 불러옴
   String employee_id = (String)session.getAttribute("employee_no");
   String name = null;
   String team_code = null;
   String dept_code = null;
   
    if(employee_id == null){
       response.sendRedirect("login.jsp");
    }
    Connection conn_log = DatabaseUtil.getConnection();
    String sql_log = "select employee_name,team_code,dept_code from employee where employee_no = '"+employee_id+"'"; 
    PreparedStatement pstmt_log = conn_log.prepareStatement(sql_log);
   ResultSet rs_log = pstmt_log.executeQuery(sql_log);
   if(rs_log.next()){
      name = rs_log.getString("employee_name");
      team_code = rs_log.getString("team_code");
      dept_code = rs_log.getString("dept_code");
    }
    if(team_code.equals("B")||dept_code.equals("2")){
       %>
       <script>
      alert("접근할 수 없는 페이지 입니다.");
      </script>
       <META http-equiv=refresh content="0;url=main.jsp">

       <%
    }
try{
      
//////////////////////////////////////////////////////////////////////////////////////////////insert1
   String income_no = null;
   String income_return_no = null;
   String employee_no = null;
   String client_name = null;
   String product_name = null;
   String product_no = null; 
   int product_standard = 0;
   String product_unit = null;
   String order_date = null;
   int product_count = 0;
   int product_unitprice = 0;
   int product_supply = 0;
   int order_vat = 0;
   int order_price = 0;
   String income_date = null;
   int income_count = 0;
   String income_state = null;
   String income_category = null;
   
   // 재고 - 재고 테이블 등록
   String stock_no = null;
   int product_amount = 0; // income_count
   String product_type = null; // income_category
   String stock_date = null; // 재고날짜 - 입고날짜
   int stock_all = 0; // 총재고수량
   
   

   //파라미터로 값 넘어갈 때 한글 안깨지게
   request.setCharacterEncoding("utf-8"); 
   ///테이블 파라미터 받아오기
   if(request.getParameter("income_no") != null || request.getParameter("client_name") != null || request.getParameter("product_name") != null || request.getParameter("product_standard") !=null || request.getParameter("product_unit") != null || request.getParameter("order_date") != null || request.getParameter("product_count") != null || request.getParameter("product_unitprice") != null || request.getParameter("product_supply") != null || request.getParameter("order_vat") != null || request.getParameter("order_price") != null || request.getParameter("income_count") != null || request.getParameter("income_category") != null){
      
      income_no = request.getParameter("income_no");
      employee_no = request.getParameter("employee_no");
      client_name = request.getParameter("client_name");
      
      // input에 품명 입력했지만, db 상에서는 품번이 입력되어야 하므로 처리 
      product_name = request.getParameter("product_name");
      Connection conn = DatabaseUtil.getConnection();
      String sql = "select product_no from product where product_name = '"+product_name+"'"; 
      PreparedStatement pstmt = conn.prepareStatement(sql);
      ResultSet rs = pstmt.executeQuery(sql);
      if(rs.next()){product_no = rs.getString("product_no");} 

      
      product_standard = Integer.parseInt(request.getParameter("product_standard").trim());
      product_unit = request.getParameter("product_unit");
      order_date = request.getParameter("order_date");
      product_count = Integer.parseInt(request.getParameter("product_count").trim());
      product_unitprice = Integer.parseInt(request.getParameter("product_unitprice").trim());
      product_supply = Integer.parseInt(request.getParameter("product_supply").trim());
      order_vat = Integer.parseInt(request.getParameter("order_vat").trim());
      order_price = Integer.parseInt(request.getParameter("order_price").trim());
      income_date = request.getParameter("income_date");
      income_count = Integer.parseInt(request.getParameter("income_count").trim());
      income_category = request.getParameter("income_category");
      
      // 재고 - 재고 테이블 등록
      stock_no = "S"+ income_no;
      product_amount = income_count;
      product_type = request.getParameter("income_category");
      stock_date = request.getParameter("income_date");
      
      if(income_category.equals("정상입고")){
         income_return_no = "M";
      }else if(income_category.equals("반품")){
         income_return_no = "R";
      }else if(income_category.equals("교환입고")){
         income_return_no = "C";
      }else if(income_category.equals("교환출고")){
         income_return_no = "C";
      }
      
      //주문번호 비교해서 입고현황에서 이미 등록된 주문번호+반품일 경우 다시 등록 못하게 /이미 등록된 주문번호+교환출고가 있을경우 교환입고가 등록가능하게 
      /* String categoryCheck = ""; */
   /*       Connection conn_noCategory = DatabaseUtil.getConnection();
      String sql_noCategory ="SELECT income_category from income where income_no = '"+income_no+"';";
      PreparedStatement pstmt_noCategory = conn_noCategory.prepareStatement(sql_noCategory);
      ResultSet rs_noCategory = pstmt_noCategory.executeQuery(sql_noCategory);
      while(rs_noCategory.next()){categoryCheck = rs_noCategory.getString(1);} 
      //rs_noCategory.last();
      int row = rs_noCategory.getRow();
     // rs_noCategory.beforeFirst();
      String[] categoryCheck = new String[rs_noCategory.getRow()+100];
      if(rs_noCategory.next()){
         for(int i=0; rs_noCategory.next(); i++){
           categoryCheck[i] = rs_noCategory.getString("income_category");
           // out.println(categoryCheck[i]);
         }
      } */

      //반품
      Connection conn_noCategory = DatabaseUtil.getConnection();
      String sql_noCategory ="SELECT income_category from income where income_no = '"+income_no+"' and income_category = '반품';";
      PreparedStatement pstmt_noCategory = conn_noCategory.prepareStatement(sql_noCategory);
      ResultSet rs_noCategory = pstmt_noCategory.executeQuery(sql_noCategory);
      
      String categoryCheck = "";
      while(rs_noCategory.next()){
          categoryCheck = rs_noCategory.getString("income_category");
      } 
      
      //정상입고
      Connection conn_noCategory2 = DatabaseUtil.getConnection();
      String sql_noCategory2 ="SELECT income_category from income where income_no = '"+income_no+"' and income_category = '정상입고';";
      PreparedStatement pstmt_noCategory2 = conn_noCategory2.prepareStatement(sql_noCategory2);
      ResultSet rs_noCategory2= pstmt_noCategory2.executeQuery(sql_noCategory2);
      
      String categoryCheck2 = "";
      while(rs_noCategory2.next()){
          categoryCheck2 = rs_noCategory2.getString("income_category");
      } 
      
      //교환출고
      Connection conn_noCategory3 = DatabaseUtil.getConnection();
      String sql_noCategory3 ="SELECT income_category from income where income_no = '"+income_no+"' and income_category = '교환출고';";
      PreparedStatement pstmt_noCategory3 = conn_noCategory2.prepareStatement(sql_noCategory3);
      ResultSet rs_noCategory3= pstmt_noCategory3.executeQuery(sql_noCategory3);
      
      String categoryCheck3 = "";
      while(rs_noCategory3.next()){
          categoryCheck3 = rs_noCategory3.getString("income_category");
      } 
      
      
      //교환입고 입고수량 리셋
      int iCountCheck = 0;
      Connection conn_iCountCheck = DatabaseUtil.getConnection();
      String sql_iCountCheck ="SELECT SUM(CASE WHEN income_count > 0 THEN income_count ELSE NULL END) from income where income_no = '"+income_no+"' and income_category='교환입고';";
      PreparedStatement pstmt_iCountCheck = conn_iCountCheck.prepareStatement(sql_iCountCheck);
      ResultSet rs_iCountCheck = pstmt_iCountCheck.executeQuery(sql_iCountCheck);
      while(rs_iCountCheck.next()){iCountCheck = rs_iCountCheck.getInt(1);} 
      
      //주문번호 비교해서 같은 주문번호면 입고수량을 합친 값을 보여준다
       int countCheck = 0;
       Connection conn_noCheck = DatabaseUtil.getConnection();
       String sql_noCheck = "SELECT SUM(CASE WHEN income_count > 0 THEN income_count ELSE NULL END) from income where income_no = '"+income_no+"';"; //음수 값 제외 계산 위한 sql문
       
       PreparedStatement pstmt_noCheck = conn_noCheck.prepareStatement(sql_noCheck);
       ResultSet rs_noCheck = pstmt_noCheck.executeQuery(sql_noCheck);
       if(rs_noCheck.next()){countCheck = rs_noCheck.getInt(1);} 
       
       
       //교환출고 미입고수량 표시
       int niCountCheck = 0;
       Connection conn_niCountCheck = DatabaseUtil.getConnection();
       String sql_niCountCheck = "select abs(sum(income_count)) from income where income_no = '"+income_no+"' and income_category='교환출고';";
       PreparedStatement pstmt_niCountCheck = conn_niCountCheck.prepareStatement(sql_niCountCheck);
       ResultSet rs_niCountCheck = pstmt_niCountCheck.executeQuery(sql_niCountCheck);
       if(rs_niCountCheck.next()){niCountCheck = rs_niCountCheck.getInt(1);} 
       
       //교환입고 미입고수량 표시
       int niCountCheck2 = 0;
       Connection conn_niCountCheck2 = DatabaseUtil.getConnection();
       String sql_niCountCheck2 = "select abs(sum(income_count)) from income where income_no = '"+income_no+"' and income_category='교환입고';";
       PreparedStatement pstmt_niCountCheck2 = conn_niCountCheck2.prepareStatement(sql_niCountCheck2);
       ResultSet rs_niCountCheck2 = pstmt_niCountCheck2.executeQuery(sql_niCountCheck2);
       if(rs_niCountCheck2.next()){niCountCheck2 = rs_niCountCheck2.getInt(1);} 
       
       
       //반품 수량 처리
       int ciCountCheck = 0;
       Connection conn_ciCountCheck = DatabaseUtil.getConnection();
       String sql_ciCountCheck = "select abs(sum(income_count)) from income where income_no = '"+income_no+"' and income_category='반품';";
       PreparedStatement pstmt_ciCountCheck = conn_ciCountCheck.prepareStatement(sql_ciCountCheck);
       ResultSet rs_ciCountCheck = pstmt_ciCountCheck.executeQuery(sql_ciCountCheck);
       if(rs_ciCountCheck.next()){ciCountCheck = rs_ciCountCheck.getInt(1);} 
       
       // 재고 - 총 재고수량 구하기
       int cnt_stock = 0;
       int stock_all_cnt = 0;
       String sql_stock = "select sum(product_amount) from stock where product_no ='" + product_no + "'";
       Connection conn2 = DatabaseUtil.getConnection();
       PreparedStatement pstmt2 = conn2.prepareStatement(sql_stock);
       ResultSet rs2 = pstmt2.executeQuery(sql_stock);
       
       if(rs2.next()){
          cnt_stock = rs2.getInt(1);
          stock_all_cnt = cnt_stock;
          
       }
       stock_all = stock_all_cnt + income_count;


       incomeDAO incomeDAO = new incomeDAO(); 
       incomeDAO2 incomeDAO2 = new incomeDAO2();
       
       
       if(income_category.equals("반품")){ //입고 유형이 [반품]일 때 미입고 수량 = 0으로 처리
             
             income_state = ""; //반품/교환출고 일 경우에는 입고 유형을 빈칸으로?
               
             if(product_count >= Math.abs(income_count)+ciCountCheck){
                   // [반품]을 한 번에 등록하지 않고 여러번에 걸쳐서 등록 할 경우 주문수량과 미입고수량 비교 
                       if(!categoryCheck2.isEmpty()){ // 정상입고 건이 있는 경우에만 반품 가능
                         incomeDAO.income(0,income_no, income_return_no, employee_id , client_name, product_no , product_standard, product_unit, order_date, product_count, product_unitprice, product_supply, order_vat, order_price, income_date ,income_count,0, income_state,income_category);    
                          incomeDAO2.stock(0, stock_no, product_no, product_standard, product_unit, product_amount, product_type, stock_date, stock_all);
                            out.println("<script>alert('반품 저장 완료');</script>");
                           
                       }else{out.println("<script>alert('같은 주문번호로 처리 된 정상입고 건이 존재하지 않아 반품이 불가능합니다.');</script>");}
             }else{ out.println("<script>alert('반품 수량을 초과했습니다.');</script>");}   

             
       }else if(income_category.equals("교환출고")){ //입고 유형이 [교환출고]일 때 미입고 수량 = 입고수량 절댓값+ db에 등록되어 있는 교환출고들 합의 절댓값 (Math.abs(income_count)+niCountCheck)
          
            
           if(categoryCheck.isEmpty()){  
              income_state = "미입고";
              if(product_count >= Math.abs(income_count)+niCountCheck){ //[교환출고]를 한 번에 등록하지 않고 여러번에 걸쳐서 등록 할 경우 입고수량과 입력한 주문번호의 입고수량 합 비교  
                   incomeDAO.income(0,income_no, income_return_no, employee_id , client_name, product_no , product_standard, product_unit, order_date, product_count, product_unitprice, product_supply, order_vat, order_price, income_date ,income_count, Math.abs(income_count)+niCountCheck, income_state,income_category);    
                   incomeDAO2.stock(0, stock_no, product_no, product_standard, product_unit, product_amount, product_type, stock_date, stock_all);
                  out.println("<script>alert('교환출고 저장 완료');</script>");
                }else{out.println("<script>alert('교환 수량을 초과했습니다.');</script>");}
           }else{
              out.println("<script>alert('이미 반품 처리된 주문번호 입니다.');</script>");  
           }   
             
       }else if(income_category.equals("교환입고")){
          if(!categoryCheck3.isEmpty()){
             if(product_count > iCountCheck+income_count){  
                      income_state = "미입고";
                                         
                      if(income_count >= 0){ //반드시 양수로 입력
                            if(categoryCheck.isEmpty()){
                                incomeDAO.income(0,income_no, income_return_no, employee_id , client_name, product_no , product_standard, product_unit, order_date, product_count, product_unitprice, product_supply, order_vat, order_price, income_date ,income_count,product_count-(income_count+niCountCheck2), income_state,income_category);    
                                incomeDAO2.stock(0, stock_no, product_no, product_standard, product_unit, product_amount, product_type, stock_date, stock_all);
                                out.println("<script>alert('교환 입고 저장 완료');</script>");
                            }else{ out.println("<script>alert('이미 반품 처리된 주문번호 입니다.');</script>");}   
                        
                      }else {out.println("<script>alert('음수를 입력할 수 없습니다.');</script>");}
   
   
                 }else if(product_count == iCountCheck+income_count){  //주문수량보다 미입고수량이 같을 경우 [입고]
                   income_state = "입고";
                      
                   if(income_count >= 0){
                         if(categoryCheck.isEmpty()){
                             incomeDAO.income(0,income_no, income_return_no, employee_id , client_name, product_no , product_standard, product_unit, order_date, product_count, product_unitprice, product_supply, order_vat, order_price, income_date ,income_count,product_count-(income_count+niCountCheck2), income_state,income_category);    
                             incomeDAO2.stock(0, stock_no, product_no, product_standard, product_unit, product_amount, product_type, stock_date, stock_all);
                             out.println("<script>alert('교환입고 저장 완료');</script>");
                         }else{ out.println("<script>alert('이미 반품 처리된 주문번호 입니다.');</script>");}   
                     
                   }else{out.println("<script>alert('음수를 입력할 수 없습니다.');</script>");}
   
                   
                 }else{
                        out.println("<script>alert('교환입고수량을 초과하셨습니다.');</script>");
                  }    
          }else{out.println("<script>alert('같은 주문번호로 등록된 교환출고 건이 없습니다.');</script>");}
          

       }else if(income_category.equals("정상입고")){ // 입고유형이 [정상입고]일 때 미입고 수량 = 주문수량 -(입력한 주문번호의 입고수량 합 + 입고 수량)
                if(product_count > countCheck+income_count){  //[정상입고/교환입고]를 한 번에 등록하지 않고 여러번에 걸쳐서 등록 할 경우 주문수량과 미입고수량 비교 후 입고상태 넣음 주문수량보다 미입고수량이 적을 경우 [미입고]
                   income_state = "미입고";
                                      
                   if(income_count >= 0){ //반드시 양수로 입력
                         if(categoryCheck.isEmpty()){
                             incomeDAO.income(0,income_no, income_return_no, employee_id , client_name, product_no , product_standard, product_unit, order_date, product_count, product_unitprice, product_supply, order_vat, order_price, income_date ,income_count,product_count-(countCheck+income_count), income_state,income_category);    
                             incomeDAO2.stock(0, stock_no, product_no, product_standard, product_unit, product_amount, product_type, stock_date, stock_all);
                             out.println("<script>alert('정상 입고 저장 완료');</script>");
                         }else{ out.println("<script>alert('이미 반품 처리된 주문번호 입니다.');</script>");}   
                     
                   }else {out.println("<script>alert('음수를 입력할 수 없습니다.');</script>");}
   
   
                 }else if(product_count == countCheck+income_count){  //주문수량보다 미입고수량이 같을 경우 [입고]
                   income_state = "입고";
                      
                   if(income_count >= 0){
                      if(categoryCheck.isEmpty()){
                          incomeDAO.income(0,income_no, income_return_no, employee_id , client_name, product_no , product_standard, product_unit, order_date, product_count, product_unitprice, product_supply, order_vat, order_price, income_date ,income_count,product_count-(countCheck+income_count), income_state,income_category);    
                          incomeDAO2.stock(0, stock_no, product_no, product_standard, product_unit, product_amount, product_type, stock_date, stock_all);
                          out.println("<script>alert('정상 입고 저장 완료');</script>");
                      }else{ out.println("<script>alert('이미 반품 처리된 주문번호 입니다.');</script>");}   
                     
                   }else{out.println("<script>alert('음수를 입력할 수 없습니다.');</script>");}
   
                   
                 }else{
                     if(!categoryCheck.isEmpty()){
                         out.println("<script>alert('이미 반품 처리된 주문번호 입니다.');</script>");
                      }else{
                           out.println("<script>alert('주문수량을 초과하셨습니다.');</script>");
                      }
                  }    
           
        }
       
       } 

   
  }catch(Exception e){}finally {} 
    
%>
        
  <!-- 화면 최상단 메뉴 코드  --> 
  <!-- Back to top button -->
  <div class="back-to-top"></div>

  <header>
    <div class="top-bar">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-md-8">
            <div class="d-inline-block">
              <span class="mai-mail fg-primary"></span> <a href="mailto:contact@mail.com">kimchimyeongga@mail.com</a>
            </div>
            <div class="d-inline-block ml-2">
              <span class="mai-call fg-primary"></span> <a href="tel:+0011223495">02-303-7777</a>
            </div>
          </div>
          <div class="col-md-4 text-right d-none d-md-block">
            <div class="social-mini-button">
		      <%=name %>님이 로그인하셨습니다. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <!--로그인 후 누가 로그인하였는지 표시-->
			  <a href="http://localhost:8080/purchase_ERP/main.jsp">로그아웃</a>
            </div>
          </div>
        </div>
      </div> <!-- .container -->
    </div> <!-- .top-bar -->
    
    <!-- 화면 상단 메뉴 코드  -->

    <nav class="navbar navbar-expand-lg navbar-light">
      <div class="container">
        <a href="./main.jsp" class="navbar-brand">서대문<span class="text-primary">김치명가</span></a>

        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarContent" aria-controls="navbarContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>

        <div class="navbar-collapse collapse" id="navbarContent">
          <ul class="navbar-nav ml-auto pt-3 pt-lg-0">
            <li class="nav-item">
              <a href="http://localhost:8080/purchase_ERP/main.jsp" class="nav-link">영업</a>
            </li>
            <li class="nav-item">
              <a href="http://localhost:8080/purchase_ERP/main.jsp" class="nav-link">생산</a>
            </li>
            <li class="nav-item">
              <a href="http://localhost:8080/purchase_ERP/add_billing.jsp" class="nav-link" >구매자재</a>
            </li>
            <li class="nav-item">
              <a href="http://localhost:8080/purchase_ERP/main.jsp" class="nav-link">인사급여</a>
            </li>
            <li class="nav-item">
              <a href="http://localhost:8080/purchase_ERP/main.jsp" class="nav-link">마이페이지</a>
            </li>
          </ul>
        </div>
      </div> <!-- .container -->
    </nav> <!-- .navbar -->
	</header>
	
	
    <!-- 화면 왼쪽 메뉴 코드  -->
	<div class="wrap">
        <ui class="naviMenu">
            <li class="navi" id="claim_menu">
                <a href="#claim_menu" class="menuBtn" return false;>청구</a>
                <div class="subMenu">
                    <a href = "http://localhost:8080/purchase_ERP/add_billing.jsp" >청구 등록</a>
	             <a href = "http://localhost:8080/purchase_ERP/manage_billing.jsp">청구 현황</a>
                </div>
            </li>
            <li class="navi" id="order_menu">
                <a href="#order_menu" class="menuBtn" return false;>발주</a>
                <div class="subMenu">
                    <a href = "http://localhost:8080/purchase_ERP/add_order.jsp">발주 등록</a>
	              <a href = "http://localhost:8080/purchase_ERP/manage_order.jsp">발주 현황</a>
                </div>
            </li>
            <li class="navi" id="income_menu">
                <a href="#income_menu" class="menuBtn" return false;>입고</a>
                <div class="subMenu">
                    <a href = "http://localhost:8080/purchase_ERP/add_receiving.jsp">입고 등록</a>
	               <a href = "http://localhost:8080/purchase_ERP/manage_receiving.jsp">입고 현황</a>
                </div>
            </li>
            <li class="navi" id="stock_menu">
                <a href="#stock_menu" class="menuBtn" return false;>재고</a>
                <div class="subMenu">
                    <a href = "http://localhost:8080/purchase_ERP/add_inventory.jsp">초기재고 등록</a>
	               <a href = "http://localhost:8080/purchase_ERP/manage_inventory.jsp">재고 현황</a>
                </div>
            </li>
        </ui>
    </div>

<!-- 테이블 코드  -->
   <h2 id="title">입고 등록</h2>
  
<form action="./add_receiving.jsp" method="post" id="receive">
<input type = "date" name = "income_date" style="display:none;">
<script>
            var date = new Date();
            var yyyy = date.getFullYear();
            var mm = date.getMonth()+1 > 9 ? date.getMonth()+1 : '0' + date.getMonth()+1;
            var dd = date.getDate() > 9 ? date.getDate() : '0' + date.getDate();
            $("input[type=date]").val(yyyy+"-"+mm+"-"+dd);
</script>
      
   <table border = "1" id="dynamicTable" class="add_column" style="text-align: center; text-color:black;">
   
      <tr>      
            <th id = "mb_td" style="width:110px">주문 번호</th>
            <th id = "mb_td" style="width:110px">입고 유형</th>
            <th id = "mb_td" style="width:110px">거래처명</th>
            <th id = "mb_td" style="width:110px">품명</th>
            <th id = "mb_td" style="width:110px">규격</th>
            <th id = "mb_td" style="width:110px">단위</th>
            <th id = "mb_td" style="width:110px">주문 일자</th>
            <th id = "mb_td" style="width:110px">주문 수량</th>
            <th id = "mb_td" style="width:110px">단가</th>
            <th id = "mb_td" style="width:110px">금액</th>
            <th id = "mb_td" style="width:110px">부가세</th>
            <th id = "mb_td" style="width:110px">총액</th>
            <th id = "mb_td" style="width:110px">입고 수량</th>
            <th id = "mb_td"></th>
      </tr>
	

   </table>

   <!-- <input type = "submit" id ="save_receiving" onclick="ifCountNull()" value = "저장"> -->

  
 </form>
   
  <table style="position:absolute; left:240px; top:300px;">
         <tr>
	        <td><div class="search_btn_billing3"><button id = "order_loading" onclick="showPopup1()">발주 불러오기</button></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	      	<td><div class="search_btn_billing3"><button id = "change_loding" onclick="showPopup2()">반품/교환 불러오기</button></div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
      	</tr>
      </table>
 

<script> //발주 불러오기 팝업으로 불러오는 스크립트 

      
        function showPopup1(){
            window.open("loading_order.jsp","","width=1610, height=650, top=150, left=150");
            
        }
        
        function showPopup2(){
            window.open("loading_returnexchange.jsp","","width=1610, height=650, top=150, left=150");
        }
        
        function ifCountNull(){
          var incomeCount = document.getElementById("income_count");
          var incomeCount2 = document.getElementById("income_count2");
          var incomeCount3 = document.getElementById("income_count3");
          var income_category = document.getElementById("income_category");
          if(incomeCount.value == "" || incomeCount2.value == "" || incomeCount3.value == "" ){ //입고 수량 값이 null값일 때 경고창
             alert("입고수량을 다시 입력해주세요.");
          }
          
          } 
</script>

<iframe name="hframe4" style="display:none;"></iframe><!-- 부모창에 안보이는 iframe을 둬서 팝업 클로즈(크롬) https://blog.naver.com/dkfma4872/220724867357 -->
   <script>   
      <%-- const inputResult = "<%=inputResult%>"
      const inputArr = inputResult.split(" ,"); --%>
      
   function tableCreate(arr) {
   
         var html='';
         var count = 0;
         
         //첫번째 
         html += '<tr>';
         html += '<td> <input type="text" placeholder="주문번호" name="income_no" class="add_input" style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         html += '<td> <select id="income_category" name="income_category" class="add_input" ><option value="정상입고" selected>정상입고</option><option value="반품">반품</option><option value="교환출고">교환출고</option><option value="교환입고">교환입고</option></select></td>';
         count++;
         html += '<td> <input type="text" placeholder="거래처명" name="client_name" class="add_input" style="text-align:right;"value="'+arr[count]+'" readonly></td>';
         count++;
         html += '<td> <input type="text" placeholder="품명" name="product_name" class="add_input" style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         count++;
         html += '<td> <input type="text" placeholder="규격" name="product_standard" class="add_input" style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         count++;
         html += '<td> <input type="text" placeholder="단위" name="product_unit" class="add_input" style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         count++;
         html += '<td> <input type="text" placeholder="주문일자" name="order_date" class="add_input" style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         count++;
         html += '<td> <input type="text" placeholder="주문수량" name="product_count" class="add_input" style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         count++;
         html += '<td> <input type="text" placeholder="단가" name="product_unitprice" class="add_input" style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         count++;
         html += '<td> <input type="text" placeholder="공급가액" name="product_supply" class="add_input"  style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         count++;
         html += '<td> <input type="text" placeholder="부가세" name="order_vat" class="add_input" style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         count++;
         html += '<td> <input type="text" placeholder="금액" name="order_price" class="add_input" style="text-align:right;" value="'+arr[count]+'" readonly></td>';
         html += '<td> <input type="text" placeholder="입고수량" id="income_count" name="income_count" class="add_input" style="text-align:right;" value=""></td>';
         html += '<td><div class="search_btn_billing2"><button id ="save_receiving" onclick="ifCountNull()">저장 </button></div></td>'; 
         html += '</tr>';  
         
   
      $("#dynamicTable").append(html);
      
   }
   
   
   function tableCreate2(arr) {
      
      var html='';
      var count = 0;
      html += '<tr>';
      html += '<td> <input type="text" placeholder="주문번호" name="income_no" value="'+arr[count]+'" class="add_input" style="text-align:right;" ></td>';
      html += '<td> <select id="income_category" name="income_category" class="add_input"><option value="정상입고" selected>정상입고</option><option value="반품">반품</option><option value="교환출고">교환출고</option><option value="교환입고">교환입고</option></select></td>';
      count++;
      html += '<td> <input type="text" placeholder="거래처명" name="client_name" value="'+arr[count]+'" class="add_input" style="text-align:right;" ></td>';
      count++;
      html += '<td> <input type="text" placeholder="품명" name="product_name" value="'+arr[count]+'" class="add_input" style="text-align:right;" ></td>';
      count++;
      html += '<td> <input type="text" placeholder="규격" name="product_standard" value="'+arr[count]+'" class="add_input" style="text-align:right;" ></td>';
      count++;
      html += '<td> <input type="text" placeholder="단위" name="product_unit" value="'+arr[count]+'" class="add_input" style="text-align:right;" ></td>';
      count++;
      html += '<td> <input type="text" placeholder="주문일자" name="order_date" value="'+arr[count]+'" class="add_input" style="text-align:right;" ></td>';
      count++;
      html += '<td> <input type="text" placeholder="주문수량" name="product_count" value="'+Math.abs(arr[count])+'" class="add_input" style="text-align:right;" ></td>';
      count++;
      html += '<td> <input type="text" placeholder="단가" name="product_unitprice" value="'+arr[count]+'" class="add_input" style="text-align:right;" ></td>';
      count++;
      html += '<td> <input type="text" placeholder="공급가액" name="product_supply" value="'+arr[count]+'" class="add_input" style="text-align:right;" ></td>';
      count++;
      html += '<td> <input type="text" placeholder="부가세" name="order_vat" value="'+arr[count]+'" class="add_input" style="text-align:right;"></td>';
      count++;
      html += '<td> <input type="text" placeholder="금액" name="order_price" value="'+arr[count]+'" class="add_input" style="text-align:right;" ></td>';
      html += '<td> <input type="text" placeholder="입고수량" name="income_count" value="" class="add_input" style="text-align:right;"></td>';
      html += '<td> <div class="search_btn_billing2"><button id ="save_receiving" onclick="ifCountNull()">저장 </button></div></td>'; 
      html += '</tr>';  
      
   
   $("#dynamicTable").append(html);
   
}
   
   
   function tableDelete(obj){
      var tr = $(obj).parent().parent();
      
      tr.remove();
      
      }
      
    </script>
    </body>
</html>