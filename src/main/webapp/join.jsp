<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Expense Tracker</title>
    <link rel="stylesheet" href="style1.css">
    <style>
        /* Additional styles for create.jsp */
        /* You can add more styles specific to this page here */
    </style>
</head>
<body>
<% 
    String username = (String) session.getAttribute("username");
    if (username != null) { 
%>
    <header>
        <h1>Expense Tracker</h1>
        <div>
            <a class="menu-icon" style="margin-left: 30px;" href="create.jsp">Profile</a>
            <a class="menu-icon" style="margin-left: 30px;" href="create.jsp">Sign Out</a>
        </div>
    </header>
<%
    if ("POST".equalsIgnoreCase(request.getMethod())){
        String url = "jdbc:mysql://localhost:3306/expense_tracker";
        String dbUsername = "root";
        String dbPassword = "";
        String gcode = request.getParameter("gcode");
        String groupName = request.getParameter("group-name"); // New input field for group name
        int uid = Integer.parseInt(session.getAttribute("uid").toString());
        
        // Check if group name is empty
        if (groupName.isEmpty()) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword);
                PreparedStatement pstmt = conn.prepareStatement("SELECT group_name FROM groups WHERE gid = ?");
                pstmt.setString(1, gcode);
                ResultSet rs = pstmt.executeQuery();
                if (rs.next()) {
                    groupName = rs.getString("group_name");
                }
                rs.close();
                pstmt.close();
                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, dbUsername, dbPassword);
            PreparedStatement pstmt = conn.prepareStatement("INSERT INTO groups_users (gid, uid, gname) VALUES (?, ?, ?)");
            pstmt.setString(1, gcode); // Assuming gcode is for gid
            pstmt.setInt(2, uid);
            pstmt.setString(3, groupName); // New input field for group name
            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>
    <main>
        <div class="create-group">
            <h1>Join Group</h1>
            <form action="#" method="post">
                <label for="group-code">Group Code</label>
                <input type="text" id="group-code" name="gcode" placeholder="Enter Group Code" required>
                <!-- New input field for group name -->
                <label for="group-name">Group Name</label>
                <input type="text" id="group-name" name="group-name" placeholder="Leave blank for default group name">
                <button type="submit">Submit</button>
            </form>
        </div>
    </main>
<% 
    } else { 
%>
    <p>You are not logged in.</p>
    <a href="reg.jsp">Register</a> <a href="login.jsp">Login</a>
<% 
    } 
%>
    <footer>
        <p>Contact us @expense.tracker@gmail.com</p>
    </footer>
</body>
</html>
