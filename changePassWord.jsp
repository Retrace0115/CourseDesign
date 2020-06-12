<%-- 
    Document   : changeUserName
    Created on : 2020-6-4, 17:10:13
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
    </head>
    <body>
        <script type="text/javascript">
            var oldPswd="<%=(String)session.getAttribute("userPswd")%>";
            window.onload = function unit(){//初始化页面
                //防止直接进入主程序
                var testing="<%=(String)session.getAttribute("userID")%>";
                if(testing==="null"){
                    window.location.href="../html文件/Login.html";
                }
            };
            function validateChangePassWord(){
                var form=document.changePasswordForm;
                var p1=form.oldPswd.value;
                var p2=form.newPswd1.value;
                var p3=form.newPswd2.value;
                if(p1===""){
                    alert("请输入原密码！");
                    return false;
                }
                if(p1!==oldPswd){
                    alert("原密码不正确！");
                    return false;
                }
                if(p2===""){
                    alert("请输入新密码！");
                    return false;
                }
                if(foundSpace(p2)===0){
                    alert("密码中含有空格！");
                    return false;
                }
                if(p3===""){
                    alert("请确认新密码！");
                    return false;
                }
                if(p2!==p3){
                    alert("两次输入的密码不一致！");
                    return false;
                }
                if(p1===p2){
                    alert("密码未更改！");
                    return false;
                }
                return true;
            }
            /*
             * 检测字符串是否含有空格
             * 有空格返回0
             * 无空格返回1
             */
            function foundSpace(str){
                var flag=1;
                for(var i=0;i<str.length;i++){
                    if(str[i]===" "){
                        flag=0;
                        return flag;
                    }
                }
            }
        </script>
        <div class="changePassWord"><!--修改密码面板-->
            <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
            <form action="saveChangePassWord.jsp" name="changePasswordForm" method="post" onSubmit="return validateChangePassWord();"><!--修改密码表单-->
                <span>
                    原&nbsp;密&nbsp;码：<input type="password" name="oldPswd" class="user" size="20" style="outline:none;"/>
                </span><br/><br/>
                <span>
                    新&nbsp;密&nbsp;码：<input type="password" name="newPswd1" placeholder="6-16位，不含空格！" class="user" size="20" style="outline:none;"/>
                </span><br/><br/><span>
                    确认密码：<input type="password" name="newPswd2" placeholder="6-16位，不含空格！" class="user" size="20" style="outline:none;"/>
                </span><br/><br/><br/>
                <span>
                    <input type="submit" value="保存修改" class="submitButton"/>
                </span>
            </form>
            <a href="ChatApp.jsp" style="position: absolute;left: 7px;bottom:10px;text-decoration: none;color: gray">取消</a>
        </div>
    </body>
</html>
