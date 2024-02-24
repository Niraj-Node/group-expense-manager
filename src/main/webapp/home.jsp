<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>

<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Home</title>
<link rel="stylesheet" href="style1.css">
</head>
<body>
	<header>
		<h1>Expense Tracker</h1>
		<div class="search-bar">
			<input type="text" placeholder="Search...">
			<button>Search</button>
		</div>
		<div>
			<a class="menu-icon" style="margin-left: 30px;" href="profile.jsp">Profile</a>
			<a class="menu-icon" style="margin-left: 30px;" href="logout.jsp">Sign
				Out</a>
		</div>
	</header>

	<main>
		<div class="container">

			<% 
        String username = (String) session.getAttribute("username");
        if (username != null) { 
      %>

			<% 
        } else { 
      %>
			<p>You are not logged in.</p>
			<a href="reg.jsp">Register</a> <a href="login.jsp">Login</a>
			<% 
        } 
      %>
		</div>

		<% 
      if (username != null) { 
    %>
		<section class="group-section">
			<h2>Groups</h2>
			<button class="add-button">+</button>
			<div class="add-options">
				<ul style="height: 125px;">
					<li style="background-color: aqua; padding: 4px;"><a
						href="create.jsp">Create Group</a></li>
					<br>
					<li style="background-color: aqua; padding: 4px;"><a
						href="join.jsp">Join Group</a></li>
				</ul>
			</div>

			<%
           try{
        	   String url = "jdbc:mysql://localhost:3306/expense_tracker";
               String dbUsername = "root";
               String dbPassword = "";
               Class.forName("com.mysql.cj.jdbc.Driver");
               Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
      
               String sql = "SELECT * FROM users WHERE uname = ?";
               PreparedStatement ps = con.prepareStatement(sql);
               ps.setString(1, username);
               ResultSet rs = ps.executeQuery();
               int uid = 0;
               if(rs.next()){
            	   uid = rs.getInt("uid");
               }
               
               sql = "SELECT * FROM groups_users WHERE uid = ?";
               ps = con.prepareStatement(sql);
               ps.setInt(1, uid);
               rs = ps.executeQuery();
               %>
               <ul>
               <% 
               while(rs.next()) {
            	   int gid = rs.getInt("gid");
                   String groupName = rs.getString("gname");
                  %>
			
				<li>
					<div style="display: flex; justify-content: space-between">
						<div>
							<% 
                   out.print(groupName);
                    %>
						</div>

						<div>
							<% 
                   out.println("Group-Code: " + gid);
                  %>
						</div>
					</div>
				</li>
				<% 
               }
               %>
               </ul>
               <% 
             
              con.close();
           }catch (SQLException ex) {
               ex.printStackTrace();
           }
           %>
		   

		</section>

		<section class="dues-section">
		
            <h2>Dues</h2>
            <ul>
            <%
            String url = "jdbc:mysql://localhost:3306/expense_tracker";
            String dbUsername = "root";
            String dbPassword = "";
            Connection con1 = DriverManager.getConnection(url, dbUsername, dbPassword);
            
               int userId=Integer.parseInt(session.getAttribute("uid").toString());
               String sql1="SELECT * FROM `transactions`,users WHERE users.uid=transactions.uid2 AND transactions.uid1=?";
               PreparedStatement ps1 = con1.prepareStatement(sql1);
               ps1.setInt(1, userId);
               ResultSet res = ps1.executeQuery();
               
               while(res.next())
              
               {
            %>
              
                <li>
                    <span class="person-name"><%= res.getString("uname") %></span>
                    <span class="levana"> 0000</span>
                    <span class="devana"> <%= res.getInt("amount") %></span>
                    <button class="clear-button"><a href="clearRecord.jsp">Clear</a></button>
                </li>
             <%
               }
               sql1="SELECT * FROM `transactions`,users WHERE users.uid=transactions.uid1 AND transactions.uid2=?";
                ps1 = con1.prepareStatement(sql1);
               ps1.setInt(1, userId);
                res = ps1.executeQuery();
               
               while(res.next())
              
               {
              
              
             %>
             <li>
                    <span class="person-name"><%= res.getString("uname") %></span>
                    <span class="levana"><%= res.getInt("amount") %> </span>
                    <span class="devana">0000 </span>
                    <button class="clear-button"><a href="clearRecord.jsp">Clear</a></button>
                </li>
               <%
               }
               con1.close();
               %>
            </ul>
        </section>
		<% 
      } 
    %>
	</main>
	<%--Test --%>
	<footer>
		<p>Contact us @expense.tracker@gmail.com</p>
	</footer>
</body>
</html>
