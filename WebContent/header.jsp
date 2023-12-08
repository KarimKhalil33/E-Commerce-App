<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <style>
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
    </style>
</head>
<body>
    <header>
        <h1>Welcome to Swift Shopper</h1>
        <div>
            <%
                String loggedInUser = (String) session.getAttribute("authenticatedUser");
                if (loggedInUser != null && !loggedInUser.isEmpty()) {
            %>
                <p>Welcome, <%= loggedInUser %>! (<a href="logout.jsp">Logout</a>)</p>
            <%
                } else {
            %>
                <p>Welcome, Guest! (<a href="login.jsp">Login</a>)</p>
                <a href="register.jsp">Register</a>
            <%
                }
            %>
        </div>
    </header>
</body>
</html>