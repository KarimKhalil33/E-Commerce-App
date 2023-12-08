<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Page</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            text-align: center;
            padding-bottom: 50px;
        }

        h2 {
            color: #343a40;
            margin: 20px;
        }

        .button-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 150px;
        }

        .button-container form {
            margin: 10px 0;
        }

        .button-container button {
            padding: 15px 30px;
            background-color: #007BFF;
            color: #fff;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            font-size: 16px;
        }

        .button-container button:hover {
            background-color: #00c8ff;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>
    <h2>Administrator Panel</h2>

    <div class="button-container">
        <form action="salesreport.jsp" method="get">
            <button type="submit">Generate Sales Report</button>
        </form>

        <form action="listorder.jsp" method="get">
            <button type="submit">Customer Orders</button>
        </form>
        
        <form action="warehouse.jsp" method="get">
            <button type="submit">Warehouse Inventory</button>
        </form>

        <form action="loaddata.jsp" method="get">
            <button type="submit">Restore Database</button>
        </form>
    </div>
</body>
</html>