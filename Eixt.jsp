<%-- 
    Document   : Eixt
    Created on : 2020-6-4, 16:59:51
    Author     : KevinTech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" import="CourseDesignPackage.*"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>微讯</title>
    </head>
    <body>
        <%
            ConnectDataBase db=new ConnectDataBase();
            db.connect();
            db.executeUpdate("update APP.PERSONINFORMATION set STATE='false' where ID='"+(String)session.getAttribute("userID")+"'");
            db.closeDB();
            session.setAttribute("userID","null");
            response.sendRedirect("ChatApp.jsp");
        %>
        
    </body>
</html>
