package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	public BbsDAO() {
		try{
			//DB접속
			String dbURL = "jdbc:mysql://localhost:3306/BBS"; //localhost:3306 -> 설치된 mysql서버 자체
			String dbID ="root";
			String dbPassword="pass";
			Class.forName("com.mysql.jdbc.Driver");
			conn = DriverManager.getConnection(dbURL,dbID,dbPassword);
		} catch(Exception e){
			e.printStackTrace();
		}
	}
	public String getDate() { //현재시간을 가져오는 함수
		String SQL = "SELECT NOW()"; //현재시간을 가져오는 MYsql 문장
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //각각함수끼리 데이터베이스 접근에 있어서 충돌이 일어나지 않게 함수 안에 
			rs= pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return "";	 
	}
	
	public int getNext() {
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC"; //내림차순해서 가장 마지막에 쓴 번호 추출 
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //각각함수끼리 데이터베이스 접근에 있어서 충돌이 일어나지 않게 함수 안에 
			rs= pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1)+1; //내림차순했으니까 1번이 제일 마지막에 쓴 번호
			}
			return 1; // 첫번째 게시물인경우
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;	 
	}
	public int write(String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BBS VALUES (?,?,?,?,?,?)"; //글작성을 위해 여섯개의 인자 넣기
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //각각함수끼리 데이터베이스 접근에 있어서 충돌이 일어나지 않게 함수 안에 
			pstmt.setInt(1, getNext()); //게시글 번호
			pstmt.setString(2, bbsTitle); //게시글 제목
			pstmt.setString(3, userID); //게시글 작성 사용자
			pstmt.setString(4, getDate()); //작성날짜
			pstmt.setString(5, bbsContent); //내용
			pstmt.setInt(6, 1); //삭제여부
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류발생
	}
	
	public ArrayList<Bbs> getList(int pageNumber){ //특정한 페이지에 따른 게시글 목록을 가져오게
		//bbsID가 ? 보다 작고 삭제되지 않은 글(bbsAvailable =1)을 bbsID로 내림차순하여 10개만가져온다.
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable =1  ORDER BY bbsID DESC LIMIT 10";
		//Bbs클래스에서 나오는 객체를 보관할수 있는 리스트 생성
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //각각함수끼리 데이터베이스 접근에 있어서 충돌이 일어나지 않게 함수 안에 
			//getNext():마지막작성된 글의 번호 +1 에서 page당 10개씩 들어가니까 뒷페이지로 넘어간 게시물들을 빼준다.
			//그 뺀 값을 ?에 넣어서 현재 페이지의 게시글만 보이게 한다.
			pstmt.setInt(1, getNext() - (pageNumber -1) * 10);
			rs= pstmt.executeQuery();
			while(rs.next()) { //SELECT로 받아온 값이 있을때까지 Bbs에 ResultSet값 넣어주기
				Bbs bbs = new Bbs(); //자바빈즈를 이용해 대응하는 값 넣어주기
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs); //최종적으로 list에 bbs를 담기
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list; //bbs가 담긴 목록 반환	
	}
	
	//만약에 게시글이 10단위로 끊겼을때 10개 이하면 다음페이지가 존재하면 안되기 때문에 페이징처리를 해준다.
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable =1  ORDER BY bbsID DESC LIMIT 10";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //각각함수끼리 데이터베이스 접근에 있어서 충돌이 일어나지 않게 함수 안에 
			pstmt.setInt(1, getNext() - (pageNumber -1) * 10);
			rs= pstmt.executeQuery();
			while(rs.next()) { //다음것이 있다면 다음페이지로 넘어가게, 
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return false; //게시글이 10 배수라면 bbsID <1이 되어 반환 되는 값이 없기 떄문에 false처리가 된다.
	}
	
	public Bbs getBbs(int bbsID) { //게시글을 보여주는 함수
		String SQL = "SELECT * FROM BBS WHERE bbsID =?";
		try {
			PreparedStatement ps = conn.prepareStatement(SQL);
			ps.setInt(1, bbsID);
			rs = ps.executeQuery();
			while(rs.next()) { //SELECT로 받아온 값이 있을때까지 Bbs에 ResultSet값 넣어주기
				Bbs bbs = new Bbs(); //rs를 받아와 bbs클래스 set
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	public int update(int bbsID,String bbsTitle,String bbsContent) {
		//특정 bbsID에 해당하는 제목과 타이틀 바꾸기
		String SQL = "UPDATE BBS SET bbsTitle=?, bbsContent=? WHERE bbsID=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);  
			pstmt.setString(1, bbsTitle); //게시글 제목
			pstmt.setString(2, bbsContent); //게시글 내용
			pstmt.setInt(3, bbsID); //게시글 번호
			return pstmt.executeUpdate();
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류발생
	}
	
	public int delete(int bbsID) {
			//글을 삭제하더라도 글에대한 정보가 남아 있을수 있도록 bbsAvailable=0으로 바꿔줌으로 써 삭제글임을 표시
			String SQL = "UPDATE BBS SET bbsAvailable=0 WHERE bbsID=?";
			try {
				PreparedStatement pstmt = conn.prepareStatement(SQL); //각각함수끼리 데이터베이스 접근에 있어서 충돌이 일어나지 않게 함수 안에 
				pstmt.setInt(1, bbsID); //게시글 제목
				return pstmt.executeUpdate();
			}catch(Exception e) {
				e.printStackTrace();
			}
			return -1; //데이터베이스 오류발생
	}
	
	
	
}	