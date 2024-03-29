<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="jakarta.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Logout</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <%
        // Invalidate the session
        session.invalidate();
    %>
    <div class="container">
        <h2>Logout Successful</h2>
        <p>You have been logged out successfully.</p>
        <a href="login.jsp">Login</a>
        <a href="reg.jsp">Register</a>
    </div>
</body>
</html>
