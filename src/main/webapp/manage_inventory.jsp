<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
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
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    
  
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


<meta charset="UTF-8">
<title>재고 현황</title>

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
</head>
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
 <!-- jQuery  -->
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<!--    <link href = "design.css" rel = "stylesheet" type = "text/css">   
 -->
 <!-- Required meta tags tables-->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="table/fonts/icomoon/style.css">
    <link rel="stylesheet" href="table/css/owl.carousel.min.css">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="table/css/bootstrap.min.css">
    <link rel="stylesheet" href="table/css/style.css">
   <link href = "paging.css" rel = "stylesheet" type = "text/css">  

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
   Connection conn = null;
   PreparedStatement pstmt = null;
   ResultSet rs = null;
   
   try{
       Class.forName("com.mysql.cj.jdbc.Driver");
       
       String jdbcUrl = "jdbc:mysql://localhost:3306/purchasing_manage?serverTimezone=UTC";
       String dbid = "root";
       String dbpass="1234";
       
       conn = DriverManager.getConnection(jdbcUrl, dbid, dbpass);
       
       System.out.println("Success");
       
       
       String sql = "select t1.stock_no, t2.product_name, t1.product_standard,t1.product_unit, t1.stock_date, t1.product_amount, t1.product_type, t1.stock_all from stock t1, product t2 where t1.product_no = t2.product_no ";
       //청구현황 검색창에서 입력값/체크박스값 받아오기
         request.setCharacterEncoding("utf-8"); //파라미터로 값 넘어갈 때 한글 안깨지게
          String start_date = request.getParameter("start_set_mb");   //시작일자
         String end_date = request.getParameter("end_set_mb");       //끝일자
         String product_type = request.getParameter("type"); //유형
         String product_name = request.getParameter("Product_Name"); //품명

          
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
            String sql_search  = "select count(*) from stock t1, product t2 where t1.product_no = t2.product_no ";
         
         
         
         check = request.getParameterValues("condition");   //체크박스 체크 여부
         if (check != null){ //체크박스 값 넘어가는지 콘솔 출력 확인용
            for(int i=0;i<check.length;i++){
               System.out.println(check[i]+product_type);
            }
      
            for(int i=0;i<check.length;i++){
               if(check[i].equals("일자") && start_date != "" &&end_date !=""){ 
                  sql += "and date(stock_date) between '"+start_date+"' and '"+end_date+"' ";
                  sql_search += "and date(stock_date) between '"+start_date+"' and '"+end_date+"' ";
               }else if(check[i].equals("유형") && product_type !=""){
                  sql += "and t1.product_type like '"+product_type+"' ";
                  sql_search += "and t1.product_type like '"+product_type+"' ";
               }else if(check[i].equals("품명") && product_name !=""){
                  sql += "and t2.product_name like '"+product_name+"' ";
                  sql_search += "and t2.product_name like '"+product_name+"' ";
               }
            }
            sql += "ORDER BY t1.stock_date DESC, stock_num DESC  LIMIT ? , ? ";
            
            
            if(check.length ==1){
                  searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&Product_Name="+product_name+"&type="+product_type;    
                }else if(check.length ==2){
                   searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&condition="+check[1]+"&Product_Name="+product_name+"&type="+product_type;   
                }else if(check.length ==3){
                   searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&condition="+check[1]+"&Product_Name="+product_name+"&condition="+check[2]+"&type="+product_type;    
               }
                
                
                pageContext.setAttribute("check",Arrays.toString(check));
                pageContext.setAttribute("product_name",product_name);
                pageContext.setAttribute("start_date",start_date);
                pageContext.setAttribute("end_date",end_date);
                pageContext.setAttribute("product_type",product_type);
       
            
            }else{
               sql += "ORDER BY t1.stock_date DESC, stock_num DESC  LIMIT ? , ? ";
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
   <h2 id = "title">재고 현황</h2> 
   <form method = "post" action = "manage_inventory.jsp">
   
   <table class="search"  border = "1px">
            <thead>
              <tr>
                <td class="td_check"><input type="checkbox" name="condition" value="일자" <c:if test="${fn:contains(check, '일자') }">checked</c:if>/></td>
                <th>일자</th>
                <td><input type = "date" name = "start_set_mb" class="search_date" value="${start_date}"> - <input type = "date" name = "end_set_mb" class="search_date" value="${end_date}"></td>
                <td class="td_check"> <input type="checkbox" name="condition" value="품명" <c:if test="${fn:contains(check, '품명') }">checked</c:if>/></td>
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
                
                <td class="td_check"> <input type="checkbox" name="condition" value="유형" <c:if test="${fn:contains(check, '유형') }">checked</c:if>/></td>
                <th>품명</th>
                <td>
                   <select name = "type" class="search_input">
                   <option value = "">선택</option>
                   <option value = "초기" <c:if test="${product_type eq '초기'}">selected</c:if>>초기재고</option>
                   <option value = "정상입고" <c:if test="${product_type eq '정상입고'}">selected</c:if>>정상입고</option>
                   <option value = "반품" <c:if test="${product_type eq '반품'}">selected</c:if>>반품</option>
                   <option value = "교환출고" <c:if test="${product_type eq '교환출고'}">selected</c:if>>교환출고</option>
                   <option value = "교환입고" <c:if test="${product_type eq '교환입고'}">selected</c:if>>교환입고</option>
                </select>
                </td>
               </tr>
               <tr>
                    <td class="search_btn" style="border-left: none;" colspan="9">
                      <div class="search_btn_billing">    
                              <button type="submit" onclick="check()">검색</button>
                               <a href = "http://localhost:8080/purchase_ERP/add_billing.jsp"><a href = "http://localhost:8080/purchase_ERP/manage_inventory.jsp"><button type="button">초기화</button></a></a><br><br>
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
            <table id = "ct_table" class="table custom-table">
               <thead>
                     <tr>
                           <th id = "mb_td">품명</th>
                           <th id = "mb_td">규격</th>
                           <th id = "mb_td">단위</th>
                           <th id = "mb_td">수량</th>
                           <th id = "mb_td">유형</th>
                           <th id = "mb_td">일자</th>
                           <th id = "mb_td">총 수량</th>
                        </tr>
                     </thead>
                  
                  <tbody>
                  <%
                     while(true){
                           %>
                           <tr><!--조회-->
                           <td align="center"><%=rs.getString("product_name")%></td> <!--품명-->
                                 <td align="center""><%=rs.getString("product_standard")%></td> <!--담당자-->
                                 <td align="center""><%=rs.getString("product_unit")%></td> <!--단위-->
                                 <td align="center"><%=rs.getInt("product_amount")%></td> <!--수량-->
                                 <td align="center"><%=rs.getString("product_type")%></td> <!--유형-->
                                 <td align="center"><%=rs.getString("stock_date")%></td> <!--일자-->
                                 <td align="center"><%=rs.getInt("stock_all")%></td> <!--총 수량-->
                           </tr>
                           <%         
                   
         
                     %>
                <%   if(!rs.next()) break;  }%>
                     </tbody>
                 </table>
          </td>
        </tr>
        <tr>
          <td></td>
          <td class="bottom_td">
           <!-- 페이징 코드  -->
           <div class="pagination">
           <%
            startpage = currentpage - ((currentpage-1) % limit);
            
             if(startpage-limit>0){
                currentpage = startpage -2;  
              %>
              <a href = "http://localhost:8080/purchase_ERP/manage_inventory.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>">〈</a>
              <%} 
             
             if(startpage == 1){%>
                <a class="not"></a>
             <%}
            for(int i=startpage; i<startpage+limit; i++){
            %>
             <a id="num<%=i %>" href = "http://localhost:8080/purchase_ERP/manage_inventory.jsp?currentpage=<%=i%><%=searchTypeKeyword%>"><%=i %></a>
               
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
             <a href = "http://localhost:8080/purchase_ERP/manage_inventory.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>">〉</a>     
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
         
         <td></td>
        </tr>
      </tbody>
      </table>
       
         



     
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/> 
     
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