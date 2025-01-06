<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="stock.stockDTO" %>
<%@page import="stock.stockDAO" %>
<%@page import="java.io.PrintWriter" %>
<%@page import="util.DatabaseUtil" %>

<%@page import="common.common" %>




<!DOCTYPE html>
<%
   request.setCharacterEncoding("UTF-8");
%>
<script src ="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js">
</script>

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
<title>초기 재고 등록</title>
   <script>
      function tableCreate() {
      var html='';
      var product_name = $("#inproname").val();
      var quantity = $("#inquantity").val();
      var standard = $("#instandard").val();
      var unit = $("#inunit").val();
      
      html += '<tr>';
      html += '<td>' + product_name + '</td>';
      html += '<td>' + quantity + '</td>';
      html += '<td>' + standard + '</td>';
      html += '<td>' + unit + '</td>';
      
      html += '</tr>';
      
      $("#dynamicTable").append(html);
      
      $("#inproname").val();
      $("#inquantity").val();
      $("#instandard").val();
      $("#inunit").val();
      $("remove").val();
      
   }
   
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
    
    // select element 변경 이벤트
    function changeProductSelect(){
       var productSelect = document.getElementById("inproname");
       if('CB' == productSelect.value){
            $("#instandard").val("10");
          $("#inunit").val("BOX(kg)");         
       }
       if('RD' == productSelect.value){
            $("#instandard").val("10");
          $("#inunit").val("BOX(kg)");         
       }
       if('AP' == productSelect.value){
            $("#instandard").val("5");
          $("#inunit").val("BOX(개)");         
       }
       if('SA' == productSelect.value){
            $("#instandard").val("5");
          $("#inunit").val("BOX(kg)");         
       }
       if('RP' == productSelect.value){
            $("#instandard").val("10");
          $("#inunit").val("BOX(kg)");         
       }
       if('PE' == productSelect.value){
            $("#instandard").val("5");
          $("#inunit").val("BOX(개)");         
       }
       if('GA' == productSelect.value){
            $("#instandard").val("1");
          $("#inunit").val("BOX(kg)");         
       }
       if('SF' == productSelect.value){
            $("#instandard").val("5");
          $("#inunit").val("BOX(kg)");         
       }
       if('FS' == productSelect.value){
            $("#instandard").val("5");
          $("#inunit").val("BOX(kg)");         
       }
       if('IB' == productSelect.value){
            $("#instandard").val("15");
          $("#inunit").val("묶음(개)");         
       }
       if('VI' == productSelect.value){
            $("#instandard").val("50");
          $("#inunit").val("BOX(개)");         
       }
       if('BT' == productSelect.value){
            $("#instandard").val("30");
          $("#inunit").val("BOX(개)");         
       }
    }
    
    </script>

</head>
<body>
<% //로그인 할 때 employee__no를 불러옴
    String employee_no = (String)session.getAttribute("employee_no");
    String employee_name = null;
    String authority_code = null;
    if(employee_no == null){
       response.sendRedirect("login.jsp");
    }
    Connection conn = DatabaseUtil.getConnection();
    String sql = "select employee_name,authority_code from employee where employee_no = '"+employee_no+"'"; 
    PreparedStatement pstmt = conn.prepareStatement(sql);
    ResultSet rs = pstmt.executeQuery(sql);
    if(rs.next()){
      employee_name = rs.getString("employee_name");
      authority_code = rs.getString("authority_code");
    }
    if(!(authority_code.equals("KA0a"))){
       %>
       <script>
      alert("접근할 수 없는 페이지 입니다.");
      </script>
       <META http-equiv=refresh content="0;url=main.jsp">

       <%
    }

try{
   String stock_no = null;
   String product_no = null;
   int product_amount = 0;
   String product_unit = null;
   int product_standard = 0;
   String stock_date = null;
   int stock_num = 0;
   int stock_all = 0;
   
   if(request.getParameter("stock_date") != null){
    stock_date = request.getParameter("stock_date");
      stock_no = "S" + stock_date.replace("-", "").replace("20","");
   }
   if(request.getParameter("product_no") != null){
      product_no = request.getParameter("product_no");
      stock_no = stock_no+"-"+product_no;
   }
   if(request.getParameter("product_amount") != null){
      product_amount = Integer.parseInt(request.getParameter("product_amount"));
   }
   if(request.getParameter("product_standard") != null){
      product_standard = Integer.parseInt(request.getParameter("product_standard"));
   }
   if(request.getParameter("product_unit") != null){
      product_unit = request.getParameter("product_unit");
   }
    
 // 주문번호, 품목별 개수 구해서 뒤에 붙임   
    String sql2 = "select count(*) from stock where product_no ='" + product_no + "'";
    PreparedStatement pstmt2 = conn.prepareStatement(sql2);
    ResultSet rs2 = pstmt2.executeQuery(sql2);
    
    int cnt = 0;
    if(rs2.next()){
       cnt = rs2.getInt(1)+1;
       if(cnt < 10){
          stock_no = stock_no + "0" + cnt;
       }else{
          stock_no = stock_no + cnt;
       }
    }
   
    
   //총 재고 등록
    String sql3 = "select product_amount from initialstock where product_no = '" + product_no + "';";
    PreparedStatement pstmt3 = conn.prepareStatement(sql3);
    ResultSet rs3 = pstmt3.executeQuery(sql3);
    int stock_amount = 0;
    if(rs3.next()){
    stock_amount = rs3.getInt("product_amount");
    System.out.println(stock_amount);
    }
    int add_amount = product_amount + stock_amount;
    System.out.println(product_amount);
    System.out.println(stock_amount);
    System.out.println(add_amount);
    String sql4 = "update initialstock set product_amount = '" + add_amount + "' where product_no ='" + product_no + "';";
    PreparedStatement pstmt4 = conn.prepareStatement(sql4);
    pstmt4.executeUpdate(sql4);
    
    //재고 테이블에 총 재고 등록
    stock_all = add_amount; 
    String sql5 = "select count(*) from stock;";
    PreparedStatement pstmt5 = conn.prepareStatement(sql5);
    ResultSet rs5 = pstmt5.executeQuery(sql5);
    if(rs5.next()){
        stock_num = rs5.getInt(1)+1;
    }
    
    stockDAO stockDAO = new stockDAO();
    int result = stockDAO.stock(stock_num, stock_no, product_no, product_standard, product_unit, product_amount, stock_date, stock_all);
}catch(Exception e){}finally{}
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
		      <%=employee_name %>님이 로그인하셨습니다. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <!--로그인 후 누가 로그인하였는지 표시-->
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
                    <a href = "http://localhost:8080/purchase_ERP/add_billing.jsp">청구 등록</a>
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
   <h2 id = "title">초기 재고 등록</h2>
      <form action="./add_inventory.jsp" method="post" id="stock">
         <td> <input type="date" style="display:none;" name = "stock_date" /></td>
	      <script>
		      var date = new Date();
		      var yyyy = date.getFullYear();
		      var mm = date.getMonth()+1 > 9 ? date.getMonth()+1 : '0' + date.getMonth()+1;
		      var dd = date.getDate() > 9 ? date.getDate() : '0' + date.getDate();
		      $("input[type=date]").val(yyyy+"-"+mm+"-"+dd);
	      </script>
       
      	<table border="1" id="dynamicTable" class="add_column" style="text-color:black;">
            <tbody id = "dynamicTbody">
	            <tr>
					<th id = "mb_td">품명</th>
					<th id = "mb_td">수량</th>
					<th id = "mb_td">규격</th>
					<th id = "mb_td">단위</th>
					<th id = "mb_td"></th>
	            </tr>
	         
	            <tr>

	              <td>
	               <select type="text" style="width:100%; height:100%; border:1px solid white;" id="inproname" name="product_no" onchange="changeProductSelect()">
	                     <option value="none">선택</option>
	                     <option value="CB">고랭지 배추</option>
	                     <option value="RD">제주 햇무</option>
	                     <option value="AP">청송 꿀 사과</option>
	                     <option value="SA">신안 천일염</option>
	                     <option value="RP">햇 고춧가루</option>
	                     <option value="PE">나주 배</option>
	                     <option value="GA">의성 햇마늘</option>
	                     <option value="SF">젓갈</option>
	                     <option value="FS">액젓</option>
	                     <option value="IB">아이스박스</option>
	                     <option value="VI">비닐</option>
	                     <option value="BT">박스테이프</option>
	               </select></td>
	              <td><input type="text" style="width:100%; height:100%; text-align:right; border:1px solid white;" id="inquantity" name="product_amount"></td>
	              <td><input type="text" style="width:100%; height:100%; text-align:right; border:1px solid white;" id="instandard" name="product_standard" readonly></td>
	              <td><input type="text" style="width:100%; height:100%; text-align:right; border:1px solid white;" id="inunit" name="product_unit" readonly></td>
	              <td><div class="search_btn_billing2"><button type="submit" id="save_inventory" value="저장" >저장</button></div></td>
	             
	              <!--  <input type="submit" id="save_inventory" value="저장" >저장</td>-->
	            </tr>

         </tbody>

      </table>
      </form>
<script type="text/javascript">
function isNull(){
   var productAmount = document.getElementById("inquantity");
   if(productAmount.value == ""){
      alert("값을 넣어주세요");
   }
}
</script>



</body>
</html>