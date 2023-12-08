<%@ page import="java.sql.*, java.io.InputStream, java.util.Base64" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atharva's Store - Product Information</title>
    <link href="css/bootstrap.min.css" rel="stylesheet">
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

        .container {
            margin-top: 4em;
        }

        h2 {
            margin-top: 1em;
        }

        img {
            max-width: 100%;
            height: auto;
        }

        /* Add some styling for reviews */
        h3 {
            color: #007BFF;
        }

        ul {
            list-style-type: none;
            padding: 0;
        }

        li {
            border: 1px solid #007BFF;
            margin: 10px;
            padding: 10px;
        }
    </style>
</head>
<body>

<%
// Get product ID to retrieve information
String productId = request.getParameter("id");



// Make the connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String user = "sa";
String password = "304#sa#pw";

if (productId != null && !productId.isEmpty()) {
    try (Connection con = DriverManager.getConnection(url, user, password)) {
        // TODO: Retrieve product information from the database based on productId
        String sql = "SELECT * FROM product WHERE productId = ?";

        try (PreparedStatement pstmt = con.prepareStatement(sql)) {
            pstmt.setString(1, productId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    String productName = rs.getString("productName");
                    double productPrice = rs.getDouble("productPrice");
                    String productImageURL = rs.getString("productImageURL");
                    String productDesc = rs.getString("productDesc");
%>
                    <header>
                        <a href="listprod.jsp">Back to Product List</a>
                    </header>
                    <main class="container">
                        <h2><%= productName %></h2>
                        <% if (productImageURL != null && !productImageURL.isEmpty()) { %>
                            <img src="<%= productImageURL %>" alt="Product Image">
                        <% } %>
                        <%
                        InputStream inputStream = rs.getBinaryStream("productImage");
                        if (inputStream != null) {
                            byte[] imageBytes = new byte[inputStream.available()];
                            inputStream.read(imageBytes);
                            String base64Image = Base64.getEncoder().encodeToString(imageBytes);
                        %>
                            <img src="displayImage.jsp?id=<%= productId %>" alt="Product Image">
                        <% }
                        %>
                        <p>Product Id: <%= productId %></p>
                        <p>Price: $<%= productPrice %></p>
                        <p>Product Description: <%= productDesc %></p>
                        <h2>
                            <a href="addcart.jsp?id=<%= productId %>&name=<%= URLEncoder.encode(productName, "UTF-8") %>&price=<%= productPrice %>">Add to Cart</a>
                        </h2>

                        <!-- Review form -->
                       <!-- Review form -->
                        <!-- Review form -->
                        <form action="addReview.jsp" method="post">
                            <input type="hidden" name="productId" value="<%= productId %>">
                            <label for="review">Your Review:</label>
                            <textarea id="review" name="review" required></textarea>
                            <!-- Add rating input -->
                            <label for="rating">Rating (1-5):</label>
                            <input type="number" id="rating" name="rating" min="1" max="5" required>
                            <input type="submit" value="Submit Review">
                        </form>
                        <!-- Display reviews -->
<h3>Product Reviews</h3>
<ul>
    <%
        // Retrieve and display reviews from the database based on productId
        String reviewSql = "SELECT * FROM review WHERE productId = ?";
        try (PreparedStatement reviewStmt = con.prepareStatement(reviewSql)) {
            reviewStmt.setString(1, productId);

            try (ResultSet reviewRs = reviewStmt.executeQuery()) {
                while (reviewRs.next()) {
                    int reviewRating = reviewRs.getInt("reviewRating");
                    String reviewDate = reviewRs.getString("reviewDate");
                    String reviewComment = reviewRs.getString("reviewComment");
    %>
                    <li>
                        <strong>Rating: <%= reviewRating %></strong><br>
                        <span><%= reviewComment %></span><br>
                        <span>On <%= reviewDate %></span>
                    </li>
    <%
                }
            }
        } catch (SQLException e) {
            out.println("SQL Exception while fetching reviews: " + e);
        }
    %>
</ul>

                    </main>
<%
                } else {
                    out.println("Product not found");
                }
            }
        }
    } catch (SQLException e) {
        out.println("SQL Exception: " + e);
    }
} else {
    out.println("Product ID is missing");
}
%>

</body>
</html>
