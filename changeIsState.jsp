<%-- 
    Document   : changeIsState
    Created on : 2020-6-4, 18:08:44
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
            String isState=request.getParameter("name");
            ConnectDataBase db=new ConnectDataBase();
            db.connect();
            if("OnLine".equals(isState)){
                db.executeUpdate("update APP.PERSONINFORMATION set STATE='true' where ID='"+(String)session.getAttribute("userID")+"'");
            }
            else if("OffLine".equals(isState)){
                db.executeUpdate("update APP.PERSONINFORMATION set STATE='false' where ID='"+(String)session.getAttribute("userID")+"'");
            }
            db.closeDB();
            response.sendRedirect("ChatApp.jsp");
        %>
    </body>
</html>
