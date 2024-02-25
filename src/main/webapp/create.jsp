<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Expense Tracker</title>
<link rel="stylesheet" href="style1.css">

</head>
<body>
   
	<%

	if("POST".equalsIgnoreCase(request.getMethod())){
	
	Integer uid = (Integer)session.getAttribute("uid");
    if(uid != null){
    	try{
    	String url = "jdbc:mysql://localhost:3306/expense_tracker";
        String dbUsername = "root";
        String dbPassword = "";
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
        String gname = request.getParameter("group-name");
        PreparedStatement ps = null;
        int sum1 = 0;
        String sql = "SELECT SUM(gid) AS 'total_sum' FROM groups";
        ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            sum1 = rs.getInt("total_sum");
        }
        
        sql = "INSERT INTO groups(uid, group_name) values(?,?)";
        ps = con.prepareStatement(sql);
        ps.setString(2,gname);
        ps.setInt(1,uid);
        ps.executeUpdate();
        int sum2 = 0;
        sql = "SELECT SUM(gid) AS 'total_sum' FROM groups";
        ps = con.prepareStatement(sql);
        rs = ps.executeQuery();
        if (rs.next()) {
            sum2 = rs.getInt("total_sum");
        }
        
        int gid = sum2-sum1;
       
        sql = "INSERT INTO groups_users (gid,uid,gname) values (?,?,?)";
        ps = con.prepareStatement(sql);
        ps.setInt(1,gid);
        ps.setInt(2,uid);
        ps.setString(3,gname);
        int i = ps.executeUpdate();
        con.close();
        
        }catch (SQLException ex) {
            ex.printStackTrace();
        }
    }
	}
%>
	<header>
		<h1>Expense Tracker</h1>
		<div>
			<a class="menu-icon" style="margin-left: 30px;" href="create.html">Profile</a>
			<a class="menu-icon" style="margin-left: 30px;" href="create.html">Sign
				Out</a>
		</div>
	</header>

	<main>
		<div class="create-group">
			<h1>Create Group</h1>
			<form action="" method="post">
				<label for="group-name">Group Name</label> <input type="text"
					id="group-name" name="group-name" placeholder="Enter Group name"
					required>
				<button type="submit">Submit</button>
			</form>
		</div>
	</main>

	<footer>
		<p>Contact us @expense.tracker@gmail.com</p>
	</footer>
</body>
</html>