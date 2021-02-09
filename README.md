## JSP를 이용한 게시판만들기
[자세한 설명은 블로그 참조](https://velog.io/@mingmang17?tag=JSP-%EA%B2%8C%EC%8B%9C%ED%8C%90%EB%A7%8C%EB%93%A4%EA%B8%B0)
### 로그인 페이지 디자인
* [로그인 페이지](./login.jsp)
### 회원가입 페이지 디자인
* [회원가입 페이지](./join.jsp)
### 회원 데이터베이스 구축
* [mysql을 이용한 데이터베이스 구축](./database구축.txt)
  - userID를 PRIMARY KEY로 설정
* [JavaBeans](./User.java)
### 로그인 기능 구현
* [DAO(데이터베이스 접근 객체)](./UserDAO.java)
  - DB접속
  - 로그인기능해서 사용하는 login()
  - 회원가입기능에서 사용하는 join()
* [로그인 기능 구현](./loginAction.jsp)
  <ul>  
    <li>로그인 하면 세션값 할당</li>
    <li>이미 로그인 된 상태라면 또 다시 로그인해서 세션값을 얻지 못하도록 만들어 줌</li>
    <li>아이디와 비밀번호를 받아와서 userDAO.login함수 실행</li>
    <li>데이터베이스의 값과 비교해 정상적인 ID,PW 일 때 로그인 성공</li>
    <li>비정상적인 값이 들어왔다면 해당 내용에 따라 반환</li>
  </ul>  
### 회원가입 기능 구현
* [DAO(데이터베이스 접근 객체)](./UserDAO.java)
  - DB접속
  - 로그인기능해서 사용하는 login()
  - 회원가입기능에서 사용하는 join()
* [회원가입 기능 구현](./UserDAO.java)
  - 이미 로그인 된 사람은 회원가입 페이지에 접속할수 없게 함
  - 하나라도 입력되지 않은 값이 있으면 alert후 이전페이지로 돌려보냄
  - 모든 값을 입력했을 경우 userDAO.join함수 실행
  - join함수를 통해 이미 존재하는 ID를 입력했을 시 alert후 이전페이지로 돌려보냄
  - join함수를 통해 모든 값이 정상적으로 들어왔을 때는 세션값을 갖고 메인페이지로 이동
### 회원 데이터베이스 구축
* [mysql을 이용한 데이터베이스 구축](./bbs.txt)
  - bbsID를 PRIMARY KEY로 설정
* [JavaBeans](./Bbs.java)

### 글쓰기 기능 구현
* [DAO(데이터베이스 접근 객체)](./BbsDAO.java)
  - DB접속
  - 현재시간을 가져오는 getDate()
  - 글 번호를 지정하는 getNext()
  - 글쓰기 기능을 구현한 write()
    - bbsTitle과 bbsContent는 write.jsp에서 받아와 name과 자바빈의 property명과 동일한 것에 
      대응하여 데이터베이스에 값을 넣는다.
* [글쓰기 기능 사용](./write.jsp)
* [받은 값을 이용하여 정상적으로 글쓰기 기능을 사용할 수 있는지 판단](./writeAction.jsp)

### 게시판 글 목록 기능 구현
* [DAO(데이터베이스 접근 객체)](./BbsDAO.java)
  - DB접속
  - 게시판 글 목록을 보여주는 getList()추가
    - 10개단위로 페이지가 넘어가게 한다.
  - 10개단위로 페이징 처리해주는 nextPage()추가
* [게시판](./bbs.jsp)
  - getList()를 호출하여 게시판 글 목록을 보여준다.
  - nextPage()를 호출하여 페이징처리

### 게시판 글 보기 기능 구현
* [DAO(데이터베이스 접근 객체)](./BbsDAO.java)
  - DB접속
  - bbsID를 받아와서 해당 데이터를 불러오는 getBbs()추가
* [글 보기 기능](./view.jsp)
  - getBbs()를 호출하여 특정 bbsID에 해당하는 데이터를 불러온다.

### 게시판 글 수정, 삭제 기능 구현
* [DAO(데이터베이스 접근 객체)](./BbsDAO.java)
  - DB접속
  - 특정 bbsID에 해당하는 제목과 내용 바꾸는 update()추가
  - 특정 bbsID에 해당하는 글을 삭제하는 delete()추가
    - 글을 삭제하더라도 글에대한 정보가 남아 있을수 있도록 bbsAvailable=0으로 바꿔줌으로 써 
  삭제글임을 표시한다.
    - bbsAvailable=0은 getList()로인해 게시판에서 보이지 않는다.
* [게시판 수정 기능](./update.jsp)
  - bbsID(작성자)와 UserID(사용자)를 비교하여 같지 않을 경우 alert후 돌려보낸다.
* [받은 값을 이용하여 정상적으로 글 수정 기능을 사용할 수 있는지 판단](./updateAction.jsp)
* [받은 값을 이용하여 정상적으로 글  기능을 사용할 수 있는지 판단](./updateAction.jsp)
