<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atharva's Order List</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        h1 {
            color: #007BFF;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #007BFF;
            text-align: left;
            padding: 8px;
        }

        th {
            background-color: #007BFF;
            color:#000000;
        }

        td {
            border-top: 1px solid #007BFF;
        }

        .table-inner {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
        }

        .table-inner th, .table-inner td {
            border: 1px solid #007BFF;
            text-align: left;
            padding: 8px;
        }

        .table-inner th {
            background-color: #f2f2f2;
        }

        .total-row {
            font-weight: bold;
        }
    </style>
</head>
<body>

<h1>Order List</h1>

<%
try
{
    // Load driver class
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
    out.println("ClassNotFoundException: " + e);
}

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw);
     Statement stmt = con.createStatement();)
{
    String sql = "SELECT o.orderId, o.orderDate, c.customerId, c.firstName, c.lastName, o.totalAmount FROM" +
            " ordersummary o JOIN customer c ON o.customerId = c.customerId ORDER BY o.orderId ASC";

    String sql2 = "SELECT productId, quantity, price, SUM(quantity), SUM(price) FROM orderproduct WHERE orderId = ? GROUP BY productId, quantity, price";

    ResultSet rst = stmt.executeQuery(sql);

    out.println("<table border=\"1\"><tbody><tr><th>Order Id</th><th>Order Date</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");

    while (rst.next())
    {
        out.println("<tr><td>" + rst.getInt(1) + "</td><td>" + rst.getDate(2) + "</td><td>" + rst.getInt(3) + "</td><td>" + rst.getString(4) +
                " " + rst.getString(5) + "</td><td>" + currFormat.format(rst.getDouble(6)) + "</td></tr>");

        int o_id = rst.getInt(1);

        PreparedStatement pstmt = con.prepareStatement(sql2);
        pstmt.setInt(1, o_id);
        ResultSet rst2 = pstmt.executeQuery();

        out.println("<tr><td colspan=\"5\"><table border=\"1\" class=\"table-inner\"><tbody><tr><th>Product Id</th><th>Quantity</th><th>Price</th></tr>");

        int totalQuantity = 0;
        double totalPrice = 0;
        while (rst2.next())
        {
            out.println("<tr><td>" + rst2.getInt(1) + "</td><td>" + rst2.getInt(2) + "</td><td>" + currFormat.format(rst2.getDouble(3)) + "</td></tr>");
            totalQuantity += rst2.getInt(2);
            totalPrice += rst2.getDouble(3);
        }

        out.println("<tr class=\"total-row\"><td>Total</td><td>" + totalQuantity + "</td><td>" + currFormat.format(totalPrice) + "</td></tr>");

        out.println("</tbody></table></td></tr>");
    }
    out.println("</tbody></table>");
}
catch (SQLException ex)
{
    out.println(ex);
}
%>
</body>
</html>