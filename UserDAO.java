package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
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
	public int login(String userID, String userPassword) {
		//쿼리준비
		String SQL = "SELECT userPassword FROM USER WHERE userID=?";
		try {
			//Connection으로 부터 PreparedStatement 가져오기
			pstmt = conn.prepareStatement(SQL);
			//쿼리문 ?에 값넣기
			pstmt.setString(1, userID);
			//쿼리 실행
			rs = pstmt.executeQuery();
			if (rs.next()) { //다음것이있나?true/false로 반환
				//rs.getString(1) -> 쿼리 실행한것중 첫번째
				if(rs.getString(1).equals(userPassword)) { //sql로 실행한 비번과 접속시도한 비번이 맞으면 로그인 성공
					return 1;//로그인 성공
				}else {
					return 0; //비밀번호 불일치
				}
			}
			return -1; //아이디가 없음
		}catch(Exception e){
			e.printStackTrace();
		}
		return -2; //데이터베이스오류의미
	}
	public int join(User user) {//user클래스 이용해서 만들어질수 있는 하나의 객체
		String SQL = "INSERT INTO USER VALUES (?,?,?,?,?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}
}
