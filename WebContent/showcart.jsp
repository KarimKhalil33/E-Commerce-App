<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            text-align: center;
            padding-bottom: 50px; 
        }

        h1, h2 {
            color: #007BFF;
            margin: 20px 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #007BFF;
            padding: 15px;
            text-align: left;
        }

        th {
            background-color: #007BFF;
            color: #fff;
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

        .link-container {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{
    out.println("<H1>Your shopping cart is empty!</H1>");
    productList = new HashMap<String, ArrayList<Object>>();
}
else
{
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();

    out.println("<h1>Your Shopping Cart</h1>");
    out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
    out.println("<th>Price</th><th>Subtotal</th><th>Action</th></tr>");

    double total = 0;
    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext())
    {
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        if (product.size() < 4)
        {
            out.println("Expected product with four entries. Got: " + product);
            continue;
        }

        String productId = (String) product.get(0);
        String productName = (String) product.get(1);

        out.print("<tr><td>" + productId + "</td>");
        out.print("<td>" + productName + "</td>");

        out.print("<td align=\"center\">");
        out.print("<form action='showcart.jsp' method='post'>");
        out.print("<input type='hidden' name='productId' value='" + productId + "'>");
        out.print("<input type='number' name='quantity' value='" + product.get(3) + "' min='1'>");
        out.print("<input type='submit' value='Update'>");
        out.print("</form></td>");

        double pr = Double.parseDouble(product.get(2).toString());
        int qty = Integer.parseInt(product.get(3).toString());

        out.print("<td align=\"right\">" + currFormat.format(pr) + "</td>");
        out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td>");
        out.print("<td><a href='showcart.jsp?action=remove&id=" + productId + "'>Remove</a></td></tr>");

        total = total + pr * qty;
    }

    // Handle the removal of a product from the shopping cart
    String action = request.getParameter("action");
    String removeProductId = request.getParameter("id");
    if (action != null && action.equals("remove") && removeProductId != null) {
        productList.remove(removeProductId);
        session.setAttribute("productList", productList);
        response.sendRedirect("showcart.jsp");
    }

    // Update quantity if form is submitted
    String updatedProductId = request.getParameter("productId");
    String updatedQuantity = request.getParameter("quantity");
    if (updatedProductId != null && updatedQuantity != null) {
        ArrayList<Object> updatedProduct = productList.get(updatedProductId);
        updatedProduct.set(3, updatedQuantity);
        session.setAttribute("productList", productList);
        response.sendRedirect("showcart.jsp");
    }

    out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
            + "<td align=\"right\">" + currFormat.format(total) + "</td></tr>");
    out.println("</table>");

    // Link container with spacing
    out.println("<div class='link-container'>");
	out.println("<h2><a href=\"listprod.jsp\">Continue Shopping</a></h2>");
    out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
    out.println("</div>");
}
%>

</body>
</html>