<%-- 
    Document   : savePersonalInformation
    Created on : 2020-6-5, 13:21:18
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
            String newAvatar=request.getParameter("newAvatar");
            String newMySign=request.getParameter("mySign");
            String newName=request.getParameter("myName");
            String newBirth=request.getParameter("myBirth");
            String newUserName=request.getParameter("userName");
            newBirth=newBirth.substring(0,4)+"年"+newBirth.substring(5,7)+"月"+newBirth.substring(8,10)+"日";
            ConnectDataBase db=new ConnectDataBase();
            db.connect();
            db.executeUpdate("update APP.PERSONINFORMATION set AVATAR='"+newAvatar+"',SIGNATURE='"+newMySign+"',NAME='"+newName+"',BIRTHDAY='"+newBirth+"',USERNAME='"+newUserName+"' where ID='"+userID+"'");
            db.executeUpdate("update APP.ID_PSWD set USERNAME='"+newUserName+"' where ID='"+userID+"'");
            db.executeUpdate("update APP.MESSAGELIST set RECEIVENAME='"+newUserName+"',RECEIVEAVATAR='"+newAvatar+"' where RECEIVEID='"+userID+"'");
            db.closeDB();
            db.connect();
            ResultSet rs=db.executeQuery("select * from APP.GROUPCHAT where GROUPLEADER='"+userID+"'");
            if(rs.next()){
                db.executeUpdate("update APP.GROUPCHAT set GROUPLEADERNAME='"+newUserName+"' where GROUPLEADER='"+userID+"'");
            }
            db.closeDB();
            response.sendRedirect("ChatApp.jsp");
        %>
    </body>
</html>
