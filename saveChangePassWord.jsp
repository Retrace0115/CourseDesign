<%-- 
    Document   : saveChangePassWord
    Created on : 2020-6-5, 14:38:29
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
            request.setCharacterEncoding("utf-8");
            String userID=(String)session.getAttribute("userID");
            String newPswd=request.getParameter("newPswd1");
            ConnectDataBase db=new ConnectDataBase();
            db.connect();
            db.executeUpdate("update APP.ID_PSWD set PSWD='"+newPswd+"' where ID='"+userID+"'");
            session.setAttribute("userPswd",newPswd);
            db.closeDB();
            response.sendRedirect("ChatApp.jsp");
        %>
    </body>
</html>
