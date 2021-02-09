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
			if(userID==null){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('로그인을 해주세요.')");
				script.println("location.href = 'login.jsp'");
				script.println("</script>");
			}
			int bbsID=0;
			//view.jsp에서 url파라메터로 보낸 bbsID를 받는다.
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
			Bbs bbs = new BbsDAO().getBbs(bbsID);//작성자로 bbs를 가져옴
			if(!userID.equals(bbs.getUserID())){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('수정권한이 없습니다.')");
				script.println("location.href = 'view.jsp'");
				script.println("</script>");
			}
			
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
    		</div>
    	</nav>
    	<div class="container">
    		<div class="row">
			  <form action="updateAction.jsp?bbsID=<%=bbsID %>" method="post">
				<table class="table table-striped" style="border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2"
								style="background-color: #eeeeee; text-align: center;">게시판
								수정 양식</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" class="form-control"
								placeholder="글 제목" name="bbsTitle" maxlength="50" 
								value="<%=bbs.getBbsTitle()%>"/></td><!-- 수정하기전제목확인 -->
						</tr>
						<tr>
							<td><textarea class="form-control"
									placeholder="글 내용" name="bbsContent" maxlength="2048"
									style="height: 350px;"><%=bbs.getBbsContent()%></textarea></td>
						</tr>
					</tbody>
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="수정하기"/>
			  </form>
    		</div>
    	</div>
		<script src="js/bootstrap.js"></script>
    </body>
</html>