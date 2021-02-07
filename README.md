## JSP를 이용한 게시판만들기
[자세한 설명은 블로그 ](https://velog.io/@mingmang17?tag=JSP-%EA%B2%8C%EC%8B%9C%ED%8C%90%EB%A7%8C%EB%93%A4%EA%B8%B0)
### 로그인 페이지 디자인
* [로그인 페이지](./login.jsp)
### 회원가입 페이지 디자인
* [회원가입 페이지](./join.jsp)
### 회원 데이터베이스 구축
* [mysql을 이용한 데이터베이스 구축](./database구축.txt)
  - userID를 PRIMARY KEY로 설정
* [JavaBeans](./User.java)
### 로그인 기능 구현
* [DAO](./UserDAO.java)
  - DB접속
  - 로그인기능해서 사용하는 login함수
  - 회원가입기능에서 사용하는 join함수
* [로그인 기능 구현](./loginAction.jsp)
  <ul>  
    <li>로그인 하면 세션값 할당</li>
    <li>이미 로그인 된 상태라면 또 다시 로그인해서 세션값을 얻지 못하도록 만들어 줌</li>
    <li>아이디와 비밀번호를 받아와서 userDAO.login함수 실행</li>
    <li>데이터베이스의 값과 비교해 정상적인 ID,PW 일 때 로그인 성공</li>
    <li>비정상적인 값이 들어왔다면 해당 내용에 따라 반환</li>
  </ul>  
### 회원가입 기능 구현
* [DAO](./UserDAO.java)
  - DB접속
  - 로그인기능해서 사용하는 login함수
  - 회원가입기능에서 사용하는 join함수
* [회원가입 기능 구현](./UserDAO.java)
  - 이미 로그인 된 사람은 회원가입 페이지에 접속할수 없게 함
  - 하나라도 입력되지 않은 값이 있으면 alert후 이전페이지로 돌려보냄
  - 모든 값을 입력했지만 이미 존재하는 ID를 입력했을 시 alert후 이전페이지로 돌려보냄
  - 모든 값이 정상적으로 들어왔을 때는 세션값을 갖고 메인페이지로 이동
