<%@page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="util.DatabaseUtil"%>
<%@page import="java.sql.Connection"%>

<!DOCTYPE html>
<script type="text/javascript" src="https://code.jquery.com/jquery-3.2.0.min.js" ></script>
<%@page import="common.common" %>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">

  <meta http-equiv="X-UA-Compatible" content="IE=edge">

  <meta name="copyright" content="MACode ID, https://macodeid.com/">

<title>한국인의 맛, 서대문 김치명가</title>

  <link rel="stylesheet" href="<%=common.url%>/assets/css/bootstrap.css">
  
  <link rel="stylesheet" href="<%=common.url%>/assets/css/maicons.css">

  <link rel="stylesheet" href="<%=common.url%>/assets/vendor/animate/animate.css">

  <link rel="stylesheet" href="<%=common.url%>/assets/vendor/owl-carousel/css/owl.carousel.css">

  <link rel="stylesheet" href="<%=common.url%>/assets/vendor/fancybox/css/jquery.fancybox.css">

  <link rel="stylesheet" href="<%=common.url%>/assets/css/theme.css">

</head>

<body>
<% // 로그인
   String employee_id = (String)session.getAttribute("employee_no");
   String name = null;
   if(session.getAttribute("name") != null){
      name = (String)session.getAttribute("name");
   }
    Connection conn_log = DatabaseUtil.getConnection();
    String sql_log = "select employee_name from employee where employee_no = '"+employee_id+"'"; 
    PreparedStatement pstmt_log = conn_log.prepareStatement(sql_log);
   ResultSet rs_log = pstmt_log.executeQuery(sql_log);
   if(rs_log.next()){
      name = rs_log.getString("employee_name");
   } 
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
            <%
               //로그인하지 않았을때 보여지는 화면
               if(name == null) {
               %>
                로그인 정보가 없습니다.
               <a href = "http://localhost:8080/purchase_ERP/login.jsp">로그인</a>
             
            <%
               //로그인 했을때 보여지는 화면
               } else {
              %>
               <%=name %>님이 로그인하셨습니다. &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <a href="http://localhost:8080/purchase_ERP/logout.jsp">로그아웃</a>
                  
           <%
                }
             %>
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
              <a href="http://localhost:8080/purchase_ERP/add_billing.jsp" class="nav-link">구매자재</a>
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

   <!-- 배너  -->
    <div class="page-banner home-banner mb-5">
      <div class="slider-wrapper">
        <div class="owl-carousel hero-carousel">
          <div class="hero-carousel-item">
            <img src="./assets/img/kimchi.jpg" alt="">
            <div class="img-caption">
              <div class="subhead">서대문 김치名家</div>
              <h1 class="mb-4">명품 배추김치</h1>
              <a href="#services" class="btn btn-outline-light">구매하기</a>
            </div>
          </div>
          <div class="hero-carousel-item">
            <img src="./assets/img/kimchi2.jpg" alt="">
            <div class="img-caption">
              <div class="subhead">서대문 김치名家</div>
              <h1 class="mb-4">명품 깍두기</h1>
              <a href="#services" class="btn btn-outline-light">더 알아보기</a>
              <a href="#services" class="btn btn-primary">구매하기</a>
            </div>
          </div>
          <div class="hero-carousel-item">
            <img src="./assets/img/kimchi4.jpg" alt="">
            <div class="img-caption">
              <div class="subhead">서대문 김치名家</div>
              <h1 class="mb-4">명품 김치</h1>
              <a href="#services" class="btn btn-primary">더 알아보기</a>
            </div>
          </div>
        </div>
      </div> <!-- .slider-wrapper -->
    </div> <!-- .page-banner -->
  </header>

  <main>
    <div class="page-section">
      <div class="container">
        <div class="row align-items-center">
          <div class="col-lg-6 py-3">
            <div class="subhead">About Our ERP</div>
            <h2 class="title-section">저희 <span class="fg-primary">ERP</span>를 소개합니다.</h2>

            <p>회사의 업무 효율을 높이기 위해 꼭 필요한 ERP를 맞춤으로 제공합니다.</p>

            <a href="about.html" class="btn btn-primary mt-4">더 알아보기</a>
          </div>
          <div class="col-lg-6 py-3">
            <div class="about-img">
              <img src="./assets/img/aboutus.JPG" alt="">
            </div>
          </div>
        </div>
      </div>
    </div> <!-- .page-section -->

  

    <div class="page-section">
      <div class="container">
        <div class="text-center">
          <div class="subhead">R&D Teams</div>
          <h2 class="title-section">배추도사 무도사</h2>
        </div>

        <div class="owl-carousel team-carousel mt-5">
          <div class="team-wrap">
            <div class="team-profile">
              <img src="../assets/img/teams/team_1.jpg" alt="">
            </div>
            <div class="team-content">
              <h5>김현정</h5>
              <div class="text-sm fg-grey">2020771005</div>

              <div class="social-button">
                
                <a href="#"><span class="mai-logo-facebook-messenger"></span></a>
                <a href="#"><span class="mai-call"></span></a>
                <a href="#"><span class="mai-mail"></span></a>
              </div>
            </div>
          </div>

          <div class="team-wrap">
            <div class="team-profile">
              <img src="../assets/img/teams/team_2.jpg" alt="">
            </div>
            <div class="team-content">
              <h5>김혜진</h5>
              <div class="text-sm fg-grey">2021771006</div>

              <div class="social-button">
                <a href="#"><span class="mai-logo-facebook-messenger"></span></a>
                <a href="#"><span class="mai-call"></span></a>
                <a href="#"><span class="mai-mail"></span></a>
              </div>
            </div>
          </div>

          <div class="team-wrap">
            <div class="team-profile">
              <img src="../assets/img/teams/team_3.jpg" alt="">
            </div>
            <div class="team-content">
              <h5>박정우</h5>
              <div class="text-sm fg-grey">2021771008</div>

              <div class="social-button">
                <a href="#"><span class="mai-logo-facebook-messenger"></span></a>
                <a href="#"><span class="mai-call"></span></a>
                <a href="#"><span class="mai-mail"></span></a>
              </div>
            </div>
          </div>

        <div class="team-wrap">
            <div class="team-profile">
              <img src="../assets/img/teams/team_3.jpg" alt="">
            </div>
            <div class="team-content">
              <h5>이예닮</h5>
              <div class="text-sm fg-grey">2021771011</div>

              <div class="social-button">
                <a href="#"><span class="mai-logo-facebook-messenger"></span></a>
                <a href="#"><span class="mai-call"></span></a>
                <a href="#"><span class="mai-mail"></span></a>
              </div>
            </div>
          </div>
          
          <div class="team-wrap">
            <div class="team-profile">
              <img src="../assets/img/teams/team_3.jpg" alt="">
            </div>
            <div class="team-content">
              <h5>이지예</h5>
              <div class="text-sm fg-grey">2021771013</div>

              <div class="social-button">
                <a href="#"><span class="mai-logo-facebook-messenger"></span></a>
                <a href="#"><span class="mai-call"></span></a>
                <a href="#"><span class="mai-mail"></span></a>
              </div>
            </div>
          </div>
          
          <div class="team-wrap">
            <div class="team-profile">
              <img src="../assets/img/teams/team_3.jpg" alt="">
            </div>
            <div class="team-content">
              <h5>임수린</h5>
              <div class="text-sm fg-grey">2021771014</div>

              <div class="social-button">
                <a href="#"><span class="mai-logo-facebook-messenger"></span></a>
                <a href="#"><span class="mai-call"></span></a>
                <a href="#"><span class="mai-mail"></span></a>
              </div>
            </div>
          </div>
        </div>
      </div> <!-- .container -->
    </div> <!-- .page-section -->
    

  </main>

  <footer class="page-footer">
    <div class="container">
      <div class="row">
        <div class="col-lg-3 py-3">
          <h3>서대문<span class="fg-primary">김치명가</span></h3>
        </div>
        <div class="col-lg-3 py-3">
          <h5>Contact Information</h5>
          <p>03656) 서울특별시 서대문구 가좌로 134(서울특별시 서대문구 홍은 2동)</p>
          <p>Email: kimchimyeongga@mail.com</p>
          <p>Phone: 02-303-7777</p>
        </div>
        <div class="col-lg-3 py-3">
          <h5>Company</h5>
          <ul class="footer-menu">
            <li><a href="#">Career</a></li>
            <li><a href="#">Resources</a></li>
            <li><a href="#">News & Feed</a></li>
          </ul>
        </div>
        <div class="col-lg-3 py-3">
          <h5>Newsletter</h5>
          <form action="#">
            <input type="text" class="form-control" placeholder="Enter your email">
            <button type="submit" class="btn btn-primary btn-sm mt-2">Submit</button>
          </form>
        </div>
      </div>

      <hr>

      <div class="row mt-4">
        <div class="col-md-6">
          <p>Copyright 2020. This template designed by <a href="https://macodeid.com">MACode ID</a></p>
        </div>
        <div class="col-md-6 text-right">
          <div class="sosmed-button">
            <a href="#"><span class="mai-logo-facebook-f"></span></a>
            <a href="#"><span class="mai-logo-twitter"></span></a>
            <a href="#"><span class="mai-logo-youtube"></span></a>
            <a href="#"><span class="mai-logo-linkedin"></span></a>
          </div>
        </div>
      </div>
    </div>
  </footer>

  
<script src="<%=common.url%>/assets/js/jquery-3.5.1.min.js"></script>

<script src="<%=common.url%>/assets/js/bootstrap.bundle.min.js"></script>

<script src="<%=common.url%>/assets/vendor/owl-carousel/js/owl.carousel.min.js"></script>

<script src="<%=common.url%>/assets/vendor/wow/wow.min.js"></script>

<script src="<%=common.url%>/assets/vendor/fancybox/js/jquery.fancybox.min.js"></script>

<script src="<%=common.url%>/assets/vendor/isotope/isotope.pkgd.min.js"></script>

<script src="<%=common.url%>/assets/js/google-maps.js"></script>

<script src="<%=common.url%>/assets/js/theme.js"></script>

<!-- <script async defer src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAIA_zqjFMsJM_sxP9-6Pde5vVCTyJmUHM&callback=initMap"></script> -->

</body>
</html>