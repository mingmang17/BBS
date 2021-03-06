<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.io.PrintWriter" %>
<%@ page import = "bbs.Bbs" %>
<%@ page import = "bbs.BbsDAO" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta name="viewport" content="width=device",initial-scale="1">
		<link rel="stylesheet" href="css/bootstrap.css">
		<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
		<title>JSP 게시판 웹 사이트</title>
	</head>
	<body>
		<%
			//로그인 성공한 사람들은 userID로 세션값을 갖고,로그인을 안한 사람은 null
			String userID = null;
			if(session.getAttribute("userID") != null){
				userID = (String)session.getAttribute("userID");
			}
			int bbsID=0;
			//bbs.jsp에서 url파라메터로 보낸 bbsID를 받는다.
			if(request.getParameter("bbsID")!=null){
				bbsID= Integer.parseInt(request.getParameter("bbsID"));
			}
			if(bbsID==0){ //bbsID가 존재하지않으면 alert띄우고 bbs.jsp로 돌려보냄
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'bbs.jsp'");
				script.println("</script>");
			}
			//BbsDAO를 객체화시키는 동시에 getBbs함수(return값이 bbs)를 불러와서 bbsID에 해당하는 글 내용을 bbs에 넣는다.
			Bbs bbs = new BbsDAO().getBbs(bbsID);
		%>
 		<nav class="navbar navbar-default">
  			<div class="navbar-header">
   				<button type="button" class="navbar-toggle collapsed"
    				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
    				aria-expanded="false">
  				 	<span class="icon-bar"></span>
   				 	<span class="icon-bar"></span>
   					<span class="icon-bar"></span>
  				</button>  
  				<a class="navbar-brand" href="main.jsp">JSP 게시판 웹사이트</a>
 			</div>
 			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
  				<ul class="nav navbar-nav">
  					<li><a href="main.jsp">메인</a>
   					<li class="active"><a href="main.jsp">게시판</a>
  				</ul>
  				<%
  				//로그인 안한 사람들만 로그인/회원가입 보이게
  					if(userID == null){
  				%>
  				<ul class="nav navbar-nav navbar-right">
   					<li class="dropdown">
    					<a href="#" class="dropdown-toggle"
    						data-toggle="dropdown" role="button" aria-haspopup="true"
    						aria-expanded="false">접속하기<span class="caret"></span></a>
    					<ul class="dropdown-menu">
   				 			<li><a href="login.jsp">로그인</a></li>
    						<li ><a href="join.jsp">회원가입</a></li>
   						</ul>
    				</li>
    			</ul>		
  				<%
  					} else {
  						
  				%>
  				<ul class="nav navbar-nav navbar-right">
   					<li class="dropdown">
    					<a href="#" class="dropdown-toggle"
    						data-toggle="dropdown" role="button" aria-haspopup="true"
    						aria-expanded="false">회원관리<span class="caret"></span></a>
    					<ul class="dropdown-menu">
   				 			<li><a href="logoutAction.jsp">로그아웃</a></li>
   						</ul>
    				</li>
    			</ul>
    			<%
  					}
    			%>	
    		</div>
    	</nav>
    	<div class="container">
    		<div class="row">
				<table class="table table-striped" style="border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="3"
								style="background-color: #eeeeee; text-align: center;">게시판
								글 보기</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td style="width:20%;">글 제목</td>
							<!-- 위에서 getBbs함수를 실행시켜 bbs에 넣었기 때문에 bbs.getBbsTitle()은 해당 글 제목이 된다.-->
							<td colspan="2"><%= bbs.getBbsTitle()%> </td>
						</tr>
						<tr>
							<td>작성자</td>
							<!-- 위에서 getBbs함수를 실행시켜 bbs에 넣었기 때문에 bbs.getUserID()은 해당 글 작성자가 된다.-->
							<td colspan="2"><%= bbs.getUserID() %> </td>
						</tr>
						<tr>
							<td>작성일자</td>
							<td colspan="2"><%=bbs.getBbsDate().substring(0,11) + bbs.getBbsDate().substring(11,13) +"시" 
    							+bbs.getBbsDate().substring(14,16) + "분"%>
						</tr>
						<tr>
							<td>내용</td>
							<td colspan="2" style="height:200px; text-align:left;">
							<!-- 내용의 특수문자 처리,특수문자 처리 안해주면 내용도 제대로 안나올 뿐만 아니라 크로스사이트 스크립팅 공격도 방지 -->
							<%= bbs.getBbsContent().replaceAll(" ","&nbsp;").replaceAll("<", "&lt;") 
							.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%> </td>
						</tr>
					</tbody>
				</table>
				<a href="bbs.jsp" class="btn btn-primary">목록</a>
				<!-- userID와 작성자가 동일한경우 수정과 삭제가 가능하도록-->
				<% if(userID != null && userID.equals(bbs.getUserID())){ %>
					<a href = "update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
					<a onclick="return confirm('정말로 삭제하시겠습니까?')" href = "deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
				<%} %>
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기"/>
    		</div>
    	</div>
		<script src="js/bootstrap.js"></script>
    </body>
</html>