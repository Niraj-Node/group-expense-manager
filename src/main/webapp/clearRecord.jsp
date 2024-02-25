<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	try{
		String url = "jdbc:mysql://localhost:3306/expense_tracker";
	    String dbUsername = "root";
	    String dbPassword = "";
	    Class.forName("com.mysql.cj.jdbc.Driver");
	    Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
	    Integer uid1 = (Integer)session.getAttribute("uid");
	    if(uid1 == null){
	    	response.sendRedirect("login.jsp");
	    	return;
	    	
	    }
	    Integer uid2 = Integer.parseInt(request.getParameter("uid2")); 
	    String sql = "DELETE FROM `transactions` where (uid1 = ? AND uid2 = ?) OR (uid2 = ? AND uid1 = ?)";
	    PreparedStatement ps = con.prepareStatement(sql);
	    ps.setInt(1,uid1);
	    ps.setInt(2,uid2);
	    ps.setInt(3,uid1);
	    ps.setInt(4,uid2);
	    int i = ps.executeUpdate();
	    if(i > 0){
	    	response.sendRedirect("home.jsp");
	    	return;
	    }
	    con.close();
	   
	}  
	catch (SQLException ex) {
	    ex.printStackTrace();
	}
%>

</body>
</html>