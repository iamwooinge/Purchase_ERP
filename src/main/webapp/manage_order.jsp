<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@ page import="java.text.*"%>
<%@page import="util.DatabaseUtil" %>
<%@page import="common.common" %>
<%@page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
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

<title>발주 현황</title>

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
    if(employee_id == null){
       response.sendRedirect("login.jsp");
    }
    Connection conn_log = DatabaseUtil.getConnection();
    String sql_log = "select employee_name from employee where employee_no = '"+employee_id+"'"; 
    PreparedStatement pstmt_log = conn_log.prepareStatement(sql_log);
   ResultSet rs_log = pstmt_log.executeQuery(sql_log);
   if(rs_log.next()){
      name = rs_log.getString("employee_name");
   } 
 %>
      <%
         
      try{       
         //SQL 연동 코드

         Connection conn = null;
         PreparedStatement pstmt = null;
         ResultSet rs = null;

         
             Class.forName("com.mysql.cj.jdbc.Driver");
             
             String jdbcUrl = "jdbc:mysql://localhost:3306/purchasing_manage?serverTimezone=UTC";
             String dbid = "root";
             String dbpass="1234";
             
             conn = DriverManager.getConnection(jdbcUrl, dbid, dbpass);
             
             System.out.println("Success");
          
             
               //##########################################################
             //사원코드->사원명 품번->품명 변환 기본코드
              String sql = "select t1.order_date, t1.order_no, t3.employee_name, t1.client_name, t2.product_name, t1.product_standard, t1.product_unit, t1.order_amount, t1.product_unitprice, t1.product_supply, t1.order_vat, t1.order_price, t1.order_state, t4.client_no, t4.client_tel, t4.client_fax, t4.client_address, t4.client_manager, t4.client_email from orders t1 inner join clients t4 on t1.client_name=t4.client_name, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no ";

             //청구현황 검색창에서 입력값/체크박스값 받아오기
               request.setCharacterEncoding("utf-8"); //파라미터로 값 넘어갈 때 한글 안깨지게
                String start_date = request.getParameter("start_set_mb");   //시작일자
               String end_date = request.getParameter("end_set_mb");       //끝일자
               String employee_name = request.getParameter("manager");       //담당자
               String product_Name = request.getParameter("Product_Name"); //품명
               String[] check = null;
               String searchTypeKeyword = "";
               // 페이지 나누기
                  int dbcount = 0; // 데이터베이스에 들어있는 총 레코드 수 
                  int pagecount = 0; // 총 페이지 수
                  int startpage; // 시작 페이지
                  int pagesize = 10; // 한 페이지에 보이는 정보 10개씩
                  int absolutenum = 1; //넘버링 첫숫자 1
                  int currentpage = 1; // 현재 페이지
                  int pagenum = 0;
                  int limit = 5; //보여지는 페이지 수 
                   
                  Connection conn_page = DatabaseUtil.getConnection();
                  String sql_search  = "select count(*) from orders t1 inner join clients t4 on t1.client_name=t4.client_name, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no ";
               
               
               
               
               check = request.getParameterValues("condition");   //체크박스 체크 여부
               if (check != null){ //체크박스 값 넘어가는지 콘솔 출력 확인용
                  for(int i=0;i<check.length;i++){
                     System.out.println(check[i]+employee_name);
                  }
            
                  for(int i=0;i<check.length;i++){
                     if(check[i].equals("일자") && start_date != "" &&end_date !=""){ 
                        sql += "and date(order_date) between '"+start_date+"' and '"+end_date+"' ";
                        sql_search += "and date(order_date) between '"+start_date+"' and '"+end_date+"' ";
                     }else if(check[i].equals("담당자") && employee_name !=""){ 
                        sql += "and t3.employee_name ='"+employee_name+"' ";
                        sql_search += "and t3.employee_name ='"+employee_name+"' ";
                     }else if(check[i].equals("품명") && product_Name !=""){
                        sql += "and t2.product_name = '"+product_Name+"' ";
                        sql_search += "and t2.product_name = '"+product_Name+"' ";
                     }
                  
                  }
                  sql += "ORDER BY t1.order_date DESC, order_no DESC LIMIT ? , ? ";
                  
                  if(check.length ==1){
                       searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&manager="+employee_name+"&Product_Name="+product_Name;    
                     }else if(check.length ==2){
                       searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&condition="+check[1]+"&manager="+employee_name+"&Product_Name="+product_Name;     
                     }else if(check.length ==3){
                        searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&condition="+check[1]+"&manager="+employee_name+"&condition="+check[2]+"&Product_Name="+product_Name;      
                    }
                     
                     
                     pageContext.setAttribute("check",Arrays.toString(check));
                     pageContext.setAttribute("product_name",product_Name);
                     pageContext.setAttribute("employee_name",employee_name);
                     pageContext.setAttribute("start_date",start_date);
                     pageContext.setAttribute("end_date",end_date);
            
            }else{
             sql += "ORDER BY t1.order_date DESC, order_no DESC LIMIT ? , ? ";
          }
               
              
             
               PreparedStatement pstmt_page = conn_page.prepareStatement(sql_search);
               ResultSet rs_page = pstmt_page.executeQuery();
               if(rs_page.next()){
                  dbcount = rs_page.getInt(1);
                  rs_page.close();
               }

               
               //총페이지 수 구함
               if(dbcount % pagesize == 0){
                  pagecount = dbcount / pagesize;
               }else{
                  pagecount = dbcount / pagesize + 1;
               }
               
               //넘버링 첫 숫자 구함
               if(request.getParameter("currentpage") != null){
                  currentpage = Integer.parseInt(request.getParameter("currentpage"));
                  if(currentpage == 1){
                     absolutenum = (currentpage-1) * pagesize;
                  }else{
                     absolutenum = (currentpage-1) * pagesize + 1; 
                  }
                 
               }
               absolutenum = (currentpage-1) * pagesize;      
               
             
             pstmt = conn.prepareStatement(sql);
             
             pstmt.setInt(1, absolutenum);
             pstmt.setInt(2, pagesize);


             rs = pstmt.executeQuery();
             rs.next();
             String order_state = null;
            
         
%>
<script>
/* 페이지 클릭시 색 변환 코드 */
function pagingSetColor() {
   if(<%=currentpage%> == null){
       document.getElementById('num1').className = 'active';
   }else{
       document.getElementById('num'+<%=currentpage%>).className = 'active';
   }
   }
   
</script>

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
   <h2 id = "title">발주 현황</h2>
   <form method="post" action="./manage_order.jsp">
   
   <table class="search"  border = "1px">
            <thead>
              <tr>
                <td class="td_check"><input type="checkbox" name="condition" id="check_date" value="일자" <c:if test="${fn:contains(check, '일자') }">checked</c:if>/></td>
                   <th>일자</th>
                   <td><input type = "date" name = "start_set_mb" class="search_date" value="${start_date}"> - <input type = "date" name = "end_set_mb" class="search_date" value="${end_date}"></td>
                   <td class="td_check"><input type="checkbox" name="condition" value="담당자" id="check_manager" <c:if test="${fn:contains(check, '담당자') }">checked</c:if>/></td>
                   <th>담당자</th>
                   
                   <td>
                   <select name = "manager" class="search_input">
                         <option value = "">선택</option>
                         <option value = "홍길동" <c:if test="${employee_name eq '홍길동'}">selected</c:if>>홍길동</option>
                         <option value = "박정우" <c:if test="${employee_name eq '박정우'}">selected</c:if>>박정우</option>
                         <option value = "임수린" <c:if test="${employee_name eq '임수린'}">selected</c:if>>임수린</option>
                         <option value = "채송화" <c:if test="${employee_name eq '채송화'}">selected</c:if>>채송화</option>
                         <option value = "이익준" <c:if test="${employee_name eq '이익준'}">selected</c:if>>이익준</option>
                         <option value = "김대명" <c:if test="${employee_name eq '김대명'}">selected</c:if>>김대명</option>
                      </select>
                     </td>
                    <td class="td_check"> <input type="checkbox" name="condition" value="품명" id="check_pName" <c:if test="${fn:contains(check, '품명') }">checked</c:if>/></td>
                   <th>품명</th>
                   <td>
                   <select name = "Product_Name" class="search_input">
                         <option value = "">선택</option>
                         <option value = "고랭지 배추" <c:if test="${product_name eq '고랭지 배추'}">selected</c:if>>고랭지 배추</option>
                         <option value = "제주 햇무" <c:if test="${product_name eq '제주 햇무'}">selected</c:if>>제주 햇무</option>
                         <option value = "청송 꿀 사과" <c:if test="${product_name eq '청송 꿀 사과'}">selected</c:if>>청송 꿀 사과</option>
                         <option value = "나주 배" <c:if test="${product_name eq '나주 배'}">selected</c:if>>나주 배</option>
                         <option value = "의성 햇마늘" <c:if test="${product_name eq '의성 햇마늘'}">selected</c:if>>의성 햇마늘</option>
                         <option value = "햇 고춧가루" <c:if test="${product_name eq '햇 고춧가루'}">selected</c:if>>햇 고춧가루</option>
                         <option value = "신안 천일염" <c:if test="${product_name eq '신안 천일염'}">selected</c:if>>신안 천일염</option>
                         <option value = "액젓" <c:if test="${product_name eq '액젓'}">selected</c:if>>액젓</option>
                         <option value = "젓갈" <c:if test="${product_name eq '젓갈'}">selected</c:if>>젓갈</option>
                         <option value = "박스테이프" <c:if test="${product_name eq '박스테이프'}">selected</c:if>>박스테이프</option>
                         <option value = "아이스박스" <c:if test="${product_name eq '아이스박스'}">selected</c:if>>아이스박스</option>
                          <option value = "비닐" <c:if test="${product_name eq '비닐'}">selected</c:if>>비닐</option>
                      </select>
                   </td>  
                 </tr>
                 <tr>
                <td class="search_btn" style="border-left: none;" colspan="9">
                   <div class="search_btn_billing">    
                           <button type="submit" onclick="check()">검색</button>
                           <a href = "http://localhost:8080/purchase_ERP/add_billing.jsp"><a href = "http://localhost:8080/purchase_ERP/manage_order.jsp"><button type="button">초기화</button></a></a><br><br>
                     </div> 
                </td>
                </tr>
             
            </thead>
         </table>
      </form>
      
      <table class="all_table">
      <tbody>
        <tr>
          <td colspan="3">
          
           <table id = "ct_table"  class="table custom-table">
               <thead>
                  <tr>
                     <th id = "mb_td" scope="col">조회</th>
                     <th id = "mb_td" scope="col">주문 일자</th>
                     <th id = "mb_td" scope="col">주문 번호</th>
                     <th id = "mb_td" scope="col">담당자</th>
                     <th id = "mb_td" scope="col">거래처명</th>
                     <th id = "mb_td" scope="col">품명</th>
                     <th id = "mb_td" scope="col">규격</th>
                     <th id = "mb_td" scope="col">단위</th>
                     <th id = "mb_td" scope="col">발주 수량</th>
                     <th id = "mb_td" scope="col">단가</th>
                     <th id = "mb_td" scope="col">금액</th>
                     <th id = "mb_td" scope="col">부가세</th>
                     <th id = "mb_td" scope="col">총액</th>
                     <th id = "mb_td" scope="col">입고 상태</th>
               
                  </tr>
               </thead>
      
             <tbody>
            <%
            while(true){
                //천단위 콤마 
                   DecimalFormat df = new DecimalFormat("###,###");
                   String product_unitprice = df.format(rs.getInt("product_unitprice"));
                  String product_supply = df.format(rs.getInt("product_supply"));
                  String order_vat = df.format(rs.getInt("order_vat"));
                  String order_price = df.format(rs.getInt("order_price"));
                     %>
                     <tr>
                     <td align="center">
                           <input type="radio" class="checkBtn" name="user_CheckBox" >
                        </td> <!--조회-->
                     <td align="center"><%=rs.getString("order_date")%></td> <!--주문일자-->
                     <td align="center"><%=rs.getString("order_no")%></td> <!--주문번호-->
                     <td align="center"><%=rs.getString("employee_name")%></td> <!--담당자-->
                     <td align="center"><%=rs.getString("client_name")%></td> <!--거래처명-->
                     <td align="center"><%=rs.getString("product_name")%></td> <!--품명-->
                     <td align="center"><%=rs.getString("product_standard")%></td> <!--규격-->
                     <td align="center"><%=rs.getString("product_unit")%></td> <!--단위-->
                     <td align="center"><%=rs.getString("order_amount")%></td> <!--발주수량-->
                     <td align="center"><%=product_unitprice%></td> <!--단가-->
                     <td id = "product_supply" align="center"><%=product_supply%></td> <!--공급가액-->
                     <td id = "order_vat" align="center"><%=order_vat%></td> <!--부가세-->
                     <td id = "order_price" align="center"><%=order_price%></td> <!--금액-->
                     <%if(rs.getString("order_state").equals("미완료")){ %>
                           <td id = "order_state" align="center" style=color:red;><b><%=rs.getString("order_state")%></b></td> <!--발주현황-->
                     <%}else if(rs.getString("order_state").equals("완료")){
                        %>
                        <td id = "order_state" align="center" style=color:blue;><b><%=rs.getString("order_state")%></b></td> <!--발주현황-->
                    <% }%> 
                    
                     <td id = "client_no" style="display:none"><%=rs.getString("client_no")%></td> <!--거래처번호-->
                     <td id = "client_tel" style="display:none"><%=rs.getString("client_tel")%></td> <!--거래처전화-->
                     <td id = "client_fax" style="display:none"><%=rs.getString("client_fax")%></td> <!--거래처팩스-->
                     <td id = "client_address" style="display:none"><%=rs.getString("client_address")%></td> <!--거래처주소-->
                     <td id = "client_manager" style="display:none"><%=rs.getString("client_manager")%></td> <!--거래처주소-->
                     <td id = "client_email" style="display:none"><%=rs.getString("client_email")%></td> <!--거래처이메일-->
 
                     </tr>
             
                     <%   
                     if(!rs.next()) break;  }
                     
      
                     %>                 
               </tbody>
            </table>
          </td>
        </tr>
        <tr>
          <td>   
             <div class="loading_btn">
                  <button type="button" id="selectBtn" onclick="openChild();">발주서 조회</button>
               </div>
          </td>
           <td class="bottom_td">
             <!-- 페이징 코드  -->
           <div class="pagination">
           <%
            startpage = currentpage - ((currentpage-1) % limit);
            
             if(startpage-limit>0){
                currentpage = startpage -2;  
              %>
              <a href = "http://localhost:8080/purchase_ERP/manage_order.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>">〈</a>
              <%} 
             
             if(startpage == 1){%>
                <a class="not"></a>
             <%}
            for(int i=startpage; i<startpage+limit; i++){
            %>
             <a id="num<%=i %>" href = "http://localhost:8080/purchase_ERP/manage_order.jsp?currentpage=<%=i%><%=searchTypeKeyword%>"><%=i %></a>
               
            <%
             if(i>=pagecount){ %> <!-- //빈칸 채워서 넓이 조정 -->
                <a class="not"></a>
                <% if(pagecount % 5 ==1){
                        %>
                        <a class="not"></a>
                        <a class="not"></a>
                        <a class="not"></a>
                        <a class="not"></a>
                     <% }else if(pagecount % 5 ==2){%>
                        <a class="not"></a>
                        <a class="not"></a>
                        <a class="not"></a>
                     <% }else if(pagecount % 5 ==3){%>
                        <a class="not"></a>
                        <a class="not"></a>
                     <%}else if(pagecount % 5 ==4){%>
                        <a class="not"></a>
                     <%} 
                break; 
             }
 
            } 
            

            if(startpage+limit<=pagecount){
               currentpage = startpage + limit;
            %>
             <a href = "http://localhost:8080/purchase_ERP/manage_order.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>">〉</a>     
            <%
            }
            rs.close();
            pstmt.close();
            conn.close();
         }catch(Exception e){
             
             }finally {
             }
            %>
            </div>
          </td>
          <td>
                 <!-- 칸맞추기용 안보이게 처리 -->
               <div class="loading_btn" style="visibility:hidden;">
                  <button type="button" id="selectBtn" onclick="openChild();">발주서 조회</button>
               </div>
          </td>
        </tr>
      </tbody>
   </table>
   
   
   <div class="col-lg-12" id="ex1_Result1" ></div> 
   
   <input type="hidden" value="" id = order_date ></input>
   <input type="hidden" value="" id = "order_no"></input>
   <input type="hidden" value="" id = "employee_name"></input>
   <input type="hidden" value="" id = "client_name"></input>
   <input type="hidden" value="" id = "product_name"></input>
   <input type="hidden" value="" id = "product_standard"></input>
   <input type="hidden" value="" id = "product_unit"></input>
   <input type="hidden" value="" id = "order_amount"></input>
   <input type="hidden" value="" id = "product_unitprice"></input>
   <input type="hidden" value="" id = "d_product_supply"></input>
   <input type="hidden" value="" id = "d_order_vat"></input>
   <input type="hidden" value="" id = "d_order_price"></input>
   <input type="hidden" value="" id = "d_client_no"></input>
   <input type="hidden" value="" id = "d_client_tel"></input>
   <input type="hidden" value="" id = "d_client_fax"></input>
   <input type="hidden" value="" id = "d_client_address"></input>
   <input type="hidden" value="" id = "d_client_manager"></input>
   <input type="hidden" value="" id = "d_client_email"></input>

   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>  


<script type="text/javascript">
//버튼 클릭시 Row 값 가져오기

var openWin = null;

$(".checkBtn").click(function(){
   
   var str = ""
   var tdArr = new Array();   // 배열 선언
   var checkBtn =$(this);
   
   // checkBtn.parent() : checkBtn의 부모는 <td>이다.
    // checkBtn.parent().parent() : <td>의 부모이므로 <tr>이다.
    var tr = checkBtn.parent().parent();
    var td = tr.children();
    
    console.log("클릭한 Row의 모든 데이터 : "+tr.text());

   var order_date = td.eq(1).text();
   var order_no = td.eq(2).text();
   var employee_name = td.eq(3).text();
   var client_name = td.eq(4).text();
   var product_name = td.eq(5).text();
   var product_standard = td.eq(6).text();
   var product_unit = td.eq(7).text();
   var order_amount = td.eq(8).text();
   var product_unitprice = td.eq(9).text();
   var product_supply = td.eq(10).text();
   var order_vat = td.eq(11).text();
   var order_price = td.eq(12).text();
   var client_no = td.eq(14).text();
   var client_tel = td.eq(15).text();
   var client_fax = td.eq(16).text();
   var client_address = td.eq(17).text();
   var client_manager = td.eq(18).text();
   var client_email = td.eq(19).text();
   
   
   // 반복문을 이용해서 배열에 값을 담아 사용할 수 도 있다.
   td.each(function(i){   
      tdArr.push(td.eq(i).text());
      
      
   });
   
   $('input[id=order_date]').attr('value',order_date)
   $('input[id=order_no]').attr('value',order_no)
   $('input[id=employee_name]').attr('value',employee_name)
   $('input[id=client_name]').attr('value',client_name)
   $('input[id=product_name]').attr('value',product_name)
   $('input[id=product_standard]').attr('value',product_standard)
   $('input[id=product_unit]').attr('value',product_unit)
   $('input[id=order_amount]').attr('value',order_amount)
   $('input[id=product_unitprice]').attr('value',product_unitprice)
   $('input[id=d_product_supply]').attr('value',product_supply)
   $('input[id=d_order_vat]').attr('value',order_vat)
   $('input[id=d_order_price]').attr('value',order_price)
   $('input[id=d_client_no]').attr('value',client_no)
   $('input[id=d_client_tel]').attr('value',client_tel)
   $('input[id=d_client_fax]').attr('value',client_fax)
   $('input[id=d_client_address]').attr('value',client_address)
   $('input[id=d_client_manager]').attr('value',client_manager)
   $('input[id=d_client_email]').attr('value',client_email)
   
});


function openChild(){
   // window.name = "부모창 이름"; 
    window.name = "parent";
    // window.open("open할 window", "자식창 이름", "팝업창 옵션");
    openWin = window.open("manage_orderdocuments.jsp",
            "child", "width=670, height=1110, top=250, left=500"); 
   
}
</script>
     <script>
        function check() {
              if ($("input:checkbox[name='condition']").is(":checked")==false) {
                    alert("적어도 하나는 선택하여 주십시오.");
                    return;
              }
          }
   </script>  

    <script>
        function check() {
              if ($("input:checkbox[name='condition']").is(":checked")==false) {
                    alert("적어도 하나는 선택하여 주십시오.");
                    return;
              }
          }
        pagingSetColor();
        
      

   </script>  


</body>
</html>