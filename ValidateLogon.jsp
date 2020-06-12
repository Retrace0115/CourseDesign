<%-- 
    Document   : ValidateLogon
    Created on : 2020-6-1, 11:14:02
    Author     : KevinTech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" import="CourseDesignPackage.*"%>
<%@page import="java.sql.*,java.io.*"%>
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
            File myFolderPath = new File("D:/ChatAppRecord");   
            if (!myFolderPath.exists()&&myFolderPath.isDirectory()){   
                myFolderPath.mkdir();
            }
            ConnectDataBase db = new ConnectDataBase();
            db.connect();
            request.setCharacterEncoding("utf-8");
            String username1=request.getParameter("username");
            String password1=request.getParameter("pswd");
            ResultSet rs = db.executeQuery("select * from APP.ID_PSWD where ID='"+username1+"'");
            try{
                if(rs.next()){
                    String password2=rs.getString("PSWD");
                    if(password1.equals(password2)){
                        db.executeUpdate("update APP.PERSONINFORMATION set STATE='true' where ID='"+username1+"'");
                        rs=null;
                        db.closeDB();
                        //创建个人消息文件夹
                        File myFolderPath2 = new File("D:/ChatAppRecord/"+username1);   
                        if (!myFolderPath2.exists()&&myFolderPath.isDirectory()){   
                            myFolderPath2.mkdir();
                        }
                        //创建消息记录文件
                        db.connect();
                        rs=db.executeQuery("select * from APP.FRIENDMAP where MY='"+username1+"' or YOU='"+username1+"'");
                        while(rs.next()){
                            File myFilePath = new File("D:/ChatAppRecord/"+username1+"/"+rs.getString("RECORDFILE")+".txt");   
                            if (!myFilePath.exists()) {   
                                myFilePath.createNewFile();   
                            }    
                        }
                        rs=null;
                        db.closeDB();
                        db.connect();
                        rs=db.executeQuery("select * from APP.GROUPMEMBERS where MEMBERSID='"+username1+"'");
                        while(rs.next()){
                            File myFilePath = new File("D:/ChatAppRecord/"+username1+"/"+rs.getString("RECORDFILE")+".txt");   
                            if (!myFilePath.exists()) {   
                                myFilePath.createNewFile();   
                            }   
                        }
                        db.closeDB();
                        //跳转到主页面
                        session.setAttribute("userID",username1);
                        session.setAttribute("userPswd",password1);
                        response.sendRedirect("ChatApp.jsp");
                    }
                    else{
                        out.println("<script  language='JavaScript'>alert('密码错误！');window.location.href='../html文件/Login.html';</script>");
                    }
                    db.closeDB();
                }
                db.closeDB();
                out.println("<script  language='JavaScript'>alert('该用户不存在！');window.location.href='../html文件/Login.html';</script>");
            }
            catch(Exception e){
                e.printStackTrace();
            }
        %>
    </body>
</html>
