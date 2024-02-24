<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%
// Retrieve form data
String username = request.getParameter("username");
String firstName = request.getParameter("firstname");
String lastName = request.getParameter("lastname");

if (username != null && firstName != null && lastName != null) {
    // Database connection parameters
    String url = "jdbc:mysql://localhost:3306/expense_tracker";
    String dbUsername = "root";
    String dbPassword = "";

    try {
        // Create database connection
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(url, dbUsername, dbPassword);

        // Update user data in the database
        PreparedStatement stmt = con.prepareStatement("UPDATE users SET fname = ?, lname = ? WHERE uname = ?");
        stmt.setString(1, firstName);
        stmt.setString(2, lastName);
        stmt.setString(3, username);

        int rowsAffected = stmt.executeUpdate();
        if (rowsAffected > 0) {
            response.sendRedirect("profile.jsp");
        } else {
            out.println("Failed to update user data.");
        }
        // Close database connection
        con.close();
    } catch (Exception e) {
        out.println("An error occurred: " + e);
    }
} else {
    out.println("Invalid request parameters.");
}
%>
