<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Page</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            text-align: center;
            padding-bottom: 50px;
            color: #495057;
        }

        h1 {
            color: #007BFF;
            margin: 20px;
        }

        p {
            color: #495057;
            margin: 10px;
        }

        .customer-info {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin: 20px auto;
            max-width: 600px;
        }
    </style>
</head>
<body>
    <%@ include file="auth.jsp" %>
    <%@ page import="java.text.NumberFormat" %>
    <%@ include file="jdbc.jsp" %>

    <%
        String userName = (String) session.getAttribute("authenticatedUser");
    %>

    <div class="customer-info">
        <h1>Customer Information</h1>

        <%
            // TODO: Print Customer information
            // Example SQL query to retrieve customer information
            try {
                // Load driver class
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            } catch (java.lang.ClassNotFoundException e) {
                out.println("ClassNotFoundException: " + e);
            }

            // Make the connection
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
            String uid = "sa";
            String pw = "304#sa#pw";

            try (Connection con = DriverManager.getConnection(url, uid, pw);
                    Statement stmt = con.createStatement();) {
                String sql = "SELECT * FROM customer WHERE userid = '" + userName + "'";

                // Execute the SQL query
                ResultSet rs = stmt.executeQuery(sql);

                // Process the result set
                if (rs.next()) {
                    // Access customer information fields
                    int customerId = rs.getInt(1);
                    String customerName = rs.getString(2) + " " + rs.getString(3);
                    String email = rs.getString(4);
                    String phoneNum = rs.getString(5);
                    String addr = rs.getString(6);
                    String city = rs.getString(7);
                    String state = rs.getString(8);
                    String post = rs.getString(9);
                    String country = rs.getString(10);
                    String user = rs.getString(11);

                    // Display customer information
                    out.println("<p>Customer Id: " + customerId + "</p>");
                    out.println("<p>Name: " + customerName + "</p>");
                    out.println("<p>Email: " + email + "</p>");
                    out.println("<p>Phone Number: " + phoneNum + "</p>");
                    out.println("<p>Address: " + addr + "</p>");
                    out.println("<p>City: " + city + "</p>");
                    out.println("<p>State: " + state + "</p>");
                    out.println("<p>Postal Code: " + post + "</p>");
                    out.println("<p>Country: " + country + "</p>");
                    out.println("<p>User Id: " + user + "</p>");

                } else {
                    out.println("<p>No customer information found.</p>");
                }

                // Close the result set
                rs.close();

            } catch (java.sql.SQLException e) {
                out.println("<p>Error executing SQL query: " + e.getMessage() + "</p>");
            }
            // Make sure to close connection
        %>
    </div>
</body>
</html>