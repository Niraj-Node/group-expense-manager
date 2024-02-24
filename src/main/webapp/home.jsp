<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
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
    <div class="menu-icon">
      <img src="download.png" alt="Menu Icon">
    </div>
  </header>

  <main>
    <div class="container">
      <h2>Welcome</h2>
      <% 
        String username = (String) session.getAttribute("username");
        if (username != null) { 
      %>
        <p>Welcome, <%= username %>!</p>
        <a href="logout.jsp">Logout</a>
      <% 
        } else { 
      %>
        <p>You are not logged in.</p>
        <a href="reg.jsp">Register</a>
        <a href="login.jsp">Login</a>
      <% 
        } 
      %>
    </div>
    
    <% 
      if (username != null) { 
    %>
      <section class="group-section">
        <h2>Groups <button class="add-button">+</button></h2>
        <ul>
          <li>Group 1</li>
          <li>Group 2</li>
          <li>Group 3</li>
          <!-- Add more groups as needed -->
        </ul>
      </section>

      <section class="dues-section">
        <h2>Dues</h2>
        <ul>
          <li>Person 1</li>
          <li>Person 2</li>
          <li>Person 3</li>
          <!-- Add more persons as needed -->
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
