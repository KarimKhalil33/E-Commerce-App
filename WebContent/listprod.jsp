<%@ page import="java.sql.*, java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atharva's Product Listing</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #121212;
            color: #E0E0E0;
            margin: 0;
            padding: 0;
            line-height: 1.6;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px 30px;
            background-color: #1F1F1F;
            color: #E0E0E0;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        header a {
            text-decoration: none;
            color: #E0E0E0;
            font-weight: 500;
            margin: 0 10px;
            transition: color 0.3s ease;
        }

        header a:hover {
            color: #BB86FC;
        }

        main {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            margin: 20px;
        }

        .container {
            max-width: 1200px;
            background: #1E1E1E;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
            border-radius: 10px;
            padding: 30px;
            margin: 20px;
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
            color: #BB86FC;
            font-size: 2em;
        }

        form.search-form {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }

        form.search-form input[type="text"] {
            flex: 1;
            padding: 10px;
            border: 1px solid #333;
            border-radius: 5px;
            font-size: 1em;
            background-color: #333;
            color: #E0E0E0;
        }

        form.search-form select,
        form.search-form input[type="submit"],
        form.search-form input[type="reset"] {
            padding: 10px 20px;
            border: 1px solid #333;
            border-radius: 5px;
            background-color: #333;
            color: #E0E0E0;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.3s ease;
            font-size: 1em;
        }

        form.search-form select:hover,
        form.search-form input[type="submit"]:hover,
        form.search-form input[type="reset"]:hover {
            background-color: #555;
            transform: scale(1.05);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        table, th, td {
            border: 1px solid #333;
        }

        th, td {
            padding: 15px;
            text-align: left;
            font-size: 1em;
        }

        th {
            background-color: #333;
            color: #E0E0E0;
        }

        tr:nth-child(even) {
            background-color: #2C2C2C;
        }

        .product-image {
            max-width: 100px;
            max-height: 100px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
        }

        .user-info {
            position: absolute;
            top: 10px;
            right: 30px;
            color: #BB86FC;
            font-size: 0.9em;
        }

        .cart-button {
            margin-top: 20px;
            text-align: center;
        }

        .cart-button a {
            padding: 10px 20px;
            border: 1px solid #333;
            border-radius: 5px;
            background-color: #333;
            color: #E0E0E0;
            text-decoration: none;
            transition: background-color 0.3s ease, transform 0.3s ease;
        }

        .cart-button a:hover {
            background-color: #555;
            transform: scale(1.05);
        }

        .home-link {
            color: #BB86FC;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        .home-link:hover {
            color: #E0E0E0;
        }

        @media (max-width: 768px) {
            header {
                flex-direction: column;
                align-items: flex-start;
            }
            header a {
                margin: 5px 0;
            }
            .user-info {
                position: static;
                margin-top: 10px;
            }
            form.search-form {
                flex-direction: column;
                gap: 5px;
            }
        }
    </style>
</head>
<body>
<header>
    <a href="index.jsp" class="home-link">Home</a>
    <div class="user-info">Logged in as: <%= session.getAttribute("authenticatedUser") %></div>
</header>
<main>
    <div class="container">
        <h1>Search for the products you want to buy:</h1>
        <form method="get" action="listprod.jsp" class="search-form">
            <input type="text" name="productName" size="50">
            <select name="category" class="category-select">
                <option value="">All Categories</option>
                <%
                    try {
                        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
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
            <input type="submit" value="Search">
            <input type="reset" value="Reset">
        </form>
        <%
        String productName = request.getParameter("productName");
        String selectedCategory = request.getParameter("category");

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (java.lang.ClassNotFoundException e) {
            out.println("ClassNotFoundException: " + e);
        }

        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String user = "sa";
        String password = "304#sa#pw";

        try (Connection con = DriverManager.getConnection(url, user, password)) {
            String query = "SELECT * FROM product";

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
        %>
                    <table>
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
                                <td><a href="product.jsp?id=<%= id %>" style="color: #BB86FC;"><%= name %></a></td>
                                <td>$<%= price %></td>
                                <td><a href="addcart.jsp?id=<%= id %>&name=<%= URLEncoder.encode(name, "UTF-8") %>&price=<%= price %>" style="color: #BB86FC;">Add to Cart</a></td>
                            </tr>
        <%
                        }
                    }
                }
            } catch (SQLException e) {
                out.println("SQL Exception: " + e);
            }
        %>
        <div class="cart-button">
            <a href="showcart.jsp">View Shopping Cart</a>
        </div>
    </div>
</main>
</body>
</html>
