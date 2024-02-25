<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ page import="java.sql.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<% 
    String username = (String) session.getAttribute("username");
    if (username != null) { 
        if ("POST".equalsIgnoreCase(request.getMethod())){
            String url = "jdbc:mysql://localhost:3306/expense_tracker";
            String dbUsername = "root";
            String dbPassword = "";
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(url, dbUsername, dbPassword);
                String sql = "SELECT * FROM groups_users WHERE gid=?";
                ps = con.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                int gid = Integer.parseInt(request.getParameter("gid"));
                ps.setInt(1, gid);
                rs = ps.executeQuery();

                int pid = Integer.parseInt(request.getParameter("pid"));
                while (rs.next()) {
                    int tempUid = rs.getInt("uid");
                    if (pid == tempUid) continue;

                    sql = "SELECT * FROM transactions WHERE uid1=? AND uid2=?";
                    ps = con.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                    ps.setInt(1, pid);
                    ps.setInt(2, tempUid);
                    ResultSet rs1 = ps.executeQuery();

                    if (rs1.next()) {
                        int amt = rs1.getInt("amount");
                        int val = amt - Integer.parseInt(request.getParameter("" + tempUid));
                        if (val > 0) {
                            rs1.updateInt("amount", val);
                            rs1.updateRow();
                        } else if (val < 0) {
                            int temp = rs1.getInt("uid1");
                            rs1.updateInt("uid1", rs1.getInt("uid2"));
                            rs1.updateInt("uid2", temp);
                            rs1.updateInt("amount", -val);
                            rs1.updateRow();
                        } else {
                            rs1.deleteRow();
                        }
                    } else {
                        sql = "SELECT * FROM transactions WHERE uid1=? AND uid2=?";
                        ps = con.prepareStatement(sql, ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
                        ps.setInt(1, tempUid);
                        ps.setInt(2, pid);
                        rs1 = ps.executeQuery();

                        if (rs1.next()) {
                            int amt = rs1.getInt("amount");
                            int val = amt + Integer.parseInt(request.getParameter("" + tempUid));
                            rs1.updateInt("amount", val);
                            rs1.updateRow();
                        } else {
                            String insertSql = "INSERT INTO transactions (uid1, uid2, amount) VALUES (?, ?, ?)";
                            PreparedStatement insertPs = con.prepareStatement(insertSql);
                            insertPs.setInt(1, tempUid);
                            insertPs.setInt(2, pid);
                            int amt = Integer.parseInt(request.getParameter("" + tempUid));
                            insertPs.setInt(3, amt);
                            insertPs.executeUpdate();
                        }
                    }
                }
                response.sendRedirect("home.jsp"); // Redirect to home.jsp if successful
            } catch (Exception e) {
                e.printStackTrace();
                // Handle any exceptions here
            } finally {
                // Close resources in finally block
                try {
                    if (rs != null) rs.close();
                    if (ps != null) ps.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            response.sendRedirect("home.jsp");
        }
    } else { 
%>
    <p>You are not logged in.</p>
    <a href="reg.jsp">Register</a> <a href="login.jsp">Login</a>
<% 
    } 
%>
</body>
</html>
