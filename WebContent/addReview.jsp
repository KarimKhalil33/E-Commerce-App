<%@ page import="java.sql.*, java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String productId = request.getParameter("productId");
String reviewText = request.getParameter("review");
int rating = 0; // Default value or handle it accordingly
String ratingParam = request.getParameter("rating");
if (ratingParam != null && !ratingParam.isEmpty()) {
     rating = Integer.parseInt(ratingParam);
 }

// Assuming you have the database connection logic here
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String user = "sa";
String password = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, user, password)) {
    String insertReviewSql = "INSERT INTO review (reviewRating, reviewDate, productId, reviewComment) VALUES (?, ?, ?, ?)";
    try (PreparedStatement insertReviewStmt = con.prepareStatement(insertReviewSql)) {
        insertReviewStmt.setInt(1, rating);
        insertReviewStmt.setTimestamp(2, new Timestamp(new Date().getTime()));
        insertReviewStmt.setInt(3, Integer.parseInt(productId));
        insertReviewStmt.setString(4, reviewText);

        int rowsAffected = insertReviewStmt.executeUpdate();
        if (rowsAffected > 0) {
            out.println("Review submitted successfully!");
        } else {
            out.println("Failed to submit the review.");
        }
        %>
        <header>
            <a href="listprod.jsp">Back to Product</a>
        </header>
        <%
    }
} catch (SQLException e) {
    out.println("SQL Exception while adding review: " + e);
}
%>
