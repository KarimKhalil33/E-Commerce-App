<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Atharva's Grocery Order Processing</title>
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f4f4f4;
            color: #333;
            margin: 20px;
        }

        h2 {
            color: #d9534f;
        }

        h3 {
            color: #5bc0de;
        }

        h4 {
            color: #5cb85c;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ddd;
            text-align: left;
        }

        th {
            background-color: #5bc0de;
            color: white;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        a {
            color: #337ab7;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<%
// +1 mark - SQL Server connection information and making a successful connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String user = "sa";
String password = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, user, password)) {
    // +3 marks - validating that the customer id is a number and exists in the database. Display an error if the customer id is invalid.
    String custId = request.getParameter("customerId");
    String validateCustomerQuery = "SELECT COUNT(*) FROM customer WHERE customerId = ?";
    try (PreparedStatement validateCustomerPstmt = con.prepareStatement(validateCustomerQuery)) {
        // Additional check to ensure custId is a number
        if (!custId.matches("\\d+")) {
%>
            <h2>Error: Invalid customer ID. Please return to the previous page and enter a valid ID</h2>
<%
            return; // Stop further processing
        }

        validateCustomerPstmt.setInt(1, Integer.parseInt(custId));
        try (ResultSet validateCustomerRs = validateCustomerPstmt.executeQuery()) {
            validateCustomerRs.next();
            int customerCount = validateCustomerRs.getInt(1);
            if (customerCount == 0) {
%>
                <h2>Error: Customer ID does not exist. Please return to the previous page and enter a valid ID</h2>
<%
                return; // Stop further processing
            }
        }
    }
    @SuppressWarnings({"unchecked"})
    HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

    // +1 mark - showing an error message if the shopping cart is empty
    if (productList == null || productList.isEmpty()) {
%>
        <h2>Error: Shopping cart is empty</h2>
<%
    } else {
        // Save order information to the database
        String insertOrderQuery = "INSERT INTO ordersummary (customerId) VALUES (?)";
        try (PreparedStatement pstmt = con.prepareStatement(insertOrderQuery, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, Integer.parseInt(custId));
            pstmt.executeUpdate();

            try (ResultSet keys = pstmt.getGeneratedKeys()) {
                keys.next();
                int orderId = keys.getInt(1);
				
                // Insert each item into OrderProduct table using OrderId from the previous INSERT
                String insertProductQuery = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
                Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
                while (iterator.hasNext()) {
                    Map.Entry<String, ArrayList<Object>> entry = iterator.next();
                    ArrayList<Object> product = entry.getValue();
                    String productId = (String) product.get(0);
                    String price = (String) product.get(2);
                    int quantity = (int) product.get(3);

                    try (PreparedStatement productPstmt = con.prepareStatement(insertProductQuery)) {
                        productPstmt.setInt(1, orderId);
                        productPstmt.setInt(2, Integer.parseInt(productId));
                        productPstmt.setInt(3, quantity);
                        productPstmt.setDouble(4, Double.parseDouble(price));
                        productPstmt.executeUpdate();
                    }
                }

                // Update the total amount for the order record
				String updateTotalAmountQuery = "UPDATE ordersummary SET totalAmount = (SELECT SUM(quantity * price) FROM orderproduct WHERE orderId = ?), orderDate = GETDATE() WHERE orderId = ?";
				try (PreparedStatement updateTotalAmountPstmt = con.prepareStatement(updateTotalAmountQuery)) {
					updateTotalAmountPstmt.setInt(1, orderId);
					updateTotalAmountPstmt.setInt(2, orderId);
					updateTotalAmountPstmt.executeUpdate();
				}

                // Retrieve total amount for the order record
                String selectTotalAmountQuery = "SELECT totalAmount FROM ordersummary WHERE orderId = ?";
                try (PreparedStatement selectTotalAmountPstmt = con.prepareStatement(selectTotalAmountQuery)) {
                    selectTotalAmountPstmt.setInt(1, orderId);
                    try (ResultSet totalAmountRs = selectTotalAmountPstmt.executeQuery()) {
                        if (totalAmountRs.next()) {
                            double totalAmount = totalAmountRs.getDouble("totalAmount");
%>
                            <h2>Order Summary</h2>
							<h3> Order completed! Will be shipped soon... </h3>
                            <h3>Order ID: <%= orderId %></h3>
                            <table border="1">
								<tr>
									<th>Product Name</th>
									<th>Quantity</th>
									<th>Price</th>
									<th>Subtotal</th> <!-- Add this column header -->
								</tr>
								<%
								iterator = productList.entrySet().iterator();
								while (iterator.hasNext()) {
									Map.Entry<String, ArrayList<Object>> entry = iterator.next();
									ArrayList<Object> product = entry.getValue();
									String name = (String) product.get(1);
									int quantity = (int) product.get(3);
									String price = (String) product.get(2);
							
									//Calculate subtotal for each product
									double subtotal = quantity * Double.parseDouble(price);
								%>
									<tr>
										<td><%= name %></td>
										<td><%= quantity %></td>
										<td>$<%= price %></td>
										<td><%= NumberFormat.getCurrencyInstance().format(subtotal) %></td> <!-- Display the subtotal -->
									</tr>
								<%
								}
								%>
							</table>
							
							
                            <h3>Total Amount: <%= NumberFormat.getCurrencyInstance().format(totalAmount) %></h4>
							<h4>Shipping to Customer ID: <%= Integer.parseInt(custId) %> </h4>
                            <h3><a href="shop.html">Back to Main Page</a></h3>
							<%
// Retrieve customer name based on customerId
String customerNameQuery = "SELECT firstName, lastName FROM customer WHERE customerId = ?";
try (PreparedStatement customerNamePstmt = con.prepareStatement(customerNameQuery)) {
    customerNamePstmt.setInt(1, Integer.parseInt(custId));
    try (ResultSet customerNameRs = customerNamePstmt.executeQuery()) {
        if (customerNameRs.next()) {
            String firstName = customerNameRs.getString("firstName");
            String lastName = customerNameRs.getString("lastName");
%>
            <h4>Customer Name: <%= firstName %> <%= lastName %></h4> <!-- Display the customer name -->
<%
        }
    }
}
%>
<%
// +1 mark - Clear cart if the order is placed successfully
session.removeAttribute("productList");
}
}
}
}
}
}
} catch (SQLException e) {
out.println("SQL Exception: " + e);
}
%>

</body>
</html>