<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="util.DatabaseUtil" %>
<%@page import="common.common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@page import="java.util.*" %>
 
<!DOCTYPE html>
   <script src ="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<!-- bootstrap JS -->
   <script src="https://netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>
   
   <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.0.min.js" ></script>
   <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11.2.0/dist/sweetalert2.all.min.js"></script>
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
  
  
<title>청구 현황</title>
 
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
         String sql = "select t1.claim_date,t1.claim_no,t2.product_name,t3.employee_name,t1.product_amount, t1.product_standard,t1.product_unit,t1.claim_state from claim t1, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no ";
         
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
         String sql_search  = "select count(*) from claim t1, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no ";

         check = request.getParameterValues("condition");   //체크박스 체크 여부
         if (check != null){ //체크박스 값 넘어가는지 콘솔 출력 확인용
            for(int i=0;i<check.length;i++){
               System.out.println(check[i]+employee_name);
            }
      
            for(int i=0;i<check.length;i++){
               if(check[i].equals("일자") && start_date != "" &&end_date !=""){  
                  sql += "and date(claim_date) between '"+start_date+"' and '"+end_date+"' ";
                  sql_search += "and date(claim_date) between '"+start_date+"' and '"+end_date+"' ";
               }else if(check[i].equals("담당자") && employee_name !=""){ 
                  sql += "and t3.employee_name ='"+employee_name+"' ";
                  sql_search += "and t3.employee_name ='"+employee_name+"' ";
               }else if(check[i].equals("품명") && product_Name !=""){
                  sql += "and t2.product_Name like '"+product_Name+"' ";
                  sql_search += "and t2.product_name = '"+product_Name+"' ";
               }
            
            }
            sql += "ORDER BY t1.claim_date DESC, claim_no DESC LIMIT ? , ? ";
            
            
            
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
            sql += "ORDER BY t1.claim_date DESC, claim_no DESC  LIMIT ? , ? ";
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
   <h2 id = "title">청구 현황</h2>
    
      <form method="post" action="manage_billing.jsp" target="post_frame">
       <table class="search" border = "1px">
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
                         <option value = "김현정" <c:if test="${employee_name eq '김현정'}">selected</c:if>>김현정</option>
                         <option value = "이예닮" <c:if test="${employee_name eq '이예닮'}">selected</c:if>>이예닮</option>
                         <option value = "추민하" <c:if test="${employee_name eq '추민하'}">selected</c:if>>추민하</option>
                         <option value = "장홍도" <c:if test="${employee_name eq '장홍도'}">selected</c:if>>장홍도</option>
                         <option value = "이우주" <c:if test="${employee_name eq '이우주'}">selected</c:if>>이우주</option>
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
                       <td class="search_btn" style="border-left: none;"colspan="9">
                         <div class="search_btn_billing">    
                                 <button type="submit" onclick="check()">검색</button>
                                  <a href = "http://localhost:8080/purchase_ERP/add_billing.jsp"><a href = "http://localhost:8080/purchase_ERP/manage_billing.jsp"><button type="button">초기화</button></a></a><br><br>
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
                     
                     <th id = "mb_td" class="table_th" scope="col" align="center">청구 일자</th>
                     <th id = "mb_td" class="table_th" scope="col" align="center">주문 번호</th>
                     <th id = "mb_td" class="table_th" scope="col" align="center">품명</th>
                     <th id = "mb_td" class="table_th" scope="col" align="center">담당자</th>
                     <th id = "mb_td" class="table_th" scope="col" align="center">수량</th>
                     <th id = "mb_td" class="table_th" scope="col" align="center">규격</th>
                     <th id = "mb_td" class="table_th" scope="col" align="center">단위</th>
                     <th id = "mb_td" class="table_th" scope="col" align="center">발주 상태</th>
                     
                  </tr>
               </thead>
            
            <tbody>
               
            <%
            while(true){
                     %>
                     <tr>
                     
                     <td align="center"><%=rs.getString("claim_date")%></td> <!--청구일자-->
                           <td align="center"><%=rs.getString("claim_no")%></td> <!--주문번호-->
                           <td align="center"><%=rs.getString("product_name")%></td> <!--품명-->
                           <td align="center"><%=rs.getString("employee_name")%></td> <!--담당자-->
                           <td align="center"><%=rs.getInt("product_amount")%></td> <!--수량-->
                           <td align="center"><%=rs.getString("product_standard")%></td> <!--규격-->
                           <td align="center"><%=rs.getString("product_unit")%></td> <!--단위-->
                           <%if(rs.getString("claim_state").equals("미접수")){ %>
                              <td align="center" style=color:red;><b><%=rs.getString("claim_state")%></b></td> <!--진행상태-->
                           <%}else if(rs.getString("claim_state").equals("접수")){ %>
                              <td align="center" style=color:blue;><b><%=rs.getString("claim_state")%></b></td> <!--진행상태-->
                           <%} %>
                     </tr>
                     <%   if(!rs.next()) break;  }%>
               </tbody>
            </table>
          </td>
        </tr>
        <tr>
          <td>
           <!--   <div class="loading_btn">
                 <a href ="http://localhost:8080/purchase_ERP/receipt.jsp" target="_blank" ><button id ="receipt">물품구매내역서</button></a>
              </div> -->
              <div class="loading_btn">
                  <button type="button" id="selectBtn" onclick="openChild();">구매신청서 조회</button>
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
              <a href = "http://localhost:8080/purchase_ERP/manage_billing.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>" class="pageAtag">〈</a>
              <%} 
             
             if(startpage == 1){%>
                <a class="not"></a>
             <%}
            for(int i=startpage; i<startpage+limit; i++){
            %>
             <a id="num<%=i %>" href = "http://localhost:8080/purchase_ERP/manage_billing.jsp?currentpage=<%=i%><%=searchTypeKeyword%>" class="pageAtag"><%=i %></a>
               
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
             <a href = "http://localhost:8080/purchase_ERP/manage_billing.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>" class="pageAtag">〉</a>     
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
                     <button type="button" id="selectBtn" onclick="openChild();">구매신청서 조회</button>
               </div>
          </td>
        </tr>
      </tbody>
     </table>

 
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   
<br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>   


   <form>
    <input type="hidden" value="" id = "claim_date"></input>
    <input type="hidden" value="" id = "claim_no"></input>
    <input type="hidden" value="" id = "product_name"></input>
    <input type="hidden" value="" id = "employee_name"></input>
    <input type="hidden" value="" id = "product_amount"></input>
    <input type="hidden" value="" id = "product_standard"></input>
    <input type="hidden" value="" id = "product_unit"></input>
   </form>

   


   <script type="text/javascript">
  
   
   var openWin = null;

   
   function openChild(){
         
         // window.name = "부모창 이름"; 
          window.name = "parent";
          // window.open("open할 window", "자식창 이름", "팝업창 옵션");
          openWin = window.open("application_form.jsp",
                  "child", "width=750, height=1110, top=250, left=500");
          
          
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