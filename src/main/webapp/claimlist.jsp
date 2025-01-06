<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="common.common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@page import="java.util.*" %>
<%@page import="util.DatabaseUtil" %>
<!DOCTYPE html>
<script src ="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js">
</script>
<html>
<head>
<meta charset="UTF-8">
<title>청구 불러오기</title>
<link href = "design.css" rel = "stylesheet" type = "text/css">   
</head>
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
 <!-- jQuery  -->
   <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<!--    <link href = "design.css" rel = "stylesheet" type = "text/css">   
 -->
 <!-- Required meta tags tables-->
    <meta charset="utf-8">
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
  <title>청구 불러오기</title>
</head>
<body>
<%  
   //SQL 연동 코드
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
    
       
      //##########################################################
       //사원코드->사원명 품번->품명 변환 기본코드
      String sql = "select t1.claim_date,t1.claim_no,t2.product_name,t3.employee_name,t1.product_amount, t2.product_unitprice ,t1.product_standard,t1.product_unit, t1.claim_state, t1.product_amount*t2.product_unitprice AS order_supply, CASE WHEN t2.product_name ='청송 꿀 사과' or t2.product_name ='고랭지 배추' or t2.product_name ='제주 햇무' or t2.product_name ='햇 고춧가루'  or t2.product_name ='의성 햇마늘'  or t2.product_name ='신안 천일염'  or t2.product_name ='나주 배' THEN 0 ELSE t1.product_amount*t2.product_unitprice*0.1 END AS order_vat, t1.product_amount*t2.product_unitprice+(CASE WHEN t2.product_name ='청송 꿀 사과' or t2.product_name ='고랭지 배추' or t2.product_name ='제주 햇무' or t2.product_name ='햇 고춧가루'  or t2.product_name ='의성 햇마늘'  or t2.product_name ='신안 천일염'  or t2.product_name ='나주 배' THEN 0 ELSE t1.product_amount*t2.product_unitprice*0.1 END) AS order_price, CASE WHEN t2.product_name='고랭지 배추' or t2.product_name='제주 햇무' or t2.product_name='의성 햇마늘' THEN '싱싱청과' WHEN t2.product_name='청송 꿀 사과' or t2.product_name='나주 배' THEN '달콤청과' WHEN t2.product_name='신안 천일염' or t2.product_name='젓갈' or t2.product_name='액젓' THEN '저염상회' WHEN t2.product_name='햇 고춧가루' THEN '고운 고춧가루' WHEN t2.product_name='박스테이프' or t2.product_name='아이스박스' or t2.product_name='비닐' THEN '서대문 포장' END AS client_name from claim t1, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no ";
       
       //청구현황 검색창에서 입력값/체크박스값 받아오기
      request.setCharacterEncoding("utf-8"); //파라미터로 값 넘어갈 때 한글 안깨지게
       String start_date = request.getParameter("start_set_mb");   //시작일자
      String end_date = request.getParameter("end_set_mb");       //끝일자
      String claim_state = request.getParameter("claim_state"); //진행상태
      String product_name = request.getParameter("product_name"); //품명
      String[] check = null;
      
  	String searchTypeKeyword = "";
    // 페이지 나누기
       int dbcount = 0; // 데이터베이스에 들어있는 총 레코드 수 
       int pagecount = 0; // 총 페이지 수
       int startpage; // 시작 페이지
       int pagesize = 5; // 한 페이지에 보이는 정보 5개씩
       int absolutenum = 1; //넘버링 첫숫자 1
       int currentpage = 1; // 현재 페이지
       int pagenum = 0;
       int limit = 5; //보여지는 페이지 수 
        
       Connection conn_page = DatabaseUtil.getConnection();
       String sql_search  = "select count(*) from claim t1, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no ";
    
    check = request.getParameterValues("condition");   //체크박스 체크 여부
    if (check != null){ //체크박스 값 넘어가는지 콘솔 출력 확인용
       for(int i=0;i<check.length;i++){
          System.out.println(check[i]+claim_state);
       }
       for(int i=0 ; i<check.length ; i++)
       {
          if(check[i].equals("일자") && start_date != "" && end_date != ""){
             sql += "and date(claim_date) between '" +start_date+"' and '" + end_date+"' ";
             sql_search += "and date(claim_date) between '" +start_date+"' and '" + end_date+"' ";
          }
          else if(check[i].equals("품명") && product_name != ""){
             sql += "and t2.product_name ='" +product_name+"' ";
             sql_search += "and t2.product_name ='" +product_name+"' ";
             
          }
          else if(check[i].equals("진행상태") && claim_state != ""){
             sql += "and t1.claim_state = '"+claim_state+"' ";
             sql_search += "and t1.claim_state = '"+claim_state+"' ";
          }           
       }
       sql += "ORDER BY t1.claim_date DESC, claim_no DESC LIMIT ? , ? ";
       
       
       
       if(check.length ==1){
     	 searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&product_name="+product_name+"&claim_state="+claim_state;    
       }else if(check.length ==2){
       	searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&condition="+check[1]+"&product_name="+product_name+"&claim_state="+claim_state; 
       }else if(check.length ==3){
       	searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&condition="+check[1]+"&product_name="+product_name+"&condition="+check[2]+"&claim_state="+claim_state; 
        }
       
       
       pageContext.setAttribute("check",Arrays.toString(check));
       pageContext.setAttribute("product_name",product_name);
       pageContext.setAttribute("claim_state",claim_state);
       pageContext.setAttribute("start_date",start_date);
       pageContext.setAttribute("end_date",end_date);
          
    }else{
  	  sql += "ORDER BY t1.claim_date DESC, claim_no DESC LIMIT ? , ? ";
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
  
       <form method="post" action="claimlist.jsp">
	       <table class="search2" border = "1px">
	               <thead>
	                 <tr>
		                   <td class="td_check"><input type="checkbox" name="condition" id="condition1" value="일자" <c:if test="${fn:contains(check, '일자') }">checked</c:if>/></td>
		                   <th>일자</th>
		                   <td><input type = "date" name = "start_set_mb" class="search_date" value="${start_date}"> - <input type = "date" name = "end_set_mb" class="search_date" value="${end_date}"></td>
		                   <td class="td_check"> <input type="checkbox" name="condition" value="품명" id="condition3" <c:if test="${fn:contains(check, '품명') }">checked</c:if>/></td>
		                   <th>품명</th>
		                   <td>
	                   	<select name = "product_name" class="search_input">
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
		                   <td class="td_check"> <input type="checkbox" name="condition" value="진행상태" <c:if test="${fn:contains(check, '진행상태') }">checked</c:if>/></td>
		                   <th>발주 상태</th>
		                   <td>
		                   <select name="claim_state" class="search_input">
		                      <option value = "">선택</option>
				             <option value="접수" <c:if test="${claim_state eq '접수'}">selected</c:if>> 접수</option>
				             <option value="미접수" <c:if test="${claim_state eq '미접수'}">selected</c:if>> 미접수</option>
				          </select>
		                   </td>
	                   </tr>
	                   
	                   <tr>
		                   <td class="search_btn" style="border-left: none;" colspan="9">
		                      <div class="search_btn_billing">    
		                              <button type="submit" onclick="check()">검색</button>
		                              <a href = "http://localhost:8080/purchase_ERP/add_billing.jsp"><a href = "http://localhost:8080/purchase_ERP/claimlist.jsp"><button type="button">초기화</button></a></a><br><br>  
		                       </div> 
		                   </td>
	                   </tr>
	               </thead>
	            </table>
            </form>
    
    <br><br>
    
   <form action="claimlist.jsp" method="post" enctype="UTF-8">
     <table class="all_table2">
       <tbody>
        <tr>
          <td colspan="3">
            <table id = "ct_table" class="table custom-table">
            <thead>
	      <tr>
	         <th id = "mb_td" class="table_th" scope="col" align="center">선택</th>
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
	         <td align="center"><input type="checkbox" name="user_CheckBox"></td>
	         <td align="center" class="selected_td" name="claim_date"><%=rs.getString("claim_date")%></td> <!--청구일자-->
	         <td align="center" class="selected_td" name="claim_no"><%=rs.getString("claim_no")%></td> <!--주문번호-->
	         <td align="center" class="selected_td" name="product_name"><%=rs.getString("product_name")%></td> <!--품명-->
	         <td align="center" class="selected_td" name="employee_name"><%=rs.getString("employee_name")%></td> <!--담당자-->
	         <td align="center" class="selected_td" name="product_standard"><%=rs.getString("product_standard")%></td> <!--규격-->
	         <td align="center" class="selected_td" name="product_unit"><%=rs.getString("product_unit")%></td> <!--단위-->
	         <td align="center" class="selected_td" name="product_amount"><%=rs.getInt("product_amount")%></td> <!--수량-->
	         <%if(rs.getString("claim_state").equals("미접수")){ %>
                  <td align="center" style=color:red;><b><%=rs.getString("claim_state")%></b></td> <!--진행상태-->
             <%}else if(rs.getString("claim_state").equals("접수")){ %>
             	  <td align="center" style=color:blue;><b><%=rs.getString("claim_state")%></b></td> <!--진행상태-->
              <%} %>
	         <td align="center" class="selected_td" name="product_unitprice" style="display:none"><%= rs.getInt("product_unitprice") %></td><!-- 단가 -->
	         <td align="center" class="selected_td" name="order_supply" style="display:none"><%= rs.getInt("order_supply") %></td><!-- 공급가액 -->
	         <td align="center" class="selected_td" name="order_vat" style="display:none"><%= rs.getInt("order_vat") %></td><!-- 부가세 -->
	         <td align="center" class="selected_td" name="order_price" style="display:none"><%= rs.getInt("order_price") %></td><!-- 총액 -->
	         <td align="center" class="selected_td" name="client_name" style="display:none"><%= rs.getString("client_name") %></td> <!-- 거래처 이름 -->
	         </tr>   
	      <%   if(!rs.next()) break;  }%>
	
	   		</tbody>
	       </table>
	      </td>
	     </tr>
	    <tr>
        	<td>
	        	<div class="loading_btn2" style="visibility:hidden;">
	        		<button type="button" onclick="CloseWindow();">전송</button>
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
              <a href = "http://localhost:8080/purchase_ERP/claimlist.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>">〈</a>
              <%} 
             
             if(startpage == 1){%>
                <a class="not"></a>
             <%}
            for(int i=startpage; i<startpage+limit; i++){
            %>
             <a id="num<%=i %>" href = "http://localhost:8080/purchase_ERP/claimlist.jsp?currentpage=<%=i%><%=searchTypeKeyword%>"><%=i %></a>
            	
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
             <a href = "http://localhost:8080/purchase_ERP/claimlist.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>">〉</a>     
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
		  	    <div class="loading_btn2">
	        		<button type="button" id="selectBtn" onclick="CloseWindow();">전송</button>
	        	</div>
		  </td>
        </tr>
       
      </tbody>
     </table>
    </form>
     

<!-- <input type="button" value="전송" id="selectBtn" onclick="CloseWindow();"/> -->
<script>
   
      function btnOk_Click()
      {
          parent.location.reload();
      }
      
      function CloseWindow(){ //팝업 제출 후 창 닫기 
         window.open('','_self').close();
      }
      
      
        // 상단 선택버튼 클릭시 체크된 Row의 값을 가져온다.
        $("#selectBtn").click(function(){ 
            
            var rowData = new Array();
            var tdArr = new Array();
          
            var checkbox = $("input[name=user_CheckBox]:checked");
            
            // 체크된 체크박스 값을 가져온다
            checkbox.each(function(i) {
    
                // checkbox.parent() : checkbox의 부모는 <td>이다.
                // checkbox.parent().parent() : <td>의 부모이므로 <tr>이다.
                var tr = checkbox.parent().parent().eq(i);
                var td = tr.children();
                
                // 체크된 row의 모든 값을 배열에 담는다.
                rowData.push(tr.text());
                
                // td.eq(0)은 체크박스 이므로  td.eq(1)의 값부터 가져온다.
                var claim_no = td.eq(2).text()+"";
                var product_name = td.eq(3).text()+"";
                var product_amount = td.eq(5).text()+"";
                var product_standard = td.eq(6).text()+"";
                var product_unit = td.eq(7).text()+"";
                var product_unitprice = td.eq(9).text()+"";
                var order_supply = td.eq(10).text()+"";
                var order_vat = td.eq(11).text()+"";
                var order_price = td.eq(12).text()+"";
                var client_name = td.eq(13).text()+"";
                
                // 가져온 값을 배열에 담는다.
                tdArr.push(claim_no);
                tdArr.push(client_name);
                tdArr.push(product_name);
                tdArr.push(product_amount);
                tdArr.push(product_standard);
                tdArr.push(product_unit);
                tdArr.push(product_unitprice);
                tdArr.push(order_supply);
                tdArr.push(order_vat);
                tdArr.push(order_price);
                
                
                
                //console.log("order_no : " + order_no);
                //console.log("userid : " + userid);
                //console.log("name : " + name);
                //console.log("email : " + email); */
            });
            
           // $('input[name=inputResult]').attr('value',tdArr);
            $("#ex3_Result1").html(" * 체크된 Row의 모든 데이터 = "+tdArr); 
            
           /*  입고 등록에 테이블 행 추가 */
           opener.parent.tableCreate(tdArr);
        });
        
        
        
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