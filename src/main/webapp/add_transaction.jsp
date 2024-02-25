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
	<header>
		<h1>Expense Tracker</h1>
		<div>
			<a class="menu-icon" style="margin-left: 30px;" href="create.jsp">Profile</a>
			<a class="menu-icon" style="margin-left: 30px;" href="create.jsp">Sign
				Out</a>
		</div>
	</header>
	<h2
		style="display: flex; justify-content: space-around; font-size: 300%;">Group
		Name</h2>
	<form action="submit_t.jsp" method="post">
		<button class="add-transaction-button" style="margin-left: 78%;">Add</button>
		<main>
			<ul>
				<%
		try{
			String url = "jdbc:mysql://localhost:3306/expense_tracker";
		    String dbUsername = "root";
		    String dbPassword = "";
		    Class.forName("com.mysql.cj.jdbc.Driver");
		    Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
		    Integer gid = Integer.parseInt(request.getParameter("gid"));
		    Integer uid = (Integer) session.getAttribute("uid");
		    if(uid == null)
		    {
		    	response.sendRedirect("home.jsp");
		    	return;
		    }
		    
		    String sql = "SELECT * FROM groups_users WHERE gid = ?";
		    PreparedStatement ps = con.prepareStatement(sql);
		    ps.setInt(1, gid);
		    ResultSet rs = ps.executeQuery();
		    
		    int flag = 0;
		    while(rs.next())
		    {
		    	Integer uid1 = new Integer(rs.getInt("uid"));
		    	
		    	if(uid1.equals(uid))
		    	{
		    		flag = 1;
		    		break;
		    	}
		    }
		    if(flag == 0){
		    	response.sendRedirect("home.jsp");
		    	return;
		    }
		    
			sql = "SELECT * FROM users WHERE uid IN(SELECT uid FROM groups_users WHERE gid = ?)";
	        ps = con.prepareStatement(sql);
	        ps.setInt(1, gid);
	        rs = ps.executeQuery();
	  
			
	        while(rs.next())
	        {
	        	%>
				<li class="add-transaction-list"><span class="person-name">
				<input type="radio" name="pid" value="<%=rs.getInt("uid")%>">
						<%= rs.getString("uname") %></span> <input type="number" name="<%=rs.getInt("uid") %>"
					class="number-input" value="0" min="0" max="9999999"></li>
				<%
	        }
	        
	        con.close();
		}
	        catch(SQLException ex) {
			    ex.printStackTrace();
			}
	        %>
	          
				<!-- <li class="add-transaction-list" id="total-sum">Total Sum: 0</li> -->
			</ul>
		</main>
		<input type="number" name="gid" value="<%=request.getParameter("gid") %>" hidden>
	</form>
	<footer>
		<p>Contact us @expense.tracker@gmail.com</p>
	</footer>
</body>
</html>