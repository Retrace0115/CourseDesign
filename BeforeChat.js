/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
//检测是否填写了账号与密码
function validateLogin(){
    var fr=document.loginForm;
    if(fr.username.value===""||fr.pswd.value===""){
	alert("用户名或密码不能为空！");
        return false;
    }
    else if(foundSpace(fr.username.value)===0){
        alert("用户名不正确！");
        return false;
    }
    else if(foundSpace(fr.pswd.value)===0){
        alert("密码错误！");
        return false;
    }
    else{
        return true;
    }
}

//检测注册信息是否合法
function validateRegister(){
    var fr=document.registerForm;
    var un=fr.registerName.value;
    var ps=fr.registerPswd.value;
    var nb=fr.registerNumber.value;
    if(un.length<1||un.length>12||foundSpace(un)===0){
        alert("您的昵称不合法！");
        return false;
    }
    if(ps.length<6||ps.length>16||foundSpace(ps)===0){
        alert("您的密码不合法！");
        return false;
    }
    if(nb.length!==11||nb[0]!=="1"||(nb[1]!=="3"&&nb[1]!=="5"&&nb[1]!=="7"&&nb[1]!=="8")||foundSpace(nb)===0){
        alert("电话号码不合法！");
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