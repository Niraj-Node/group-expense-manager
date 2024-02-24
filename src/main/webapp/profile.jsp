<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Profile</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="container">
    <h2>User Profile</h2>
    <form action="update.jsp" method="POST">
<%
// Retrieve session data
String username = (String) session.getAttribute("username");

if (username != null) {
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/expense_tracker";
    String dbUsername = "root";
    String dbPassword = "";

    try {
        // Create database connection
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

        // Retrieve user data from the database
        PreparedStatement stmt = con.prepareStatement("SELECT * FROM users WHERE uname = ?");
        stmt.setString(1, username);
        ResultSet rs = stmt.executeQuery();

        if (rs.next()) {
            // Retrieve user data from the result set
            String uname = rs.getString("uname");
            String fname = rs.getString("fname");
            String lname = rs.getString("lname");
%>
      <div class="form-group">
        <label for="username">Username:</label>
        <input type="text" id="username" style="border:none;" name="username" value="<%= uname %>" readonly>
      </div>
      <div class="form-group">
        <label for="firstname">First Name:</label>
        <input type="text" id="firstname" name="firstname" value="<%= fname %>" required>
      </div>
      <div class="form-group">
        <label for="lastname">Last Name:</label>
        <input type="text" id="lastname" name="lastname" value="<%= lname %>" required>
      </div>
<%
            }
            // Close database connection
            con.close();
        } catch (Exception e) {
            // Handle database connection or query error
            out.println("An error occurred: " + e);
        }
    } else {
        // User not logged in
        response.sendRedirect("login.jsp");
    }
%>
      <button type="submit">Update Data</button>
    </form>
  </div>
</body>
</html>
