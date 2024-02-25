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
<%! String gname; %>
       
    <header>
        <h1>Expense Tracker</h1>
        <div>
            <a class="menu-icon" style="margin-left: 30px;" href="create.html">Profile</a>
            <a class="menu-icon" style="margin-left: 30px;" href="create.html">Sign Out</a>
        </div>
    </header>
 <%
       try{
	   		String url = "jdbc:mysql://localhost:3306/expense_tracker";
		    String dbUsername = "root";
		    String dbPassword = "";
		    Class.forName("com.mysql.cj.jdbc.Driver");
		    Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
		    String sql;
		    PreparedStatement ps;
		    ResultSet rs;
           Integer gid = Integer.parseInt(request.getParameter("gid"));  
           Integer uid = (Integer) session.getAttribute("uid");
           
           if(gid == null || uid == null)
           {
        	   response.sendRedirect("home.jsp");
        	   return;
           }
           
           sql = "SELECT * FROM groups_users WHERE gid=? AND uid=?";
           ps = con.prepareStatement(sql); 
           ps.setInt(1, gid);
           ps.setInt(2, uid);
           rs = ps.executeQuery();
           
           if(!rs.next()) {
        	   response.sendRedirect("home.jsp");
        	   return;
           }
           gname=rs.getString("gname");
           %>
    <h2 style="display: flex;justify-content: space-around;font-size:300%;"><%=gname%></h2>
    <ul>
    <li>
            <span class="group-list-head"><b>Transaction No</b></span>
            <span class="group-list-head"><b>Paid By</b></span>
            <span class="group-list-head"><b>Amount</b></span>
            <span class="group-list-head"><b>Description</b></span>
        </li>
      <%
           
           
           sql = "SELECT * FROM `history` WHERE gid=?";
           ps = con.prepareStatement(sql);
           ps.setInt(1,gid);
           rs = ps.executeQuery();
           while(rs.next()){
        	   %>
        	   
        	   <li>
            <span class="group-list-head"><%=rs.getInt("tid") %></span>
            
            <% String description=rs.getString("description");
               
               String l[]=description.split(",");
               String p[]=l[0].split("-");
            
            %>
            
            
            <span class="group-list-head"><%=p[0] %></span>
            <span class="group-list-head"><%=p[1] %></span>
            <button class="description-button" style="margin-right: 300px;"><a href="description.jsp" > description</a></button>
        </li>
        	   
        	   
        	   <%
           }
           }
           
       catch (SQLException ex) {
	       ex.printStackTrace();
	   }
       %>
        
       
    </ul>

    <footer>
        <p>Contact us @expense.tracker@gmail.com</p>
    </footer>
  
</body>
</html>