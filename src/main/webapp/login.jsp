<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/expense_tracker";
    String dbUsername = "root";
    String dbPassword = "";

    // Retrieve form data
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    // Validate form inputs
    if (username == null || username.trim().isEmpty() ||
        password == null || password.trim().isEmpty()) {
        // Handle empty fields
        out.println("Both username and password are required.");
    } else {
        try {
            // Create database connection
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);
            PreparedStatement stmt = con.prepareStatement("SELECT * FROM users WHERE uname = ? AND password = ?");
            stmt.setString(1, username);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Successful login
                // Create session and store username
                session = request.getSession();
                session.setAttribute("username", username);
                int uid = rs.getInt("uid");
                session.setAttribute("uid",uid);

                // Redirect to home.jsp
                response.sendRedirect("home.jsp");
            } else {
                // Failed login
                out.println("Invalid username or password.");
            }

            // Close database connection
            con.close();
        } catch (Exception e) {
            out.println("An error occurred: " + e);
        }
    }
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Login</title>
   <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="container">
    <h2>User Login</h2>
    <form action="#" method="POST">
      <div class="form-group">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>
      </div>
      <div class="form-group">
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
      </div>
      <button type="submit">Login</button>
    </form>
  </div>
</body>
</html>
