/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
function clickFound(){//点击搜索按钮后聚焦到搜索框
    document.getElementById("inputFound").style.background="rgba(255,255,255,0.8)";
    document.getElementById("inputFound").focus();
                
}
function loseFound(){//搜索按钮搜索框都失去焦点
    document.getElementById("inputFound").style.background="rgba(255,255,255,0.5)";
}

function Exit(){//注销账户，销毁session并设置为离线状态
    window.location.href="../jsp文件/Eixt.jsp";
}
function changePassWord(){//切换账号然后跳转到登录页面
     window.location.href="../jsp文件/changePassWord.jsp";
}

function changeIsOnLine(){//切换到在线状态
    window.location.href="../jsp文件/changeIsState.jsp?name=OnLine";
}
function changeIsOffLine(){//切换到离线状态
    window.location.href="../jsp文件/changeIsState.jsp?name=OffLine";
}
function editMyInformation(){//编辑个人资料
    window.location.href="../jsp文件/editMyInformation.jsp";
}
function validateInform(){//验证修改信息表单提交的数据
    var form=document.editForm;
    if(form.userName.value===""){
        alert("昵称不可为空！");
        return false;
    }
    if(form.userName.value.length>18){
        alert("昵称不可多于18字！");
        return false;
    }
    if(form.mySign.value.length>80){
        alert("签名不可多于80字！");
        return false;
    }
    if(form.myName.value.length>6){
        alert("姓名不可多于6个字！");
        return false;
    }
    if(form.myBirth.value.length!==10){
        alert("生日格式错误！");
        return false;
    }
    return true;
}

function selected(str){//展示选中的选项卡
    var ML=document.getElementById("ML");
    var FL=document.getElementById("FL");
    var GL=document.getElementById("GL");
    var MLB=document.getElementById("MLB");
    var FLB=document.getElementById("FLB");
    var GLB=document.getElementById("GLB");
    if(str==="message"){
        ML.style.display="inline-block";
        FL.style.display="none";
        GL.style.display="none";
        MLB.style.backgroundColor="#333333";
        FLB.style.background="";
        GLB.style.background="";
    }else if(str==="friend"){
        ML.style.display="none";
        FL.style.display="inline-block";
        GL.style.display="none";
        MLB.style.background="";
        FLB.style.backgroundColor="#333333";
        GLB.style.background="";
    }else if(str==="group"){
        ML.style.display="none";
        FL.style.display="none";
        GL.style.display="inline-block";
        MLB.style.background="";
        FLB.style.background="";
        GLB.style.backgroundColor="#333333";
    } 
}