<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.*" %>
<%@page import="util.DatabaseUtil" %>
<%@ page import="java.text.*"%>
<%@ page import="javax.naming.*"%>
<%@page import="common.common" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>
<%@page import="java.util.*" %>
<!DOCTYPE html>
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
   

<title>반품/교환 불러오기</title>
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
	//사원코드->사원명 품번->품명 변환 기본코드
	String sql = "select t1.income_no,t1.income_return_no, t3.employee_name, t1.client_name,t2.product_name, t1.product_standard,t1.product_unit, t1.order_date, t1.product_count, t1.product_unitprice, t1.product_supply, t1.order_vat, t1.order_price, t1.income_date, t1.income_count,t1.nincome_count,t1.income_state,t1.income_category from income t1, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no  ";
	//청구현황 검색창에서 입력값/체크박스값 받아오기
	request.setCharacterEncoding("utf-8"); //파라미터로 값 넘어갈 때 한글 안깨지게
	String start_date = request.getParameter("start_set_mb");   //시작일자
	String end_date = request.getParameter("end_set_mb");	    //끝일자
	String income_category = request.getParameter("type"); //입고유형
	String income_state =  request.getParameter("state"); //입고상태
	
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
         String sql_search  = "select count(*) from income t1, product t2, employee t3 where t1.product_no = t2.product_no and t1.employee_no = t3.employee_no  ";
      
         
	
	check = request.getParameterValues("condition");   //체크박스 체크 여부
	if (check != null){ //체크박스 값 넘어가는지 콘솔 출력 확인용
		for(int i=0;i<check.length;i++){
			System.out.println(check[i]+income_category);
		}

		for(int i=0;i<check.length;i++){
			if(check[i].equals("일자") && start_date != "" &&end_date !=""){ 
				sql += "and date(income_date) between '"+start_date+"' and '"+end_date+"' ";
				sql_search += "and date(income_date) between '"+start_date+"' and '"+end_date+"' ";	
			}else if(check[i].equals("입고유형") && income_category !=""){
				sql += "and t1.income_category = '"+income_category+"' ";
				sql_search += "and t1.income_category = '"+income_category+"' ";
			}else if(check[i].equals("입고상태") && income_state !=""){
				sql += "and t1.income_state = '"+income_state+"' ";
				sql_search += "and t1.income_state = '"+income_state+"' ";
			}
		
		}
		sql += "ORDER BY t1.income_num DESC LIMIT ? , ? ";
		
		 if(check.length ==1){
          	 searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&type="+income_category+"&state="+income_state;    
            }else if(check.length ==2){
            	searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&condition="+check[1]+"&type="+income_category+"&state="+income_state;         
            }else if(check.length ==3){
            	searchTypeKeyword ="&condition="+check[0]+"&start_set_mb="+start_date+"&end_set_mb="+end_date+"&condition="+check[1]+"&type="+income_category+"&condition="+check[2]+"&state="+income_state;        
             }
            
            pageContext.setAttribute("check",Arrays.toString(check));
            pageContext.setAttribute("start_date",start_date);
            pageContext.setAttribute("end_date",end_date);
            pageContext.setAttribute("income_category",income_category);
            pageContext.setAttribute("income_state",income_state);

	}else{
		sql += "ORDER BY t1.income_num DESC LIMIT ? , ? ";
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

 <form method="post" action="loading_returnexchange.jsp">
 		<table class="search2" border = "1px" >
            <thead>
              <tr>
                <td class="td_check"><input type="checkbox" name="condition" value="일자" <c:if test="${fn:contains(check, '일자') }">checked</c:if>/></td>
                <th>일자</th>
                <td><input type = "date" name = "start_set_mb" class="search_date" value="${start_date}"> - <input type = "date" name = "end_set_mb" class="search_date" value="${end_date}"></td>
                <td class="td_check"><input type="checkbox" name="condition" value="입고유형" <c:if test="${fn:contains(check, '입고유형') }">checked</c:if>/></td>
                <th>입고유형</th>
                <td>
	                <select name = "type" class="search_input">
				        <option value = "">선택</option>
				        <option value = "정상입고" <c:if test="${income_category eq '정상입고'}">selected</c:if>>정상입고</option>
				        <option value = "반품" <c:if test="${income_category eq '반품'}">selected</c:if>>반품</option>
				        <option value = "교환출고" <c:if test="${income_category eq '교환출고'}">selected</c:if>>교환출고</option>
				        <option value = "교환입고" <c:if test="${income_category eq '교환입고'}">selected</c:if>>교환입고</option>
		       		</select>
                </td>
                <td class="td_check"><input type="checkbox" name="condition" value="입고상태" <c:if test="${fn:contains(check, '입고상태') }">checked</c:if>/></td>
                <th>입고상태</th>
                <td>
	                <select name = "state" class="search_input">
				        <option value = "">선택</option>
				        <option value = "미입고" <c:if test="${income_state eq '미입고'}">selected</c:if>>미입고</option>
				        <option value = "입고" <c:if test="${income_state eq '입고'}">selected</c:if>>입고</option>
		            </select>
                </td>
                </tr>
                <tr>
	                <td class="search_btn" style="border-left: none;" colspan="9">
	                   <div class="search_btn_billing">    
	                           <button type="submit" onclick="check()">검색</button>
	                            <a href = "http://localhost:8080/purchase_ERP/add_billing.jsp"><a href = "http://localhost:8080/purchase_ERP/loading_returnexchange.jsp"><button type="button">초기화</button></a></a><br><br>
	                     </div> 
	                </td>
              </tr>
            </thead>
         </table>    
         </form>
         
         <form action="add_receiving.jsp" method="post" enctype="UTF-8">
         <table class="all_table2">
	         <tbody>
		         <tr>
		         	<td colspan="3">
						<table id = "ct_table" class="table custom-table">
							<thead>
								<tr>	
								<th id = "mb_td"></th>
								<th id = "mb_td">주문 번호</th>
								<th id = "mb_td">입고 유형</th>
								<th id = "mb_td">거래처명</th>
								<th id = "mb_td">품명</th>
								<th id = "mb_td">규격</th>
								<th id = "mb_td">단위</th>
								<th id = "mb_td">주문 일자</th>
								<th id = "mb_td">주문 수량</th>
								<th id = "mb_td">입고 일자</th>
								<th id = "mb_td">입고 수량</th>
								<th id = "mb_td">미입고 수량</th>
								<th id = "mb_td">단가</th>
								<th id = "mb_td">금액</th>
								<th id = "mb_td">부가세</th>
								<th id = "mb_td">총액</th>
								<th id = "mb_td">입고 상태</th>
				
								</tr>
							</thead>
										
						<tbody>
						<%while(true){
	
				            int product_count = rs.getInt("product_count");
				            int income_count = rs.getInt("income_count");
				            int nincome_count = rs.getInt("nincome_count");
						%>					
								<tr>
									<td><input type="checkbox" name="user_CheckBox"></td>
									<td class="selected_td"><%=rs.getString("income_no")%></td> <!--주문번호-->
									<td class="selected_td"><%=rs.getString("income_category")%></td> <!--입고유형-->
									<td class="selected_td"><%=rs.getString("client_name")%></td> <!--거래처명-->
									<td class="selected_td"><%=rs.getString("product_name")%></td> <!--품명-->
									<td class="selected_td"><%=rs.getString("product_standard")%></td> <!--규격-->
									<td class="selected_td"><%=rs.getString("product_unit")%></td> <!--단위-->	
									<td class="selected_td"><%=rs.getString("order_date")%></td> <!--주문일자-->
									<td class="selected_td"><%=rs.getInt("product_count")%></td> <!--주문수량-->
									<td class="selected_td"><%=rs.getString("income_date")%> <!--입고일자-->
									<td class="selected_td"><%=rs.getInt("income_count")%></td> <!--입고수량-->
									 <% if(nincome_count > 0){%>
							       <td class="selected_td" align="center" style=color:red; ><%=nincome_count %></td><!--미입고수량-->
							      <% }else{%>
							       <td  class="selected_td"align="center"></td><!--미입고수량-->
							      <%} %>	
									<td class="selected_td"><%=rs.getInt("product_unitprice")%></td> <!--단가-->
									<td class="selected_td"><%=rs.getInt("product_supply")%></td> <!--공급가액-->
									<td class="selected_td"><%=rs.getInt("order_vat")%></td> <!--부가세-->
									<td class="selected_td"><%=rs.getInt("order_price")%></td> <!--금액-->
								<% if(rs.getString("income_state").equals("미입고")){ %>
								    <td class="selected_td" align="center" style=color:red;><b><%=rs.getString("income_state")%></b></td> <!--입고상태-->
								     <%} else{%>
								    <td class="selected_td" align="center" style=color:blue><b><%=rs.getString("income_state")%></b></td> <!--입고상태-->
								     <%} %>
								</tr>
								<%if(!rs.next()) break;  }%>
												
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
					              <a href = "http://localhost:8080/purchase_ERP/loading_returnexchange.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>">〈</a>
					              <%} 
					             
					             if(startpage == 1){%>
					                <a class="not"></a>
					             <%}
					            for(int i=startpage; i<startpage+limit; i++){
					            %>
					             <a id="num<%=i %>" href = "http://localhost:8080/purchase_ERP/loading_returnexchange.jsp?currentpage=<%=i%><%=searchTypeKeyword%>"><%=i %></a>
					            	
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
					             <a href = "http://localhost:8080/purchase_ERP/loading_returnexchange.jsp?currentpage=<%=currentpage%><%=searchTypeKeyword%>">〉</a>     
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
                var income_no = td.eq(1).text()+" "
                var income_category = td.eq(2).text()+" "
                var client_name = td.eq(3).text()+" ";
                var product_name = td.eq(4).text()+" ";
                var product_standard = td.eq(5).text()+" ";
                var product_unit = td.eq(6).text()+" ";
                var order_date = td.eq(7).text()+" ";
                var product_count = td.eq(8).text()+" ";
                var product_unitprice = td.eq(12).text()+" ";
                var product_supply = td.eq(13).text()+" ";
                var order_vat = td.eq(14).text()+" ";
                var order_price = td.eq(15).text()+" ";
                
            
                
                
                // 가져온 값을 배열에 담는다.
                tdArr.push(income_no);
                tdArr.push(client_name);
                tdArr.push(product_name);
                tdArr.push(product_standard);
                tdArr.push(product_unit);
                tdArr.push(order_date);
                tdArr.push(product_count);
                tdArr.push(product_unitprice);
                tdArr.push(product_supply);
                tdArr.push(order_vat);
                tdArr.push(order_price);

                
                
                //console.log("order_no : " + order_no);
                //console.log("userid : " + userid);
                //console.log("name : " + name);
                //console.log("email : " + email); */
            });
            
           // $('input[name=inputResult]').attr('value',tdArr);
            //$("#ex3_Result1").html(" * 체크된 Row의 모든 데이터 = "+tdArr); 
            
           /*  입고 등록에 테이블 행 추가 */
        	opener.parent.tableCreate2(tdArr);
          
           	
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