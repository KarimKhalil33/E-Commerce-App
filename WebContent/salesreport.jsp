<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Report</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            text-align: center;
        }

        h1 {
            color: #343a40;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #dee2e6;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #007BFF;
            color: #fff;
        }
    </style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>

<%
try
{   // Load driver class
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
    out.println("ClassNotFoundException: " +e);
}

// Make the connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try ( Connection con = DriverManager.getConnection(url, uid, pw);
      Statement stmt = con.createStatement();)
{
    String sql = "SELECT YEAR(orderDate) AS order_year, MONTH(orderDate) AS order_month, DAY(orderDate) AS order_day, SUM(totalAmount) AS total_amount FROM ordersummary GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate)";

    ResultSet rs = stmt.executeQuery(sql);

    // Display the result set
    out.println("<h1>Administrator Sales Report by Day</h1>");
    out.println("<table>");
    out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");

    while (rs.next()) {
        // Access result set fields
        int orderYear = rs.getInt(1);
        int orderMonth = rs.getInt(2);
        int orderDay = rs.getInt(3);
        double totalAmount = rs.getDouble(4);
    
        // Display data in the table
        out.println("<tr><td>" + orderYear + "-" + orderMonth + "-" + orderDay + "</td><td>" + totalAmount + "</td></tr>");
    }    

    out.println("</table>");

}catch (SQLException e) {
    out.println("SQL Exception: " + e);
}
%>

</body>
</html>