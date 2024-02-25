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
            <a class="menu-icon" style="margin-left: 30px;" href="./home.jsp">home</a>
            <a class="menu-icon" style="margin-left: 30px;" href="profile.jsp">Profile</a>
            <a class="menu-icon" style="margin-left: 30px;" href="logout.jsp">Sign Out</a>
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
    <a class="add-transaction-button" href="add_transaction.jsp?gid=<%=gid %>">Add Transaction</a>
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
            <button class="description-button" onclick="openModal('<%= description %>')">Description</button>
        </li>
        	   
        	   
        	   <%
           }
           }
           
       catch (SQLException ex) {
	       ex.printStackTrace();
	   }
       %>
        
       
    </ul>
<div id="myModal" class="modal">
        <!-- Modal content -->
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <p id="usingp">This is the description.</p>
        </div>
    </div>


    <footer>
        <p>Contact us @expense.tracker@gmail.com</p>
    </footer>
  
  <script>
  function convertTransaction(transactionString) {
	    let transactions = transactionString.split(',');
	    let paidBy = transactions[0].split('-')[0];
	    let amountPaid = parseInt(transactions[0].split('-')[1]);
	    let result = amountPaid + " ,paid by " + paidBy + "\n";
	    
	    for (let i = 1; i < transactions.length; i++) {
	        let transaction = transactions[i].split(':');
	        let personGiving = transaction[0];
	        let amountGiving = parseInt(transaction[1]);
	        result += personGiving + " spended " + amountGiving + "\n";
	    }
	    
	    return result;
	}

  
  
        // JavaScript code for modal functionality (openModal, closeModal, window.onclick) goes here
        var modal = document.getElementById("myModal");

        // Get the button that opens the modal
        var btn = document.getElementsByClassName("description-button")[0];
        var usingp=document.getElementById("usingp");
        // Get the <span> element that closes the modal
        var span = document.getElementsByClassName("close")[0];

        // When the user clicks the button, open the modal 
        function openModal(desc) {
            modal.style.display = "block";
           
            usingp.innerText=convertTransaction(desc);
        }

        // When the user clicks on <span> (x), close the modal
        function closeModal() {
            modal.style.display = "none";
        }

        // When the user clicks anywhere outside of the modal, close it
        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>
</body>
</html>