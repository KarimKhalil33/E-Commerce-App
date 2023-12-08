<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Atharva's Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%

	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
   	String uid = "sa";
   	String pw = "304#sa#pw";

	String order  = request.getParameter("orderId");
	int orderId = Integer.parseInt(order);
	boolean valid = false;

	try(Connection con = DriverManager.getConnection(url,uid,pw)){

			con.setAutoCommit(false);

			String orderValidity = "SELECT * FROM orderSummary WHERE orderId = ?;";
			PreparedStatement pstmt = con.prepareStatement(orderValidity);
			pstmt.setInt(1, orderId);
			ResultSet rst = pstmt.executeQuery();

			if(!rst.next()){
				out.println("<h3>Invalid Order Id</h3>");

			}else valid = true;


			if(valid){

				String sql = "SELECT OP.productId, OP.quantity, PI.quantity FROM orderproduct OP INNER JOIN productinventory PI ON OP.productId = PI.productId WHERE orderId = ?"; 
				PreparedStatement pstmt2 = con.prepareStatement(sql); 
				pstmt2.setInt(1, orderId); 
				ResultSet rst2 = pstmt2.executeQuery(); 
				boolean successful = false; 
				
				while(rst2.next()) {
					int pid = rst2.getInt(1); 
					int quantity = rst2.getInt(2); 
					int inventory = rst2.getInt(3);
					out.println(quantity);
					out.println(inventory);
					if(!(inventory - quantity < 0)) {
						
						out.println("<h3>Ordered product: " + pid  + " Qty: " + quantity + " Previous Quantity: " + inventory + " New Inventory: " + (inventory-quantity) +"</h2>"); 
						successful = true; 
					} else {
						inventory = 0; 
						out.println("<h2>Shipment not done. Insufficient inventory for product id: " + pid + "</h2>"); 
						successful = false; 
						con.rollback();
						break;
					}


					String SQL2 = "UPDATE productInventory SET quantity = ? WHERE productId = ?;";
					PreparedStatement pstmt3 = con.prepareStatement(SQL2);
					pstmt3.setInt(1, inventory-quantity);
					pstmt3.setInt(2, pid);
					pstmt3.executeUpdate();
				}

				if(successful){
					out.println("<h2>Shipment processed successfully</h2>"); 
				}


				// TODO: Create a new shipment record.

				String orderDate = request.getParameter("orderDate");

				String addShipment = "INSERT INTO shipment(shipmentDate, warehouseId) VALUES (?, 1);";
				PreparedStatement pstmt4 = con.prepareStatement(addShipment);
				pstmt4.setString(1,orderDate);
				pstmt4.executeUpdate();

			}

			con.setAutoCommit(true);


	}catch(Exception e){
		out.println("<p>" + e.toString() + "</p>");
	}
%>                       				

<h2><a href="index.jsp">Back to Main Page</a></h2>

</body>
</html>