<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Atharva's Main Page</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            text-align: center;
            padding-bottom: 50px; 
        }

        h1 {
            color: #343a40;
            margin: 20px;
        }

        h2 {
            color: #007BFF;
            margin: 20px 0;
        }

        a {
            text-decoration: none;
            color: #007BFF;
            font-weight: bold;
            padding: 10px 20px;
            border: 2px solid #007BFF;
            border-radius: 5px;
            margin: 10px;
            transition: all 0.3s ease;
        }

        a:hover {
            background-color: #007BFF;
            color: #fff;
        }
        
        footer {
            position: fixed;
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: #f8f9fa;
            padding: 10px;
            text-align: left;
        }

        footer p {
            margin: 0;
            color: #007BFF;
        }
    </style>
</head>
<body>
	<%@ include file="header.jsp" %>

    <h2>Explore Our Products</h2>
    <a href="listprod.jsp">Begin Shopping</a>

    <h2>Customer Services</h2>
    <a href="customer.jsp">Customer Info</a>

    <h2>Administrator Area</h2>
    <a href="admin.jsp">Administrators</a>

    <h2>Contact Us</h2>
    <a href="aboutus.jsp">About Us</a>
</body>
</html>