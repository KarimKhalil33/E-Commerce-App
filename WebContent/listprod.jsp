<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atharva's Product Listing</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 20px;
            background-color: #007BFF;
            color: #fff;
        }

        header a {
            text-decoration: none;
            color: #fff;
            font-weight: bold;
            margin: 0 10px;
            transition: all 0.3s ease;
        }

        header a:hover {
            color: #f8f9fa;
        }

        main {
            margin: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #007BFF;
        }

        th, td {
            padding: 15px;
            text-align: left;
        }

        th {
            background-color: #007BFF;
            color: #fff;
        }

        .product-image {
            max-width: 100px;
            max-height: 100px;
        }
        .user-info {
            position: absolute;
            top: 10px;
            right: 20px;
            color: #007BFF;
        }

        .search-form {
            margin-bottom: 20px;
        }

        .category-select {
            margin-right: 10px;
        }

        .cart-button {
            margin-top: 20px;
        }

        .home-link {
            position: absolute;
            top: 10px;
            left: 20px;
            color:#007BFF;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s ease;
        }

        .home-link:hover {
            color:#00c8ff;
        }
    </style>
</head>
<body>
<a href="index.jsp" class="home-link">Home</a>
<div class="user-info">Logged in as: <%= session.getAttribute("authenticatedUser") %></div>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp" class="search-form">
    <input type="text" name="productName" size="50">
    <select name="category" class="category-select">
        <option value="">All Categories</option>
        <%
            try {
                // Load driver class
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

                // Make the connection
                String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
                String user = "sa";
                String password = "304#sa#pw";

                try (Connection con = DriverManager.getConnection(url, user, password)) {
                    String query = "SELECT * FROM category";
                    try (PreparedStatement pstmt = con.prepareStatement(query)) {
                        try (ResultSet rs = pstmt.executeQuery()) {
                            while (rs.next()) {
                                String categoryName = rs.getString("categoryName");
        %>
                                <option value="<%= categoryName %>"><%= categoryName %></option>
        <%
                            }
                        }
                    }
                }
            } catch (Exception e) {
                out.println("Error retrieving categories: " + e);
            }
        %>
    </select>
    <input type="submit" value="Search"><input type="reset" value="Reset">
</form>

<%
String productName = request.getParameter("productName");
String selectedCategory = request.getParameter("category");

// Note: Forces loading of SQL Server driver
try {
    // Load driver class
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

// Make the connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String user = "sa";
String password = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, user, password)) {
    // Use it to build a query and print out the resultset. Make sure to use PreparedStatement!
    String query = "SELECT * FROM product";

    // Adjust the query based on the selected category
    if (selectedCategory != null && !selectedCategory.isEmpty()) {
        query += " WHERE categoryId IN (SELECT categoryId FROM category WHERE categoryName = ?)";
    }
    if (productName != null && !productName.isEmpty()) {
        if (selectedCategory != null && !selectedCategory.isEmpty()) {
            query += " AND productName LIKE ?";
        } else {
            query += " WHERE productName LIKE ?";
        }
    }

    try (PreparedStatement pstmt = con.prepareStatement(query)) {
        int parameterIndex = 1;
        if (selectedCategory != null && !selectedCategory.isEmpty()) {
            pstmt.setString(parameterIndex++, selectedCategory);
        }
        if (productName != null && !productName.isEmpty()) {
            pstmt.setString(parameterIndex, "%" + productName + "%");
        }

        try (ResultSet rs = pstmt.executeQuery()) {
            // Display table of products
%>
            <table border="1">
                <tr>
                    <th>Image</th>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Action</th>
                </tr>
<%
                while (rs.next()) {
                    String id = rs.getString("productId");
                    String name = rs.getString("productName");
                    String price = rs.getString("productPrice");
                    String productImageURL = rs.getString("productImageURL");
%>
                    <tr>
                        <td><img src="<%= productImageURL %>" alt="<%= name %>" class="product-image"></td>
                        <td><a href="product.jsp?id=<%=id %>"><%= name %></a></td>
                        <td>$<%= price %></td>
                        <td><a href="addcart.jsp?id=<%=id %>&name=<%= URLEncoder.encode(name, "UTF-8") %>&price=<%= price %>">Add to Cart</a></td>
                    </tr>
<%
                }
            }
        }
    }
 catch (SQLException e) {
    out.println("SQL Exception: " + e);
}
%>

<div class="cart-button">
    <a href="showcart.jsp">View Shopping Cart</a>
</div>

</body>
</html>