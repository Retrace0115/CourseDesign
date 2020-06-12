<%-- 
    Document   : SavePersonalInformation
    Created on : 2020-6-3, 15:10:02
    Author     : KevinTech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" import="CourseDesignPackage.*"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>微讯</title>
        <link rel="stylesheet" href="../css文件/ChatPageStyle.css" type="text/css">
        <script type="text/javascript" src="../JavaScript文件/ChatPageMove.js"></script>
        <script type="text/javascript">
            window.onload = function unit(){
                var testing="<%=(String)session.getAttribute("userID")%>";
                if(testing==="null"){
                    window.location.href="../html文件/Login.html";
                }
                //获取个人信息
                <%
                    String userID=(String)session.getAttribute("userID");
                    ConnectDataBase db=new ConnectDataBase();//连接数据库
                    String avatar="";
                    String name="";
                    String signature="";
                    String birthday="";
                    String userName="";
                    db.connect();
                    ResultSet rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+userID+"'");
                    try{
                        if(rs.next()){
                            avatar=rs.getString("AVATAR");
                            name=rs.getString("NAME");
                            signature=rs.getString("SIGNATURE");
                            birthday=rs.getString("BIRTHDAY");
                            userName=rs.getString("USERNAME");
                        }
                    }
                    catch(Exception e){
                        e.printStackTrace();
                    }
                    db.closeDB();
                %>
                var avatar="<%=avatar%>",signature="<%=signature%>",name="<%=name%>",birthday="<%=birthday%>",userName="<%=userName%>";
                var form=document.editForm;
                var o_n_Avatar=document.getElementById("avatar");
                o_n_Avatar.setAttribute("src","../images/"+avatar);
                form.newAvatar.value=avatar;
                form.userName.value=userName;
                form.mySign.value=signature;
                form.myName.value=name;
                if(birthday[0]===" "){
                    form.myBirth.value="";
                }
                else{
                    form.myBirth.value=birthday.substring(0,4)+"."+birthday.substring(5,7)+"."+birthday.substring(8,10);
                }
                var selectAvatar=document.getElementById("selectAvatar");
                var imgUrl=new Array("DefaultAvatar.gif","1.jpg","2.gif","3.jpg","4.jpg","5.jpg","6.jpg","7.jpg","8.jpg","9.jpg","10.jpg","11.gif","12.gif","13.jpg","14.jpg","15.jpg");
                for(var i=0;i<imgUrl.length;i++){//添加图片到头像选择区
                    var img=document.createElement("img");
                    img.setAttribute("src","../images/"+imgUrl[i]);
                    img.setAttribute("class","imgStyle");
                    img.onclick=function(){
                        var obj= window.event?event.srcElement:evt.target;
                        o_n_Avatar.setAttribute("src",obj.src);
                        form.newAvatar.value=obj.src.toString().substring(obj.src.toString().lastIndexOf("/")+1);
                        selectAvatar.style.display="none";
                        document.getElementById("addSelectAvatarButton").innerHTML="选择";
                    };
                    selectAvatar.append(img);
                }
            };
            function addSelectAvatar(){
                var selectAvatar=document.getElementById("selectAvatar");
                if(selectAvatar.style.display==="none"){
                    document.getElementById("addSelectAvatarButton").innerHTML="取消";
                    document.getElementById("addSelectAvatarButton").style.color="gray";
                    selectAvatar.style.display="inline-block";
                }
                else{
                    document.getElementById("addSelectAvatarButton").innerHTML="选择";
                    document.getElementById("addSelectAvatarButton").style.color="blue";
                    selectAvatar.style.display="none";
                }
            }
        </script>
    </head>
    <body>
        <div class="editInform"><!--编辑个人信息面板-->
            <form id="editForm" action="savePersonalInformation.jsp" method="post" name="editForm" onSubmit="return validateInform();"><!--编辑个人信息表单-->
                <p>头像:<img id="avatar" src="" alt="头像"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:;" id="addSelectAvatarButton" onclick="addSelectAvatar()">选择</a></p>
                <input type="text" name="newAvatar" style="display:none;"/>
                <p>昵称：<input type="text" name="userName" style="font-family: '幼圆';outline: none;"/></p>
                <p>签名：<input type="text" name="mySign" style="font-family: '幼圆';outline: none;"/></p>
                <p>姓名：<input type="text" name="myName" style="font-family: '幼圆';outline: none;"/></p>
                <p>生日：<input type="text" name="myBirth" placeholder="格式为：xxxx.xx.xx" style="font-family: '幼圆';outline: none;"/></p><br/>
                <p><input type="submit" class="submitButton" value="保存" /></p>
                <a href="ChatApp.jsp" style="position: absolute;left: -70px;bottom:10px;text-decoration: none;color: gray">取消</a>
            </form>
        </div>
        <div id="selectAvatar" class="selectAvatar" style="display: none;">
            
        </div>
        
    </body>
</html>
