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
    String firstName = request.getParameter("firstname");
    String lastName = request.getParameter("lastname");
    String phone = request.getParameter("phone");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirm-password");

    // Validate form inputs
    if (username == null || username.trim().isEmpty() ||
        firstName == null || firstName.trim().isEmpty() ||
        lastName == null || lastName.trim().isEmpty() ||
        phone == null || phone.trim().isEmpty() ||
        password == null || password.trim().isEmpty() ||
        confirmPassword == null || confirmPassword.trim().isEmpty()) {
        // Handle empty fields
        out.println("All fields are required.");
    } else if (!password.equals(confirmPassword)) {
        // Handle password mismatch
        out.println("Passwords do not match.");
    } else if (password.length() < 8) {
        // Handle password length less than 8
        out.println("Password must be at least 8 characters long.");
    } else if (password.equalsIgnoreCase(username) || 
               password.equalsIgnoreCase(firstName) || 
               password.equalsIgnoreCase(lastName)) {
        // Handle password similarity with username, first name, or last name
        out.println("Password cannot be similar to username, first name, or last name.");
    } else {
        try {
            // Create database connection
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Check if username is unique
            PreparedStatement stmt = con.prepareStatement("SELECT * FROM users WHERE uname = ?");
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Username already exists
                out.println("Username already exists.");
            } else {
                // Check if phone number is unique
                stmt = con.prepareStatement("SELECT * FROM users WHERE phone = ?");
                stmt.setString(1, phone);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    // Phone number already exists
                    out.println("Phone number already exists.");
                } else {
                    // Insert user into the database
                    stmt = con.prepareStatement("INSERT INTO users (uname, password, fname, lname, phone) VALUES (?, ?, ?, ?, ?)");
                    stmt.setString(1, username);
                    stmt.setString(2, password);
                    stmt.setString(3, firstName);
                    stmt.setString(4, lastName);
                    stmt.setString(5, phone);

                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        // Redirect to home.jsp
                        response.sendRedirect("home.jsp");
                        return;
                    } else {
                        out.println("Failed to register user.");
                    }
                }
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
  <title>User Registration</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
  <div class="container">
    <h2>User Registration</h2>
    <form action="#" method="POST">
      <div class="form-group">
        <label for="username">Username:</label>
        <input type="text" id="username" name="username" required>
      </div>
      <div class="form-group">
        <label for="firstname">First Name:</label>
        <input type="text" id="firstname" name="firstname" required>
      </div>
      <div class="form-group">
        <label for="lastname">Last Name:</label>
        <input type="text" id="lastname" name="lastname" required>
      </div>
      <div class="form-group">
        <label for="phone">Phone Number:</label>
        <input type="number" id="phone" name="phone" pattern="[0-9]{10}" placeholder="Enter 10-digit phone number" required>
        <small>Format: 1234567890</small>
      </div>
      <div class="form-group">
        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
      </div>
      <div class="form-group">
        <label for="confirm-password">Confirm Password:</label>
        <input type="password" id="confirm-password" name="confirm-password" required>
      </div>
      <button type="submit">Register</button>
    </form>
  </div>
</body>
</html>
