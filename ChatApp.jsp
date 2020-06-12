<%-- 
    Document   : ChatApp
    Created on : 2020-6-1, 15:36:55
    Author     : KevinTech
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" import="CourseDesignPackage.*"%>
<%@page import="java.sql.*,java.io.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>微讯</title>
        <link rel="stylesheet" href="../css文件/ChatPageStyle.css" type="text/css">
        <script type="text/javascript" src="../JavaScript文件/ChatPageMove.js"></script>
        <script type="text/javascript">
            var time1,time2,time3,time4;
            var connect;
            var messagePanelId=new Array(1000);
            var buttonExpress=0;
            var mArray;
            var imgNumber=0;
            window.onload = function unit(){//初始化页面
                //防止直接进入主程序
                var testing="<%=(String)session.getAttribute("userID")%>";
                if(testing==="null"){
                    window.location.href="../html文件/Login.html";
                }
                
                //获取个人信息
                <%
                    //遍历文件查找表情包图片文件
                    String imgFileNameStr="";
                    File file = new File("D:/JavaWebProject/CourseDesign/src/java/ExpressPackage");
                    if(file.exists()){
                        
                        File[] files = file.listFiles();
                        if(null!=files){
                            for(File imgFile : files){
                                imgFileNameStr=imgFileNameStr+imgFile.getName()+",";
                            }
                        }else System.out.println("文件夹为空！");
                    }
                    else System.out.println("文件夹不存在！");
                    String userID=(String)session.getAttribute("userID");
                    ConnectDataBase db=new ConnectDataBase();//连接数据库
                    String avatar="";
                    String name="";
                    String signature="";
                    String birthday="";
                    String userName="";
                    boolean state=false;
                    //消息列表信息字符串变量合集
                    String messageStr="";
                    String messageRcordStr="";
                    //好友列表信息字符串变量合集
                    String FriendStr="";
                    String FriendAvatarStr="";
                    String FriendSignStr="";
                    String FriendNameStr="";
                    String FriendBirthStr="";
                    String FriendUserNameStr="";
                    String FriendStateStr="";
                    //群聊列表信息字符串变量合集
                    String GroupStr="";
                    String GroupNameStr="";
                    String GroupMembersStr="";
                    String GroupOnlineNumberStr="";
                    String GroupLeaderNameStr="";
                    String GroupLeaderStr="";
                    String GroupAvatarStr="";
                    String GroupMembersAvatarArrayStr="";
                    String GroupMembersUserNameArrayStr="";
                    String GroupMembersAvatarStr="";
                    String GroupMembersUserNameStr="";
                    db.connect();
                    ResultSet rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+userID+"'");
                    try{
                        if(rs.next()){
                            avatar=rs.getString("AVATAR");
                            name=rs.getString("NAME");
                            signature=rs.getString("SIGNATURE");
                            birthday=rs.getString("BIRTHDAY");
                            userName=rs.getString("USERNAME");
                            state=rs.getBoolean("STATE");
                        }
                        rs=null;
                        db.closeDB();
                        //加载消息列表数据
                        String[] reid=new String[1000];
                        int cor=0;
                        db.connect();
                        rs=db.executeQuery("select * from APP.MESSAGELIST where sendID='"+userID+"'");
                        while(rs.next()){
                            reid[cor]=rs.getString("RECEIVEID");
                            cor++;
                            messageStr=messageStr+rs.getString("RECEIVEID")+"{--*%&￥&*#&*--}"+rs.getString("RECEIVENAME")+"{--*%&￥&*#&*--}"+rs.getString("RECEIVEAVATAR")+"{--*%&￥&*#&*--}"+rs.getString("RECEIVELASTMESSAGE")+"{--*%&￥&*#&*--}"+"{-#$%^&*(*&^%-}";
                        }
                        for(int o=0;o<cor;o++){
                            rs=null;
                            db.closeDB();
                            db.connect();
                            if(reid[o].length()>6){
                                rs=db.executeQuery("select * from APP.FRIENDMAP where MY='"+userID+"' and YOU='"+reid[o]+"' or MY='"+reid[o]+"' and YOU='"+userID+"'");
                            }
                            else {
                                rs=db.executeQuery("select * from APP.GROUPMEMBERS where MY='"+userID+"' and YOU='"+reid[o]+"' or MY='"+reid[o]+"' and YOU='"+userID+"'");
                            }
                            try{
                                while(rs.next()){
                                    File myFilePath = new File("D:/ChatAppRecord/"+userID+"/"+rs.getString("RECORDFILE")+".txt");
                                    BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(myFilePath),"UTF-8"));
                                    String tempString = null;  
                                    // 一次读入一行，直到读入null为文件结束  
                                    while ((tempString = reader.readLine()) != null) {  
                                        messageRcordStr=messageRcordStr+tempString+"{-2……%#30！*98^_}";
                                    }
                                    messageRcordStr+="{+_*%^&^%*#@}";
                                    reader.close();
                                }
                            }
                            catch(Exception e){
                                e.printStackTrace();
                            }
                        }
                        
                        /*File myFilePath = new File("D:/ChatAppRecord/"+userID+"/");
                        文件写入操作
                        // 获取该文件的缓冲输出流
                        BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file), "UTF-8"));
                       // 写入信息
                        bufferedWriter.write(content);
                        bufferedWriter.flush();// 清空缓冲区
                        bufferedWriter.close();// 关闭输出流
                        //读取文件messagelist
                        BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(myFilePath),"UTF-8"));
                        String tempString = null;  
                        // 一次读入一行，直到读入null为文件结束  
                        while ((tempString = reader.readLine()) != null) {  
                            messageStr=messageStr+tempString+"{-#$%^&*(*&^%-}";
                        }
                        reader.close();
                        */
                        rs=null;
                        db.closeDB();
                        //加载好友列表数据
                        db.connect();
                        rs=db.executeQuery("select * from APP.FRIENDMAP where MY='"+userID+"' or YOU='"+userID+"'");
                        String[] FriendArray;
                        
                        while(rs.next()){
                            if(userID.equals(rs.getString("MY"))){
                                FriendStr=FriendStr+rs.getString("YOU")+",";
                            }
                            if(userID.equals(rs.getString("YOU"))){
                                FriendStr=FriendStr+rs.getString("MY")+",";
                            }
                        } 
                        FriendArray=FriendStr.split(",");
                        for(int i=0;i<FriendArray.length;i++){
                            rs=null;
                            db.closeDB();
                            db.connect();
                            rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+FriendArray[i]+"'");
                            while(rs.next()){
                                FriendAvatarStr=FriendAvatarStr+rs.getString("AVATAR")+",";
                                FriendSignStr=FriendSignStr+rs.getString("SIGNATURE")+"{--%^$$#@^&*--}";
                                FriendNameStr=FriendNameStr+rs.getString("NAME")+"{--%^$$#@^&*--}";
                                FriendBirthStr=FriendBirthStr+rs.getString("BIRTHDAY")+"{--%^$$#@^&*--}";
                                FriendUserNameStr=FriendUserNameStr+rs.getString("USERNAME")+"{--%^$$#@^&*--}";
                                FriendStateStr=FriendStateStr+String.valueOf(rs.getBoolean("STATE"))+",";
                            }
                        }
                        rs=null;
                        db.closeDB();
                        //加载群聊列表数据
                        db.connect();
                        rs=db.executeQuery("select * from APP.GROUPMEMBERS where MEMBERSID='"+userID+"'");
                        String[] GroupArray;
                        while(rs.next()){
                            GroupStr=GroupStr+rs.getString("GROUPID")+",";
                        }
                        GroupArray=GroupStr.split(",");
                        for(int i=0;i<GroupArray.length;i++){
                            rs=null;
                            db.closeDB();
                            db.connect();
                            rs=db.executeQuery("select * from APP.GROUPCHAT where ID='"+GroupArray[i]+"'");
                            while(rs.next()){
                                GroupAvatarStr=GroupAvatarStr+rs.getString("GROUPAVATAR")+",";
                                GroupLeaderNameStr=GroupLeaderNameStr+rs.getString("GROUPLEADERNAME")+"{--%^$$#@^&*--}";
                                GroupLeaderStr=GroupLeaderStr+rs.getString("GROUPLEADER")+",";
                                GroupOnlineNumberStr=GroupOnlineNumberStr+rs.getString("ONLINENUMBER");
                                GroupMembersStr=GroupMembersStr+rs.getString("MEMBERS");
                                GroupNameStr=GroupNameStr+rs.getString("NAME")+"{--%^$$#@^&*--}";
                            }
                            rs=null;
                            db.closeDB();
                            db.connect();
                            rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID in ( select MEMBERSID from APP.GROUPMEMBERS where GROUPID='"+GroupArray[i]+"')");
                            while(rs.next()){
                                GroupMembersAvatarStr=GroupMembersAvatarStr+rs.getString("AVATAR")+",";
                                GroupMembersUserNameStr=GroupMembersUserNameStr+rs.getString("USERNAME")+"{--%^$$#@^&*--}";
                            }
                            GroupMembersAvatarArrayStr=GroupMembersAvatarArrayStr+GroupMembersAvatarStr+"{}";
                            GroupMembersUserNameArrayStr=GroupMembersUserNameArrayStr+GroupMembersUserNameStr+"{--&(*&--}";
                        }
                    }
                    catch(Exception e){
                        e.printStackTrace();
                    }
                    db.closeDB();
                %>
                var avatar="<%=avatar%>",signature="<%=signature%>",name="<%=name%>",birthday="<%=birthday%>",userName="<%=userName%>";
                var State="<%=state%>";
                var userID="<%=(String)session.getAttribute("userID")%>";
                var avatarNode=document.getElementById("myAvatar");
                if ("WebSocket" in window){
                    // 打开一个 web socket
                    connect = new WebSocket("ws://localhost:8080/CourseDesign/chat/"+testing);
                    connect.onopen = function(){
                        // Web Socket 已连接上
                        
                    };
                    connect.onmessage = function (evt){ 
                        var r_msg = evt.data;
                       /* var reader=new FileReader();
                        //设置FileReader对象的读取文件回调方法
                        reader.onload=function(eve){
                            //判断文件是否读取完成
                            if(eve.target.readyState===FileReader.DONE){
                                //读取文件完成后，创建img标签来显示服务端传来的字节数//组
                                var img =document.createElement("img");
                                //读取文件完成后内容放在this===当前
                                //fileReader对象的result属性中，将该内容赋值img标签
                                //浏览器就可以自动解析内容格式并且渲染在浏览器中
                                img.src=this.result;
                                //将标签添加到id为show的div中否则，即便是有img也看不见
                                document.body.appendChild(img);
                                
                            }
                        };
                        //调用FileReader的readAsDataURL的方法自动就会触发onload事件
                        reader.readAsDataURL(evt.data);
                        if(r_msg.substring(r_msg.length-4)==="true"){
                            addMessageDiv(r_msg);
                        }
                        else if(r_msg.substring(r_msg.length-5)==="false"){
                            addMessageDiv(r_msg);
                        }
                        else{
                            
                        }*/
                        addMessageDiv(r_msg);
                        //connect.send(r_msg.substring(r_msg.lastIndexOf(",")+1)+","+r_msg.substring(r_msg.indexOf(",")+1,r_msg.lastIndexOf(","))+","+"myself:"+r_msg.substring(0,r_msg.indexOf(",")));
                    };
                    
                    connect.onclose = function(){ 
                      // 关闭 websocket
                      
                    };
                }
                else{
                   // 浏览器不支持 WebSocket
                   alert("您的浏览器不支持 WebSocket!");
                }
                avatarNode.setAttribute("src","../images/"+avatar);
                if(userName.length>9){
                    document.getElementById("myUserName").innerHTML=userName.substring(0,9)+"..";
                }
                else{
                    document.getElementById("myUserName").innerHTML=userName;
                }
                if(signature.length>11){
                    document.getElementById("mySignature").innerHTML=signature.substring(0,11)+"...";
                }
                else{
                    document.getElementById("mySignature").innerHTML=signature;
                }
                var Information=document.getElementById("Information");
                
                avatarNode.onmouseover=function(){//鼠标从头像上移开后
                    clearTimeout(time1);//清除定时器
                    Information.style.display="inline-block";
                };
                avatarNode.onmouseout=function(){//鼠标移动到头像上时
                    time1=setTimeout("Information.style.display='none';",300);
                };
                Information.onmouseover=function(){//鼠标移动到个人信息上时
                    clearTimeout(time1);//清除定时器
                    Information.style.display="inline-block";
                };
                Information.onmouseout=function(){//鼠标从个人信息上移开后
                    time1=setTimeout("Information.style.display='none';",300);
                };
                var person=document.person;
                if(userName.length>10){
                    person.uName.value=userName.substring(0,10)+"...";
                }
                else{
                    person.uName.value=userName;
                }
                if(signature.length>10){
                    person.sign.value=signature.substring(0,10)+"...";
                }
                else{
                    person.sign.value=signature;
                }
                person.ID.value=userID;
                person.Name.value=name;
                person.birth.value=birthday;
                if(State==="true"){
                    person.state.value="在线";
                }
                else{
                    person.state.value="离线";
                }
                var fatherMenu=document.getElementById("fahterMenu");
                var sonMenu=document.getElementById("sonMenu");
                var stateButton=document.getElementById("stateButton");
                var StateMenu=document.getElementById("StateMenu");
                fatherMenu.onmouseover=function(){//鼠标移动到折叠菜单按钮上
                    clearTimeout(time2);//清除定时器
                    clearTimeout(time3);//清除定时器
                    sonMenu.style.display="inline-block";
                    StateMenu.style.display="none";
                };
                fatherMenu.onmouseout=function(){//鼠标从折叠菜单按钮上移开时
                    time2=setTimeout("sonMenu.style.display='none';",300);
                };
                sonMenu.onmouseover=function(){//鼠标移动到折叠菜单子菜单上
                    clearTimeout(time2);//清除定时器
                    clearTimeout(time4);//清除定时器
                    sonMenu.style.display="inline-block";
                };
                sonMenu.onmouseout=function(){//鼠标从折叠菜单子菜单上移开时
                    time2=setTimeout("sonMenu.style.display='none';StateMenu.style.display='none';",300);
                };
                stateButton.onmouseover=function(){
                    clearTimeout(time2);//清除定时器
                    clearTimeout(time3);//清除定时器
                    StateMenu.style.display="inline-block";
                };
                stateButton.onmouseout=function(){//鼠标从折叠菜单子菜单上移开时
                    time3=setTimeout("StateMenu.style.display='none';",300);
                };
                StateMenu.onmouseover=function(){
                    clearTimeout(time2);//清除定时器
                    clearTimeout(time3);//清除定时器
                    clearTimeout(time4);//清除定时器
                    StateMenu.style.display="inline-block";
                    sonMenu.style.display="inline-block";
                };
                StateMenu.onmouseout=function(){//鼠标从折叠菜单子菜单上移开时
                    time3=setTimeout("StateMenu.style.display='none';",300);
                    time4=setTimeout("sonMenu.style.display='none';",300);
                };
                var imgFileName="<%=imgFileNameStr%>".split(",");//表情图片名数组
                var expressionPackage=document.getElementById("expressionPackage");
                for(var i=0;i<imgFileName.length-1;i++){
                    var aimg=document.createElement("img");
                    aimg.setAttribute("src","../images/ExpressPackage/"+imgFileName[i]);
                    aimg.setAttribute("class","a_imgStyle");
                    aimg.onclick=function(){
                        var smb=document.getElementById("rsBottom"+buttonExpress);
                        var obj= window.event?event.srcElement:evt.target;
                        smb.firstElementChild.value+="[/"+obj.src.substring(obj.src.lastIndexOf("/")+1,obj.src.lastIndexOf("."))+"]";
                    };
                    expressionPackage.append(aimg);
                }
                //加载消息列表
                var ML=document.getElementById("ML");
                var MLB=document.getElementById("MLB");
                ML.style.display="inline-block";
                MLB.style.backgroundColor="#333333";
                var messageStr="<%=messageStr%>";
                mArray=messageStr.split("{-#$%^&*(*&^%-}");
                for(var i=0;i<mArray.length-1;i++){
                    var mpA=mArray[i].split("{--*%&￥&*#&*--}");
                    var list=document.createElement("div");
                    list.setAttribute("class","MFGList");
                    list.setAttribute("id","MList_"+i.toString());
                    messagePanelId[i]=mpA[0];
                    
                    var img=document.createElement("img");
                    img.setAttribute("class","MFGListImg");
                    img.setAttribute("src","../images/"+mpA[2]);
                    img.setAttribute("id","MListi"+i.toString());
                    list.append(img);
                    var p=document.createElement("p");
                    p.setAttribute("class","MFGListUserName");
                    p.setAttribute("id","MListp"+i.toString());
                    if(mpA[1].length>7){
                        p.innerHTML=mpA[1].substring(0,6)+"...";
                    }
                    else {
                        p.innerHTML=mpA[1];
                    }
                    list.append(p);
                    var sign=document.createElement("p");
                    sign.setAttribute("class","MFGListSign");
                    sign.setAttribute("id","MLists"+i.toString());
                    var mpA3=mpA[3].split("{-@#%^}");
                    var mpS="";
                    for(var m=0;m<mpA3.length-1;m++){
                        mpS=mpS+mpA3[m]+" ";
                    }
                    mpS=mpS+mpA3[mpA3.length-1];
                    if(mpS.length>16){
                        sign.innerHTML=" [消息] "+mpS.substring(0,14)+"...";
                    }
                    else{
                        sign.innerHTML=" [消息] "+mpS;
                    }
                    list.append(sign);
                     //创建消息界面
                    var r_send=document.createElement("div");
                    r_send.setAttribute("class","r_sendStyle");
                    r_send.setAttribute("id","r_send"+i.toString());
                    document.getElementById("right").append(r_send);
                    var rsTop=document.createElement("p");
                    rsTop.innerHTML=mpA[1]+"<br/>"+mpA[0];
                    rsTop.setAttribute("class","rsTop");
                    r_send.append(rsTop);
                    var rsCenter=document.createElement("div");
                    rsCenter.setAttribute("class","rsCenter");
                    rsCenter.setAttribute("id","rsCenter"+i.toString());
                    r_send.append(rsCenter);
                    var rsBottom=document.createElement("div");
                    rsBottom.setAttribute("class","rsBottom");
                    rsBottom.setAttribute("id","rsBottom"+i.toString());
                    var rsta=document.createElement("textarea");
                    rsta.setAttribute("class","rsta");
                    rsta.onfocus=function(){
                        var obj= window.event?event.srcElement:evt.target;
                        var num=obj.parentNode.id.substring(8);
                        document.getElementById("expressionPackage").style.display="none";
                        document.getElementById("expression"+num).setAttribute("class","expressionStyle");
                    };
                    /*rsta.onblur=function(){
                        var obj= window.event?event.srcElement:evt.target;
                        var num=obj.parentNode.id.substring(8);
                        document.getElementById("expressionPackage").style.display="none";
                        document.getElementById("expression"+num).setAttribute("class","expressionStyle");
                    };*/
                    rsBottom.append(rsta);
                    var expression=document.createElement("button");//表情界面按钮
                    expression.setAttribute("class","expressionStyle");
                    expression.setAttribute("id","expression"+i.toString());
                    expression.setAttribute("title","表情");
                    expression.onclick=function(){
                        var obj= window.event?event.srcElement:evt.target;
                        if(obj.className==="pressAfterStyle"){
                            document.getElementById("expressionPackage").style.display="none";
                            obj.setAttribute("class","expressionStyle");
                        }
                        else{
                            document.getElementById("expressionPackage").style.display="inline-block";
                            obj.setAttribute("class","pressAfterStyle");
                        }
                        var num=obj.id.substring(10);
                        buttonExpress=num;
                        
                    };
                    rsBottom.append(expression);
                    var imagPanelButton=document.createElement("button");
                    imagPanelButton.setAttribute("class","imagPanelButtonStyle");
                    imagPanelButton.setAttribute("id","imagPanelButton"+i.toString());
                    imagPanelButton.setAttribute("title","上传图片");
                    imagPanelButton.onclick=function(){
                        var obj= window.event?event.srcElement:evt.target;
                        document.getElementById("expressionPackage").style.display="none";
                        obj.setAttribute("class","imagPanelButtonStyle");
                        document.getElementById("expression"+buttonExpress).setAttribute("class","expressionStyle");
                        document.getElementById("uploadfile").click();
                    };
                    rsBottom.append(imagPanelButton);
                    var sendButton=document.createElement("button");
                    sendButton.setAttribute("class","sendButton");
                    sendButton.innerHTML="发送";
                    sendButton.onclick=function(){//监听发送按钮
                        //发送信息
                        var obj= window.event?event.srcElement:evt.target;
                        var MCT=obj.parentNode.firstElementChild;//文本域
                        if(MCT.value!==""){
                            var num=obj.parentNode.parentNode.id.substring(6);
                            var rID=messagePanelId[num];//接收者ID
                            var str=MCT.value.toString().replace(/\n/g,"{-@#%^}");
                            connect.send(testing+","+str+","+rID);
                            addMessageDiv(testing+","+str+","+rID+"{-%^@#^%-}"+"<%=userName%>"+"{-%^@#^%-}"+"<%=avatar%>");
                            if(MCT.value.toString().length>16){
                                document.getElementById("MList_"+num).lastElementChild.innerHTML=" [消息] "+MCT.value.toString().substring(0,14)+"...";
                            }
                            else{
                                document.getElementById("MList_"+num).lastElementChild.innerHTML=" [消息] "+MCT.value.toString();
                            }
                            MCT.value="";//清空输入框
                        }
                    };
                    rsBottom.append(sendButton);
                    r_send.append(rsBottom);
                    list.onclick=function(){
                        var obj= window.event?event.srcElement:evt.target;
                        var num=parseInt(obj.id.substring(6));
                        for(var j=0;j<mArray.length-1;j++){
                            if(j!==num){
                                document.getElementById("r_send"+j.toString()).style.display="none";
                            }
                            document.getElementById("expressionPackage").style.display="none";
                            document.getElementById("expression"+j.toString()).setAttribute("class","expressionStyle");
                        }
                        if(document.getElementById("r_send_test")){
                            var r_send_test=document.getElementById("r_send_test");
                            r_send_test.parentNode.removeChild(r_send_test);
                        }
                        var MRS=document.getElementById("r_send"+num.toString());
                        MRS.style.display="inline-block";
                        document.getElementById("content").style.display="none";
                    };
                    ML.append(list); 
                }
                //加载消息记录
                var messageRecord="<%=messageRcordStr%>".split("{+_*%^&^%*#@}");
                for(var j=0;j<messageRecord.length-1;j++){
                    var amsgRecord=messageRecord[j].split("{-2……%#30！*98^_}");
                    for(var k=0;k<amsgRecord.length-1;k++){
                        addMessageDiv(amsgRecord[k]);
                    }
                }
                //加载好友列表
                var FL=document.getElementById("FL");
                var friends="<%=FriendStr%>".split(",");//注意：最后一个字符串是空串!!!
                var FriendAvatar="<%=FriendAvatarStr%>".split(",");
                var FriendSign="<%=FriendSignStr%>".split("{--%^$$#@^&*--}");
                var FriendName="<%=FriendNameStr%>".split("{--%^$$#@^&*--}");
                var FriendBirth="<%=FriendBirthStr%>".split("{--%^$$#@^&*--}");
                var FriendUserName="<%=FriendUserNameStr%>".split("{--%^$$#@^&*--}");
                var FriendState="<%=FriendStateStr%>".split(",");
                var FL=document.getElementById("FL");
                for(var i=0;i<friends.length-1;i++){
                    var list=document.createElement("div");
                    list.setAttribute("class","MFGList");
                    list.setAttribute("id","FList_"+i.toString());
                    var img=document.createElement("img");
                    img.setAttribute("class","MFGListImg");
                    img.setAttribute("src","../images/"+FriendAvatar[i]);
                    img.setAttribute("id","FListi"+i.toString());
                    list.append(img);
                    var p=document.createElement("p");
                    p.setAttribute("class","MFGListUserName");
                    p.setAttribute("id","FListp"+i.toString());
                    if(FriendUserName[i].length>7){
                        p.innerHTML=FriendUserName[i].substring(0,6)+"...";
                    }
                    else {
                        p.innerHTML=FriendUserName[i];
                    }
                    if(FriendState[i]==="false"){
                        p.innerHTML+="&nbsp;(离线)";
                    }
                    else if(FriendState[i]==="true"){
                        p.innerHTML+="&nbsp;(在线)";
                    }
                    list.append(p);
                    var sign=document.createElement("p");
                    sign.setAttribute("class","MFGListSign");
                    sign.setAttribute("id","FLists"+i.toString());
                    if(FriendSign[i].length>18){
                        sign.innerHTML=FriendSign[i].substring(0,16)+"...";
                    }
                    else{
                        sign.innerHTML=FriendSign[i];
                    }
                    list.append(sign);
                    list.onclick=function(){
                        var obj= window.event?event.srcElement:evt.target;
                        var num=parseInt(obj.id.substring(6));
                        if(document.getElementById("r_send_test")){
                            var r_send_test=document.getElementById("r_send_test");
                            r_send_test.parentNode.removeChild(r_send_test);
                        }
                        var content=document.getElementById("content");
                        content.style.display="inline-block";
                        var str="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
                        var newline="<br/><br/><br/><br/><br/><br/><br/>";
                        content.innerHTML="<br/><br/><br/><br/><br/><br/><br/><br/><br/>"+str;
                        if(FriendState[num]==="false"){
                            content.innerHTML+="昵称："+FriendUserName[num]+"<br/><br/>"+str+"ID&nbsp;&nbsp;："+friends[num]+"<br/><br/>"+str+"姓名："+FriendName[num]+"<br/><br/>"+str+"生日："+FriendBirth[num]+"<br/><br/>"+str+"签名："+FriendSign[num]+"<br/><br/>"+str+"状态：离线"+newline+str;
                        }
                        else if(FriendState[num]==="true"){
                            content.innerHTML+="昵称："+FriendUserName[num]+"<br/><br/>"+str+"ID&nbsp;&nbsp;："+friends[num]+"<br/><br/>"+str+"姓名："+FriendName[num]+"<br/><br/>"+str+"生日："+FriendBirth[num]+"<br/><br/>"+str+"签名："+FriendSign[num]+"<br/><br/>"+str+"状态：在线"+newline+str;
                        }
                        var button=document.createElement("button");
                        button.setAttribute("class","submitButton");
                        button.innerHTML="发消息";
                        button.onclick=function(){//转到聊天界面
                            content.style.display="none";
                            var flag=0;
                            //加载聊天消息面板
                            for(var l=0;l<mArray.length-1;l++){
                                var mpa=mArray[l].split("{--*%&￥&*#&*--}");
                                if(mpa[0]===friends[num]){
                                    document.getElementById("r_send"+l.toString()).style.display="inline-block";
                                    flag=1;
                                    break;
                                }
                            }
                           /* //若无则创建聊天消息面板
                            if(flag===0){
                                //创建消息界面
                                var r_send=document.createElement("div");
                                r_send.setAttribute("class","r_sendStyle");
                                r_send.setAttribute("id","r_send_test");
                                document.getElementById("right").append(r_send);
                                var rsTop=document.createElement("p");
                                rsTop.innerHTML=FriendUserName[num]+"<br/>"+friends[num];
                                rsTop.setAttribute("class","rsTop");
                                r_send.append(rsTop);
                                var rsCenter=document.createElement("div");
                                rsCenter.setAttribute("class","rsCenter");
                                r_send.append(rsCenter);
                                var rsBottom=document.createElement("div");
                                rsBottom.setAttribute("class","rsBottom");
                                var rsta=document.createElement("textarea");
                                rsta.setAttribute("class","rsta");
                                rsBottom.append(rsta);
                                var sendButton=document.createElement("button");
                                sendButton.setAttribute("class","sendButton");
                                sendButton.innerHTML="发送";
                                sendButton.onclick=function(){//监听发送按钮
                                    if(rsta.value!==""){
                                        r_send.setAttribute("id","r_send"+(mArray.length-1).toString());
                                        rsCenter.setAttribute("id","rsCenter"+(mArray.length-1).toString());
                                        var str=rsta.value.toString().replace(/\n/g,"{-@#%^}");
                                        connect.send(testing+","+str+","+friends[num]);
                                        //更新消息列表
                                        var newlist=document.createElement("div");
                                        newlist.setAttribute("class","MFGList");
                                        newlist.setAttribute("id","MList_"+(mArray.length-1).toString());
                                        messagePanelId[num]=friends[num];
                                        
                                        var newimg=document.createElement("img");
                                        newimg.setAttribute("class","MFGListImg");
                                        newimg.setAttribute("src","../images/"+FriendAvatar[num]);
                                        newimg.setAttribute("id","MListi"+(mArray.length-1).toString());
                                        newlist.append(newimg);
                                        var newp=document.createElement("p");
                                        newp.setAttribute("class","MFGListUserName");
                                        newp.setAttribute("id","MListp"+(mArray.length-1).toString());
                                        if(FriendUserName[num].length>7){
                                            newp.innerHTML=FriendUserName[num].substring(0,6)+"...";
                                        }
                                        else {
                                            newp.innerHTML=FriendUserName[num];
                                        }
                                        newlist.append(newp);
                                        var newsign=document.createElement("p");
                                        newsign.setAttribute("class","MFGListSign");
                                        newsign.setAttribute("id","MLists"+(mArray.length-1).toString());
                                        var mpA3=str.split("{-@#%^}");
                                        var mpS="";
                                        for(var m=0;m<mpA3.length-1;m++){
                                            mpS=mpS+mpA3[m]+" ";
                                        }
                                        mpS=mpS+mpA3[mpA3.length-1];
                                        if(mpS.length>16){
                                            newsign.innerHTML=" [消息] "+mpS.substring(0,14)+"...";
                                        }
                                        else{
                                            newsign.innerHTML=" [消息] "+mpS;
                                        }
                                        newlist.append(newsign);
                                        newlist.onclick=function(){
                                            var obj= window.event?event.srcElement:evt.target;
                                            var newnum=parseInt(obj.id.substring(6));
                                            for(var j=0;j<mArray.length-1;j++){
                                                document.getElementById("r_send"+j.toString()).style.display="none";
                                            }
                                            if(document.getElementById("r_send_test")){
                                                var r_send_test=document.getElementById("r_send_test");
                                                r_send_test.parentNode.removeChild(r_send_test);
                                            }
                                            var MRS=document.getElementById("r_send"+newnum.toString());
                                            MRS.style.display="inline-block";
                                            document.getElementById("content").style.display="none";
                                        };
                                        ML.append(newlist);
                                        if(rsta.value.toString().length>16){
                                            document.getElementById("MList_"+num).lastElementChild.innerHTML=" [消息] "+rsta.value.toString().substring(0,14)+"...";
                                        }
                                        else{
                                            document.getElementById("MList_"+num).lastElementChild.innerHTML=" [消息] "+rsta.value.toString();
                                        }
                                        addMessageDiv(testing+","+str+","+friends[num]+"{-%^@#^%-}"+"<%=userName%>"+"{-%^@#^%-}"+"<%=avatar%>");
                                        rsta.value="";
                                    }
                                };
                                rsBottom.append(sendButton);
                                r_send.append(rsBottom);
                                r_send.style.display="inline-block";
                            }*/
                        };
                        content.append(button);
                        for(var l=0;l<mArray.length-1;l++){
                            document.getElementById("r_send"+l.toString()).style.display="none";
                        }
                    };
                    FL.append(list);
                }
                //加载群聊列表
                var GL=document.getElementById("GL");
                var Group="<%=GroupStr%>".split(",");
                var GroupName="<%=GroupNameStr%>".split("{--%^$$#@^&*--}");
                var GroupMembers="<%=GroupMembersStr%>".split(",");
                var GroupOnlineNumber="<%=GroupOnlineNumberStr%>".split(",");
                var GroupLeaderName="<%=GroupLeaderNameStr%>".split("{--%^$$#@^&*--}");
                var GroupLeader="<%=GroupLeaderStr%>".split(",");
                var GroupAvatar="<%=GroupAvatarStr%>".split(",");
                var GroupMembersAvatarArrayStr="<%=GroupMembersAvatarArrayStr%>".split("{}");
                var GroupMembersUserNameArrayStr="<%=GroupMembersUserNameArrayStr%>".split("{--&(*&--}");
                for(var i=0;i<Group.length-1;i++){
                    var list=document.createElement("div");
                    list.setAttribute("class","MFGList");
                    list.setAttribute("id","GList_"+i.toString());
                    var img=document.createElement("img");
                    img.setAttribute("class","MFGListImg");
                    img.setAttribute("src","../images/"+GroupAvatar[i]);
                    img.setAttribute("id","GListi"+i.toString());
                    list.append(img);
                    var p=document.createElement("p");
                    p.setAttribute("class","MFGListUserName");
                    p.setAttribute("id","GListp"+i.toString());
                    if(GroupName[i].length>7){
                        p.innerHTML=GroupName[i].substring(0,6)+"..."+"("+GroupOnlineNumber[i]+"/"+GroupMembers[i]+")";
                    }
                    else {
                        p.innerHTML=GroupName[i]+"("+GroupOnlineNumber[i]+"/"+GroupMembers[i]+")";
                    }
                    list.append(p);
                    var sign=document.createElement("p");
                    sign.setAttribute("class","MFGListSign");
                    sign.setAttribute("id","MLists"+i.toString());
                    sign.innerHTML="群ID："+Group[i];
                    list.append(sign);
                    list.onclick=function(){
                        var obj= window.event?event.srcElement:evt.target;
                        var num=parseInt(obj.id.substring(6));
                        if(document.getElementById("r_send_test")){
                            var r_send_test=document.getElementById("r_send_test");
                            r_send_test.parentNode.removeChild(r_send_test);
                        }
                        var content=document.getElementById("content");
                        content.style.display="inline-block";
                        content.innerHTML="<br/>&nbsp;&nbsp;&nbsp;&nbsp;群&nbsp;名&nbsp;称："+GroupName[num]+"<br/>&nbsp;&nbsp;&nbsp;&nbsp;群&nbsp;&nbsp;&nbsp;&nbsp;ID："+Group[num]+"<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;群&nbsp;&nbsp;&nbsp;&nbsp;主："+GroupLeaderName[num]+"<br/>&nbsp;&nbsp;&nbsp;&nbsp;群主&nbsp;&nbsp;ID："+GroupLeader[num]+"<br/><br/>&nbsp;&nbsp;&nbsp;&nbsp;群&nbsp;成&nbsp;员：";
                        var div=document.createElement("div");
                        div.setAttribute("class","GroupMembersMessage");
                        var GroupMembersAvatar=GroupMembersAvatarArrayStr[num].split(",");
                        var GroupMembersUserName=GroupMembersUserNameArrayStr[num].split("{--%^$$#@^&*--}");
                        for(var k=0;k< GroupMembersAvatar.length-1;k++){
                            var avatarDiv=document.createElement("div");
                            avatarDiv.style.width="60px";
                            avatarDiv.style.height="80px";
                            avatarDiv.style.fontSize="10px";
                            avatarDiv.style.textAlign="center";
                            avatarDiv.style.border="0";
                            avatarDiv.style.float="left";
                            var avatarImg=document.createElement("img");
                            avatarImg.setAttribute("class","MFGListImg");
                            avatarImg.setAttribute("src","../images/"+GroupMembersAvatar[k]);
                            avatarImg.style.border="1px solid gray";
                            avatarImg.style.cursor="default";
                            avatarDiv.append(avatarImg);
                            if(GroupMembersUserName[k].length>4){
                                avatarDiv.innerHTML+=GroupMembersUserName[k].substring(0,4)+"...";
                            }
                            else{
                                avatarDiv.innerHTML+=GroupMembersUserName[k];
                            }
                            div.append(avatarDiv);
                        }
                        content.append(div);
                        var button=document.createElement("button");
                        button.setAttribute("class","submitButton");
                        button.innerHTML="进入群聊";
                        button.style.position="absolute";
                        button.style.left="36%";
                        button.style.top="90%";
                        button.onclick=function(){//转到聊天界面
                            content.style.display="none";
                            var flag=0;
                            //加载聊天消息面板
                            for(var l=0;l<mArray.length-1;l++){
                                var mpa=mArray[l].split("{--*%&￥&*#&*--}");
                                if(mpa[0]===Group[num]){
                                    document.getElementById("r_send"+l.toString()).style.display="inline-block";
                                    flag=1;
                                    break;
                                }
                            }
                            //若无则创建聊天消息面板
                            if(flag===0){
                                //创建消息界面
                                var r_send=document.createElement("div");
                                r_send.setAttribute("class","r_sendStyle");
                                r_send.setAttribute("id","r_send_test");
                                document.getElementById("right").append(r_send);
                                var rsTop=document.createElement("p");
                                rsTop.innerHTML=GroupName[num]+"<br/>"+Group[num];
                                rsTop.setAttribute("class","rsTop");
                                r_send.append(rsTop);
                                var rsCenter=document.createElement("div");
                                rsCenter.setAttribute("class","rsCenter");
                                r_send.append(rsCenter);
                                var rsBottom=document.createElement("div");
                                rsBottom.setAttribute("class","rsBottom");
                                var rsta=document.createElement("textarea");
                                rsta.setAttribute("class","rsta");
                                rsBottom.append(rsta);
                                var sendButton=document.createElement("button");
                                sendButton.setAttribute("class","sendButton");
                                sendButton.innerHTML="发送";
                                sendButton.onclick=function(){//监听发送按钮
                        
                                };
                                rsBottom.append(sendButton);
                                r_send.append(rsBottom);
                                r_send.style.display="inline-block";
                            }
                        };
                        content.append(button);
                        for(var l=0;l<mArray.length-1;l++){
                            document.getElementById("r_send"+l.toString()).style.display="none";
                        }
                    };
                    GL.append(list);
                }
                //监听上传文件框
                document.getElementById("uploadfile").addEventListener('change', function () {            
                   var filesList = document.querySelector('#uploadfile').files;
                   if(filesList.length===0){         //如果取消上传，则改文件的长度为0         
                      alert("No upload file！");
                   }else{  
                   	//如果有文件上传，这在这里面进行
                        startRead("imgis",document.getElementById("rsBottom"+buttonExpress));
                   }
                }); 
            };
            function addMessageDiv(msg){
                var str=msg.split("{-%^@#^%-}");
                var send=str[0].substring(0,str[0].indexOf(","));
                var message=str[0].substring(str[0].indexOf(",")+1,str[0].lastIndexOf(","));
                var sendIsName=str[1];
                var sendIsAvatar=str[2];
                var mpId;
                if(send==="<%=(String)session.getAttribute("userID")%>"){
                    var rID=str[0].substring(str[0].lastIndexOf(",")+1);
                    for(var i=0;i<messagePanelId.length;i++){
                        if(rID===messagePanelId[i]){
                            mpId=i.toString();
                            break;
                        }
                    }
                }
                else{
                    for(var i=0;i<messagePanelId.length;i++){
                        if(send===messagePanelId[i]){
                            mpId=i.toString();
                            break;
                        }
                    }
                }
                if(str[3]==="true"){
                    addMessageImg(send,message.substring(message.lastIndexOf("/")+1),sendIsName,sendIsAvatar,mpId);
                    return ;
                }
                var content=document.getElementById("rsCenter"+mpId);
                var list=document.getElementById("MList_"+mpId);
                var last=list.lastElementChild;
                var mpA3=message.split("{-@#%^}");
                var mpS="";
                for(var m=0;m<mpA3.length-1;m++){
                    mpS=mpS+mpA3[m]+" ";
                }
                mpS=mpS+mpA3[mpA3.length-1];
                if(mpS.length>16){
                    last.innerHTML=" [消息] "+mpS.substring(0,14)+"...";
                }
                else{
                    last.innerHTML=" [消息] "+mpS;
                }
                //制作气泡添加到面板中
                var amsg=document.createElement("div");
                amsg.setAttribute("class","amsg");
                var top=document.createElement("span");
                top.setAttribute("class","userNameIsTop");
                top.innerHTML=sendIsName;
                var left=document.createElement("img");
                left.setAttribute("class","avatarIsLeft");
                left.setAttribute("src","../images/"+sendIsAvatar);
                
                var msgpop=document.createElement("div");
                msgpop.setAttribute("class","msgpop");
                var num=0,len=0;
                var line=0;
                var contenLine=0;
                var ma=message.split("{-@#%^}");
                var max=len;
                var maxi=0;
                var msgpopTextContent=new Array();
                for(var i=0;i<ma.length;i++){
                    msgpopTextContent[contenLine]="";
                    num=0;
                    for(var j=0;j<ma[i].length;j++){
                        if(ma[i].charCodeAt(j)>255)num+=2;
                        else num++;
                        if(num>44){
                            contenLine++;
                            num=0;
                        }
                        if(ma[i][j]!==" "){
                            msgpopTextContent[contenLine]+=ma[i][j];
                        }
                        else{
                            msgpopTextContent[contenLine]+="&nbsp;";
                        }
                    }
                    contenLine++;
                }
                for(var i=0;i<msgpopTextContent.length;i++){
                    len=0;
                    for(var j=0;j<msgpopTextContent[i].length;j++){
                        if(msgpopTextContent[i].charCodeAt(j)>255)len+=2;
                        else len++;
                    } 
                    if(max<len){
                        max=len;
                        maxi=i;
                    }
                }
                msgpop.innerHTML+="&nbsp;&nbsp;<br/>&nbsp;&nbsp;";
                for(var i=0;i<msgpopTextContent.length;i++){
                    for(var j=0;j<msgpopTextContent[i].length;j++){
                        if(msgpopTextContent[i][j]==="["){
                            //表情长度5-15；
                            if(msgpopTextContent[i].substring(j).length>=5&&msgpopTextContent[i].substring(j,msgpopTextContent[i].indexOf("]")+1).length<=15){
                                var f=foundImgPackage(msgpopTextContent[i].substring(j,msgpopTextContent[i].indexOf("]")+1));
                                if(f===0) msgpop.innerHTML+=msgpopTextContent[i][j];
                                else {
                                    msgpop.append(f);
                                    if(maxi===i) max=max-msgpopTextContent[i].substring(j,msgpopTextContent[i].indexOf("]")+1).length+2;
                                    j+=msgpopTextContent[i].substring(j,msgpopTextContent[i].indexOf("]")+1).length-1;
                                }
                            }
                        }
                        else msgpop.innerHTML+=msgpopTextContent[i][j];
                    }
                    msgpop.innerHTML+="&nbsp;&nbsp;<br/>&nbsp;&nbsp;";
                }
                var width=0;
                if(max>44) {width=17*24;msgpop.style.width=width.toString()+"px";}
                else {width=17*(max/2+2);msgpop.style.width=width.toString()+"px";}
                msgpop.style.height=((msgpopTextContent.length+2)*20).toString()+"px";
                if(send==="<%=(String)session.getAttribute("userID")%>"){
                    left.style.top="0";
                    left.style.left="575px";
                    top.style.top="-34px";
                    top.style.left=(500-(sendIsName.length*10)).toString()+"px";
                    top.style.textAlign="right";
                    msgpop.style.top="-30px";
                    msgpop.style.left=(562-width).toString()+"px";
                    msgpop.style.backgroundColor="#00FF7F";
                }
                else{
                    left.style.top="0";
                    left.style.left="5px";
                    top.style.top="-34px";
                    top.style.left="15px";
                    top.style.textAlign="left";
                    msgpop.style.top="-30px";
                    msgpop.style.left="60px";
                    msgpop.style.backgroundColor="white";
                }
                amsg.append(left);
                amsg.append(top);
                amsg.append(msgpop);
                content.append(amsg);
                //让滚动条一直在最下方
                content.scrollTop=content.scrollHeight;
            }
            function foundImgPackage(str){
                var imgFileName="<%=imgFileNameStr%>".split(",");
                str=str.substring(str.indexOf("/")+1,str.indexOf("]"));
                for(var i=0;i<imgFileName.length-1;i++){
                    if(str===imgFileName[i].substring(0,imgFileName[i].indexOf("."))){
                        var expressionImg=document.createElement("img");
                        expressionImg.setAttribute("src","../images/ExpressPackage/"+imgFileName[i]);
                        expressionImg.setAttribute("class","expressionImg");
                        return expressionImg;
                    }
                }
                return 0;
                /*
                var max=imgFileName[0];
                var min=imgFileName[0];
                for(var i=0;i<imgFileName.length-1;i++){
                    if(max.length<imgFileName[i].length){
                        max=imgFileName[i];
                    }
                    if(min.length>imgFileName[i].length){
                        min=imgFileName[i];
                    }
                }
                alert(min);*/
            }
            function startRead(rsBottomNode) {
                var fileDom=document.getElementById("uploadfile");
                var img=document.createElement("img");
                img.setAttribute("id","img_"+imgNumber.toString());imgNumber++;
                if (fileDom&&img){
                    fileHandle(fileDom,img);
                }
            }
            //文件处理
            function fileHandle(fileDom,img) {
                //读取计算机文件
                var file=fileDom.files[0];
                var reader=new FileReader();
                reader.readAsDataURL(file);
                reader.onloadstart=function () {
                    //alert("开始上传中...");
                };
                //操作完成
                reader.onload = function(e){
                    //file 对象的属性
                    img.setAttribute("src",reader.result);
                    img.style.display="none";
                    document.body.append(img);
                    document.getElementById("MLists"+buttonExpress).innerHTML=" [消息] [图片]";
                    addMessageDiv("<%=(String)session.getAttribute("userID")%>"+",/"+img.id+","+mArray[parseInt(buttonExpress)].split("{--*%&￥&*#&*--}")[0]+"{-%^@#^%-}"+"<%=name%>"+"{-%^@#^%-}"+"<%=avatar%>"+"{-%^@#^%-}"+"true");
                    //发送图片给服务端
                    connect.send("<%=(String)session.getAttribute("userID")%>"+","+reader.result+",img->"+mArray[parseInt(buttonExpress)].split("{--*%&￥&*#&*--}")[0]+"/"+file.name);
                    document.getElementById("uploadfile").value=""; //清空<input type="file">的值
                };
            }
            function addMessageImg(sendID,ImgLink,sendName,sendAvatar,mpId){//添加图片
                var content=document.getElementById("rsCenter"+mpId);
                var list=document.getElementById("MList_"+mpId);
                var last=list.lastElementChild;
                last.innerHTML=" [消息] [图片]";
                //制作气泡添加到面板中
                var amsg=document.createElement("div");
                amsg.setAttribute("class","amsg");
                var top=document.createElement("span");
                top.setAttribute("class","userNameIsTop");
                top.innerHTML=sendName;
                var left=document.createElement("img");
                left.setAttribute("class","avatarIsLeft");
                left.setAttribute("src","../images/"+sendAvatar);
                
                var msgpop=document.createElement("div");
                msgpop.setAttribute("class","msgpop");
                var img;
                if(ImgLink.indexOf(".")===-1){
                    img=document.getElementById(ImgLink);
                    img.style.display="inline-block";
                }
                else{
                    img=document.createElement("img");
                    img.setAttribute("src","../images/uploadFile/"+ImgLink);
                }
                img.style.width="120px";
                img.style.marginLeft="10px";
                msgpop.append(img);
                msgpop.style.width="140px";
                msgpop.style.height=(img.height/img.width*140).toString()+"px";
                img.style.marginTop=(img.height/img.width*10).toString()+"px";
                if(sendID==="<%=(String)session.getAttribute("userID")%>"){
                    left.style.top="0";
                    left.style.left="575px";
                    top.style.top="-34px";
                    top.style.left=(500-(sendName.length*10)).toString()+"px";
                    top.style.textAlign="right";
                    msgpop.style.top="-30px";
                    msgpop.style.left=(562-140).toString()+"px";
                    msgpop.style.backgroundColor="#00FF7F";
                }
                else{
                    left.style.top="0";
                    left.style.left="5px";
                    top.style.top="-34px";
                    top.style.left="15px";
                    top.style.textAlign="left";
                    msgpop.style.top="-30px";
                    msgpop.style.left="60px";
                    msgpop.style.backgroundColor="white";
                }
                amsg.append(left);
                amsg.append(top);
                amsg.append(msgpop);
                content.append(amsg);
                //让滚动条一直在最下方
                content.scrollTop=content.scrollHeight;
            }
        </script>
    </head>
    <body>
        <div id="Information">
            <form action="SavePersonalInformation.jsp" method="post" name="person"><!--修改个人信息表单-->
                <p>&nbsp;&nbsp;您的&nbsp;ID&nbsp;：<input type="text" disabled name="ID" class="look"/></p>
                <p>&nbsp;&nbsp;您的昵称：<input type="text" readonly name="uName" class="look"/></p>
                <p>&nbsp;&nbsp;个性签名：<input type="text" readonly name="sign" class="look"/></p>
                <p>&nbsp;&nbsp;您的姓名：<input type="text" readonly name="Name" class="look"/></p>
                <p>&nbsp;&nbsp;您的生日：<input type="text" readonly name="birth" class="look"/></p>
                <p>&nbsp;&nbsp;当前状态：<input type="text" readonly name="state" class="look"/></p>
            </form>
        </div>
        <div class="ChatMainPanel">
            <div class="left">
                <div class="leftTop"><!--顶部展示个人头像昵称和签名信息-->
                    <img id="myAvatar" alt="头像" />
                    <p id="myUserName"></p>
                    <p id="mySignature"></p>
                    <p class="found"><!--搜索框-->
                        <input id="inputFound" class="inputFound" onfocus="clickFound()" onblur="loseFound()" type="text" placeholder=" 输入ID 搜索/添加 好友/群聊..."/>
                        <button id="buttonFound" onfocus="clickFound()" onblur="loseFound()" class="buttonFound">搜索</button>
                    </p>
                </div>
                <div id="leftCenter" class="leftCenter"><!--联系人消息选项卡-->
                    <div id="MLB" class="MLB" onclick="selected('message')">消息</div>
                    <div id="ML" class="List"></div>
                    <div id="FLB" class="FLB" onclick="selected('friend')">好友</div>
                    <div id="FL" class="List"></div>
                    <div id="GLB" class="GLB" onclick="selected('group')">群聊</div>
                    <div id="GL" class="List"></div>
                </div>
                <div class="leftBottom"><!--底部放置设置折叠菜单-->
                    <input type="button" id="fahterMenu" class="fahterMenu" value="☰"/>
                </div>
                <div id="sonMenu"><!--隐藏的菜单-->
                    <li onclick="editMyInformation()">编辑资料</li>
                    <li onclick="changePassWord()">修改密码</li>
                    <li id="stateButton">切换状态</li>
                    <li onclick="Exit()">注销账号</li>
                </div>
                <div id="StateMenu">
                    <li onclick="changeIsOnLine()">我在线上</li>
                    <li onclick="changeIsOffLine()">离线</li>
                </div>
            </div>
            <div id="right" class="right">
                <div style="position: absolute;left:47%;top: 47%;border:0;color: lightgray;font-size: 50px;background: rgba(0,0,0,0);">欢迎使用微讯！</div>
                <div id="content"></div>
            </div> 
        </div>
        <div id="expressionPackage"></div>
        <input id="uploadfile" name="fileName" type="file" style="display:none;" accept="image/jpeg,image/png,image/gif"/>
    </body>
</html>
