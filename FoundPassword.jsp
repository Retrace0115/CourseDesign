<%-- 
    Document   : FoundPassword
    Created on : 2020-6-1, 11:16:38
    Author     : KevinTech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" import="CourseDesignPackage.*"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>微讯</title>
        <link rel="stylesheet" href="../css文件/BeforeChat.css" type="text/css">
        <script type="text/javascript" src="../JavaScript文件/BeforeChat.js"></script>
    </head>
    <body>
        <%
            request.setCharacterEncoding("utf-8");
            //获取找回密码表单数据
            String ID=request.getParameter("id");
            String number=request.getParameter("number");
            ConnectDataBase db=new ConnectDataBase();//连接数据库
            db.connect();
            //查找ID并比对手机号码
            ResultSet rs=db.executeQuery("select * from APP.ID_PSWD where ID='"+ID+"' and NUMBER='"+number+"'");
            try{
                if(rs.next()){//找到了
                    String pswd=rs.getString("PSWD");
                    db.closeDB();
                    %>
                        <div class="FoundPassword found">
                            <p style="color: white;margin:150px 110px; ">您的密码为：<%=pswd%></p>
                            <a href="../html文件/Forget.html" style="position: absolute;left: 7px;bottom:10px;text-decoration: none;color: gray">修改密码</a>
                            <a href="../html文件/Login.html" style="position: absolute;right: 7px;bottom:10px;text-decoration: none;color: gray">立即登录</a>
                        </div>
                    <%
                }
                else{//没找到
                    db.closeDB();
                    %>
                        <div class="FoundPassword notFound">
                            <a href="../html文件/Forget.html" style="position: absolute;left: 7px;bottom:10px;text-decoration: none;color: gray">重新查找</a>
                            <a href="../html文件/Login.html" style="position: absolute;right: 7px;bottom:10px;text-decoration: none;color: gray">想起密码</a>
                        </div>
                        
                    <%
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
        %>
    </body>
</html>
