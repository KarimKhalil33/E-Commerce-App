<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us</title>
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
            text-align: center;
        }

        .contact-info {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin: 20px auto;
            max-width: 600px;
        }

        .contact-info p {
            margin: 5px;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp" %>

    <h1>About Us</h1>
    
    <p>
        At SwiftShopper, our mission is to redefine the grocery shopping experience by providing a convenient and diverse online platform
         for individuals seeking quality groceries. We aim to create a haven for our customers, offering a seamless and efficient way to
          explore, select, and receive the finest grocery products. SwiftShopper is dedicated to elevating the standards of online grocery
           shopping through a commitment to freshness, variety, and customer satisfaction.
    </p>

    <div class="contact-info">
        <h2>Contact Us</h2>
        <p>Email: info@swiftshopper.com</p>
        <p>Phone: +1 (999) 123-4567</p>
        <p>Address: 123 Grocery Lane, Cityville, Canada</p>
    </div>
</body>
</html>
