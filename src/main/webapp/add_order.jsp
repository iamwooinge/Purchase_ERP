<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="order.*" %>
<%@ page import="java.io.PrintWriter" %>
<%@page import="util.DatabaseUtil" %>
<%@ page import="java.text.*"%>
<%@ page import="javax.naming.*"%>
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


<title>발주 등록</title>
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
    String employee_no = (String)session.getAttribute("employee_no");
   String employee_name = null;
    if(employee_no == null){
       response.sendRedirect("login.jsp");
    }
    Connection conn_log = DatabaseUtil.getConnection();
    String sql_log = "select employee_name from employee where employee_no = '"+employee_no+"'"; 
    PreparedStatement pstmt_log = conn_log.prepareStatement(sql_log);
   ResultSet rs_log = pstmt_log.executeQuery(sql_log);
   if(rs_log.next()){
      employee_name = rs_log.getString("employee_name");
   } 

   
      String order_date = null;
      String order_no = null;
      String client_name = null;
      String product_no = null;
      String product_name = null;
      int product_standard = 0; //int
      String product_unit = null;
      int order_amount = 0; //int
      int product_unitprice = 0; //int
      int order_supply = 0; //int
      int order_vat = 0; //int
      int order_price = 0; //int
      //String order_state = null;
      
      
      
      request.setCharacterEncoding("utf-8");
      
      if(request.getParameter("order_date") != null){
         order_date = request.getParameter("order_date");
      }
     
      if(request.getParameter("order_no") != null){
         order_no = request.getParameter("order_no");
      }
      if(request.getParameter("employee_no") != null){
         employee_no = request.getParameter("employee_no");
      }
      if(request.getParameter("client_name") != null){
         client_name = request.getParameter("client_name");
      }
      if(request.getParameter("product_name") != null){
         product_name = request.getParameter("product_name");
         Connection conn = DatabaseUtil.getConnection();
         String sql = "select product_no from product where product_name = '"+product_name+"'"; 
         PreparedStatement pstmt = conn.prepareStatement(sql);
         ResultSet rs = pstmt.executeQuery(sql);
         if (rs.next()){
            product_no = rs.getString("product_no");
         }
      }
      if(request.getParameter("product_standard") != null){
         product_standard = Integer.parseInt(request.getParameter("product_standard"));
      }
      if(request.getParameter("product_unit") != null){
         product_unit = request.getParameter("product_unit");
      }
      if(request.getParameter("order_amount") != null){
         order_amount = Integer.parseInt(request.getParameter("order_amount"));
      }
      if(request.getParameter("product_unitprice") != null){
         product_unitprice = Integer.parseInt(request.getParameter("product_unitprice"));
      }
      if(request.getParameter("order_supply") != null){
         order_supply = Integer.parseInt(request.getParameter("order_supply"));
      }
      if(request.getParameter("order_vat") != null){
         order_vat = Integer.parseInt(request.getParameter("order_vat"));
      }
      if(request.getParameter("order_price") != null){
         order_price = Integer.parseInt(request.getParameter("order_price"));
      }
      
       orderDAO o = new orderDAO();
        int result = o.order(order_date, order_no,employee_no, client_name, product_no, product_standard, product_unit, order_amount, product_unitprice, order_supply, order_vat, order_price);
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
   <h2 id="title">발주 등록</h2>
   
   <form action="./add_order.jsp" method="post"  id="order">
      <td> <input type="date" style="display:none;" name = "order_date" /></td>
      <script>
      var date = new Date();
      var yyyy = date.getFullYear();
      var mm = date.getMonth()+1 > 9 ? date.getMonth()+1 : '0' + date.getMonth()+1;
      var dd = date.getDate() > 9 ? date.getDate() : '0' + date.getDate();
      $("input[type=date]").val(yyyy+"-"+mm+"-"+dd);
      </script>
      
   
      <table border = "1" id = "dynamicTable" class="add_column" style="text-align: center; text-color:black;">

            <tr>
               <th id = "mb_td" style="width:110px">주문 번호</th>
               <th id = "mb_td" style="width:110px">거래처명</th>
               <th id = "mb_td" style="width:110px">품명</th>
               <th id = "mb_td" style="width:110px">규격</th>
               <th id = "mb_td" style="width:110px">단위</th>
               <th id = "mb_td" style="width:110px">발주 수량</th>
               <th id = "mb_td" style="width:110px">단가</th>
               <th id = "mb_td" style="width:110px">금액</th>
               <th id = "mb_td" style="width:110px">부가세</th>
               <th id = "mb_td" style="width:110px">총액</th>
            </tr>
       </table>
   </form>
   <table style="position:absolute; left:240px; top:280px;">
   <tr><td><div class="search_btn_billing3"><button id="billing_loding" onclick="viewClaim();">청구 불러오기</button></div></td></tr>
   </table>
<script>
   function viewClaim(){
       window.open("claimlist.jsp","","width=1610, height=650, top=150, left=150");
   }
   
   function tableDelete(obj){
      var tr = $(obj).parent().parent();
      tr.remove();
   }
   
   function tableCreate(arr){   
      var html = '';
      var count = 0;
      
      html += '<tr>';
      html += '<td><input type="text" placeholder="주문번호" name="order_no" value="'+arr[count]+'" id="inproname" class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><input type="text" placeholder="거래처명" name="client_name" value="'+arr[count]+'" id="inunit" class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><input type="text" placeholder="품명" name="product_name" value="'+arr[count]+'" id="inunit" class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><input type="text" placeholder="규격" name="product_standard" value="'+arr[count]+'" id="inunitprice" class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><input type="text" placeholder="단위" name="product_unit" value="'+arr[count]+'" id="inprice" class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><input type="text" placeholder="발주수량" name="order_amount" value="'+arr[count]+'" id="inprice"class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><input type="text" placeholder="단가" name="product_unitprice" value="'+arr[count]+'" id="inprice" class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><input type="text" placeholder="공급가액" name="order_supply" value="'+arr[count]+'" id="inprice" class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><input type="text" placeholder="부가세" name="order_vat" value="'+arr[count]+'" id="inprice" class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><input type="text" placeholder="금액" name="order_price" value="'+arr[count]+'" id="inprice" class="add_input" style="text-align:right;" readonly></td>';
      count++;
      html += '<td><div class="search_btn_billing2"><button type="submit" id="save_orders" value="저장">저장</button></div></td>';
      html += '</tr>';
      $("#dynamicTable").append(html);

      
   }

</script>  

</body>
</html>