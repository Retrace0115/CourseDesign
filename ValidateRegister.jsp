<%-- 
    Document   : ValidateRegister
    Created on : 2020-6-1, 11:15:00
    Author     : KevinTech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" import="CourseDesignPackage.*"%>
<%@page import="java.sql.*,java.util.Random,java.io.*"%>
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
            //获取注册表单数据
            String userName=request.getParameter("registerName");
            String pswd=request.getParameter("registerPswd");
            String number=request.getParameter("registerNumber");
            ConnectDataBase db=new ConnectDataBase();//连接数据库
            db.connect();
            //分配ID
            String ID="";
            Random rand = new Random();
            rand.nextInt(9);
            while(true){
                for(int i=0;i<10;i++){
                    int num = 0;
                    if(i==0){
                        num=rand.nextInt(9)+1;
                    }
                    else{
                        num=rand.nextInt(10);
                    }
                    ID+=String.valueOf(num);
                }
                ResultSet rs=db.executeQuery("select * from APP.ID_PSWD where ID='"+ID+"'");
                if(rs.next()){
                    continue;
                }
                else{
                    break;
                }
            }
            db.executeUpdate("INSERT INTO APP.ID_PSWD (ID, PSWD, NUMBER, USERNAME) VALUES ('"+ID+"', '"+pswd+"', '"+number+"', '"+userName+"')");
            db.executeUpdate("INSERT INTO APP.PERSONINFORMATION (ID, AVATAR, SIGNATURE, NAME, BIRTHDAY,USERNAME,STATE) VALUES ('"+ID+"', 'DefaultAvatar.gif', '', '', '','"+userName+"','true')");
            db.closeDB();
            
            File myFolderPath = new File("D:/ChatAppRecord");   
            if (!myFolderPath.exists()&&myFolderPath.isDirectory()){   
                myFolderPath.mkdir();
            }
            //创建个人消息文件夹
            File myFolderPath2 = new File("D:/ChatAppRecord/"+ID);   
            if (!myFolderPath2.exists()&&myFolderPath.isDirectory()){   
                myFolderPath2.mkdir();
            }
            //创建消息记录文件
            db.connect();
            ResultSet rs=db.executeQuery("select * from APP.FRIENDMAP where MY='"+ID+"' or YOU='"+ID+"'");
            try{
                while(rs.next()){
                    File myFilePath = new File("D:/ChatAppRecord/"+ID+"/"+rs.getString("RECORDFILE")+".txt");
                    if (!myFilePath.exists()) {   
                        myFilePath.createNewFile();   
                    }   
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
            rs=null;
            db.closeDB();
            db.connect();
            rs=db.executeQuery("select * from APP.GROUPMEMBERS where MEMBERSID='"+ID+"'");
            while(rs.next()){
                File myFilePath = new File("D:/ChatAppRecord/"+ID+"/"+rs.getString("RECORDFILE")+".txt");   
                if (!myFilePath.exists()) {   
                    myFilePath.createNewFile();   
                }   
            }
            db.closeDB();
            //添加消息列表索引文件
            //跳转到主页面
            session.setAttribute("userID",ID);
            response.sendRedirect("ChatApp.jsp");
        %>
    </body>
</html>
