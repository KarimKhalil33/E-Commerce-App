<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atharva's Warehouse Inventory</title>
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

<h1>Warehouse Inventory</h1>

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
    String sql = "SELECT pi.productId, p.productName, pi.quantity, pi.price, w.warehouseName FROM" +
            " productinventory pi JOIN product p ON pi.productId = p.productId" +
            " JOIN warehouse w ON pi.warehouseId = w.warehouseId ORDER BY w.warehouseName, p.productId ASC";

    ResultSet rst = stmt.executeQuery(sql);

    String currentWarehouse = "";
    out.println("<table border=\"1\"><tbody><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Warehouse</th></tr>");

    while (rst.next())
    {
        String warehouseName = rst.getString("warehouseName");

        if (!warehouseName.equals(currentWarehouse)) {
            currentWarehouse = warehouseName;
            out.println("<tr><td colspan=\"5\"><h2>" + currentWarehouse + "</h2></td></tr>");
        }

        out.println("<tr><td>" + rst.getInt("productId") + "</td><td>" + rst.getString("productName") +
                "</td><td>" + rst.getInt("quantity") + "</td><td>" + currFormat.format(rst.getDouble("price")) +
                "</td><td>" + warehouseName + "</td></tr>");
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