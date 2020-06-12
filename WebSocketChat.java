/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package CourseDesignPackage;

/**
 *
 * @author KevinTech
 */

import java.awt.image.RenderedImage;
import java.io.*;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.sql.*;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import javax.imageio.ImageIO;
import javax.websocket.*;
import javax.websocket.RemoteEndpoint.Async;
import javax.websocket.RemoteEndpoint.Basic;
import javax.websocket.server.PathParam;
import javax.websocket.server.ServerEndpoint;
import sun.misc.BASE64Decoder;
 
@ServerEndpoint("/chat/{userId}")
public class WebSocketChat{
 
    private static int onlineCount = 0;  
    private static Map<String, WebSocketChat> clients = new ConcurrentHashMap<String, WebSocketChat>();
    private Session session;
    private String userId;
    //private static int id = 0;
    private static final ConnectDataBase db=new ConnectDataBase();
 
    /**
     * 打开连接，保存连接的用户
     * @param session
     * @param userId
     * @throws IOException
     */
    @OnOpen
    public void onOpen(Session session, @PathParam("userId") String userId) throws IOException {
        this.session = session;
        this.userId = userId;
        addOnlineCount();
        clients.put(userId, this);
        System.out.println("连接+1，在线人数："+onlineCount);
        db.connect();
        db.executeUpdate("update APP.PERSONINFORMATION set STATE='true' where ID='"+this.userId+"'");
        db.closeDB();
    }
 
    /**
     * 关闭连接，删除用户
     * @throws IOException
     * @throws SQLException
     */
    @OnClose
    public void onClose() throws IOException,SQLException {
        clients.remove(this.userId);
        subOnlineCount(); 
        System.out.println("连接-1，在线人数："+onlineCount);
        db.connect();
        String[][] ma;
        int i=0;
        int count=0;//个人消息记录的总数
        ResultSet rs=db.executeQuery("select count(*) as linenum from APP.ONEBYONERECORD where IDA='"+this.userId+"' or IDB='"+this.userId+"'");
        try{
            if(rs.next()){
                count=rs.getInt("linenum");
            }
            ma=new String[count][7];
            rs=null;
            db.closeDB();
            db.connect();
            rs=db.executeQuery("select * from APP.ONEBYONERECORD where IDA='"+this.userId+"' or IDB='"+this.userId+"'");
            while(rs.next()){
                ma[i][0]=rs.getString("IDA");
                ma[i][1]=rs.getString("AVATARA");
                ma[i][2]=rs.getString("USERNAMEA");
                ma[i][3]=rs.getString("MESSAGERECORD");
                ma[i][4]=rs.getString("IDB");
                ma[i][5]=rs.getString("FLAG");
                ma[i][6]=String.valueOf(rs.getBoolean("ISFILE"));
                i++;
            }
            rs=null;
            db.closeDB();
            db.connect();
            
            rs=db.executeQuery("select * from APP.FRIENDMAP");
            while(rs.next()){
                for(int j=0;j<i;j++){
                    if((ma[j][0].equals(rs.getString("MY"))&&ma[j][4].equals(rs.getString("YOU")))||(ma[j][4].equals(rs.getString("MY"))&&ma[j][0].equals(rs.getString("YOU")))){
                        System.out.println(ma[j][0]+","+ma[j][4]);
                        if("0".equals(ma[j][5])){
                            File myFilePath = new File("D:/ChatAppRecord/"+this.userId+"/"+rs.getString("RECORDFILE")+".txt");
                            System.out.println("D:/ChatAppRecord/"+this.userId+"/"+rs.getString("RECORDFILE")+".txt");
                            System.out.println(this.userId+"写入了聊天记录："+ma[j][0]+"{-2*^#@#!%-}"+ma[j][1]+"{-2*^#@#!%-}"+ma[j][2]+"{-2*^#@#!%-}"+ma[j][3]+"{2*&83.%^}");
                            // 写入信息
                            try ( // 获取该文件的缓冲输出流
                                    BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(myFilePath,true), "UTF-8"))) {
                                // 写入信息
                                bufferedWriter.write(ma[j][0]+","+ma[j][3]+","+ma[j][4]+"{-%^@#^%-}"+ma[j][2]+"{-%^@#^%-}"+ma[j][1]+"{-%^@#^%-}"+ma[j][6]+"\n");
                                bufferedWriter.flush();// 清空缓冲区
                            }
                            db.executeUpdate("update APP.ONEBYONERECORD set flag='"+this.userId+"' where IDA='"+this.userId+"' or IDB='"+this.userId+"'");
                        }
                        else if(!ma[j][5].equals(this.userId)){
                            File myFilePath = new File("D:/ChatAppRecord/"+this.userId+"/"+rs.getString("RECORDFILE")+".txt");
                            System.out.println("D:/ChatAppRecord/"+this.userId+"/"+rs.getString("RECORDFILE")+".txt");
                            System.out.println("写入聊天记录："+ma[j][0]+"{-2*^#@#!%-}"+ma[j][1]+"{-2*^#@#!%-}"+ma[j][2]+"{-2*^#@#!%-}"+ma[j][3]+"{2*&83.%^}");
                            // 写入信息
                            try ( // 获取该文件的缓冲输出流
                                    BufferedWriter bufferedWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(myFilePath,true), "UTF-8"))) {
                                // 写入信息
                                bufferedWriter.write(ma[j][0]+","+ma[j][3]+","+ma[j][4]+"{-%^@#^%-}"+ma[j][2]+"{-%^@#^%-}"+ma[j][1]+"{-%^@#^%-}"+ma[j][6]+"\n");
                                bufferedWriter.flush();// 清空缓冲区
                            }
                            db.executeUpdate("DELETE FROM APP.ONEBYONERECORD");
                            System.out.println("清空数据表！");
                        }
                    }
                }
            }
            db.executeUpdate("update APP.PERSONINFORMATION set STATE='false' where ID='"+this.userId+"'");
            db.closeDB();
        }
        catch(SQLException e){
            e.printStackTrace();
        }
    }
 
    /**
     * 发送消息
     * @param message
     * @throws IOException
     * @throws SQLException
     */
    @OnMessage
    public void onMessage(String message) throws IOException ,SQLException{
        String sendUid = message.substring(0,message.indexOf(","));
        String getUid = message.substring(message.lastIndexOf(",")+1);
        System.out.println("有"+getUid+"的消息："+message);
        String messageContent = message.substring(message.indexOf(",")+1,message.lastIndexOf(","));
        ResultSet rs;
        if(getUid.length()==6){
            System.out.println("群"+getUid+"的消息："+message);
            sendMessageAll(messageContent);
            
        }else if(getUid.length()==10){
            System.out.println("私信："+message);
            db.connect();
            String sendAvatar="";
            String sendUserName="";
            String getAvatar="";
            String getUserName="";
            rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+sendUid+"'");
            try{
                while(rs.next()){
                    sendUserName=rs.getString("USERNAME");
                    sendAvatar=rs.getString("AVATAR");
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            rs=null;
            db.closeDB();
            db.connect();
            rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+getUid+"'");
            try{
                while(rs.next()){
                    getUserName=rs.getString("USERNAME");
                    getAvatar=rs.getString("AVATAR");
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            rs=null;
            db.closeDB();
            db.connect();
            int count=0;
            rs=db.executeQuery("select count(*) as line from APP.ONEBYONERECORD");
            try{
                while(rs.next()){
                    count=rs.getInt("line");
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            count++;
            String sql="INSERT INTO APP.ONEBYONERECORD (IDA, AVATARA, USERNAMEA, IDB, AVATARB, USERNAMEB,MESSAGERECORD,FLAG,ORDERNUMBER,ISFILE) VALUES ('"+sendUid+"', '"+sendAvatar+"', '"+sendUserName+"', '"+getUid+"', '"+getAvatar+"','"+getUserName+"','"+messageContent+"','0',"+count+",'false')";
            db.executeUpdate(sql);
            db.closeDB();
            sendMessageTo(messageContent,sendUid,getUid,"false");
        }else{//发送图片给客户端
           
            /*try (
                    FileWriter output = new FileWriter(new File("D:/JavaWebProject/CourseDesign/web/images/uploadFile/"+getUid.substring(16)))) {
                    output.write(messageContent);
            }*/
            String filePath="";
            //base64字符串转化成图片
            try{
                BASE64Decoder decoder = new sun.misc.BASE64Decoder();
                //Base64解码
                byte[] bytes1 = decoder.decodeBuffer(messageContent.substring(messageContent.indexOf(",")+1));
                System.out.println(messageContent.substring(messageContent.indexOf(",")+1));
                ByteArrayInputStream bais = new ByteArrayInputStream(bytes1);
                RenderedImage bi1 = ImageIO.read(bais);
                filePath="D:/JavaWebProject/CourseDesign/web/images/uploadFile";
                File f = new File(filePath);
                //生成文件名
                if(f.exists()){
                    int count=0;
                    File[] files=f.listFiles();
                    for(File ff : files){
                        count++;
                    }
                    filePath=filePath+"/"+String.valueOf(count)+getUid.substring(getUid.lastIndexOf("."));
                    f=new File(filePath);
                    f.createNewFile();
                }
                ImageIO.write(bi1,getUid.substring(getUid.lastIndexOf(".")+1),f);//生成jpg/png/gif图片
            }catch(Exception e){
                e.printStackTrace();
            }
            //发送图片
            //sendImgMessage("D:/JavaWebProject/CourseDesign/web/images/uploadFile/"+getUid.substring(16),sendUid,getUid.substring(5,15));
            getUid=getUid.substring(5,15);
            //连接数据库更新messagelist
            db.connect();
            db.executeUpdate("update APP.MESSAGELIST set RECEIVELASTMESSAGE='[图片]' where SENDID='"+sendUid+"' and RECEIVEID='"+getUid+"' or RECEIVEID='"+sendUid+"' and SENDID='"+getUid+"'" );
            db.closeDB();
            db.connect();
            String sendAvatar="";
            String sendUserName="";
            String getAvatar="";
            String getUserName="";
            rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+sendUid+"'");
            try{
                while(rs.next()){
                    sendUserName=rs.getString("USERNAME");
                    sendAvatar=rs.getString("AVATAR");
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            rs=null;
            db.closeDB();
            db.connect();
            rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+getUid+"'");
            try{
                while(rs.next()){
                    getUserName=rs.getString("USERNAME");
                    getAvatar=rs.getString("AVATAR");
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            rs=null;
            db.closeDB();
            db.connect();
            int count=0;
            rs=db.executeQuery("select count(*) as line from APP.ONEBYONERECORD");
            try{
                while(rs.next()){
                    count=rs.getInt("line");
                }
            }
            catch(SQLException e){
                e.printStackTrace();
            }
            count++;
            String sql="INSERT INTO APP.ONEBYONERECORD (IDA, AVATARA, USERNAMEA, IDB, AVATARB, USERNAMEB,MESSAGERECORD,FLAG,ORDERNUMBER,ISFILE) VALUES ('"+sendUid+"', '"+sendAvatar+"', '"+sendUserName+"', '"+getUid+"', '"+getAvatar+"','"+getUserName+"','"+filePath+"','0',"+count+",'true')";
            db.executeUpdate(sql);
            db.closeDB();
            //发送文件路径
            sendMessageTo(filePath,sendUid,getUid,"true");
            return;
        }
        /*连接数据库更新messagelist*/
        db.connect();
        rs=null;
        rs=db.executeQuery("select * from APP.MESSAGELIST where SENDID='"+sendUid+"' and RECEIVEID='"+getUid+"' or RECEIVEID='"+sendUid+"' and SENDID='"+getUid+"'" );
        try{
            if(rs.next()){
                db.executeUpdate("update APP.MESSAGELIST set RECEIVELASTMESSAGE='"+messageContent+"' where SENDID='"+sendUid+"' and RECEIVEID='"+getUid+"' or RECEIVEID='"+sendUid+"' and SENDID='"+getUid+"'" );
            }
            else{
                rs=null;
                db.closeDB();
                db.connect();
                String mlsql="INSERT INTO APP.MESSAGELIST (SENDID,RECEIVEID, RECEIVENAME, RECEIVEAVATAR, RECEIVELASTMESSAGE) VALUES ('"+sendUid+"','"+getUid+"'";
                rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+getUid+"'");
                while(rs.next()){
                    mlsql=mlsql+rs.getString("USERNAME")+"','";
                    mlsql=mlsql+rs.getString("AVATAR")+"','";
                    mlsql=mlsql+messageContent+"')";
                }
                db.executeUpdate(mlsql);
                rs=null;
                db.closeDB();
                db.connect();
                mlsql="INSERT INTO APP.MESSAGELIST (SENDID,RECEIVEID, RECEIVENAME, RECEIVEAVATAR, RECEIVELASTMESSAGE) VALUES ('"+getUid+"','"+sendUid+",";
                rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+sendUid+"'");
                while(rs.next()){
                    mlsql=mlsql+rs.getString("USERNAME")+"','";
                    mlsql=mlsql+rs.getString("AVATAR")+"','";
                    mlsql=mlsql+messageContent+"')";
                }
                db.executeUpdate(mlsql);
            }
        }
        catch(SQLException e){
            e.printStackTrace();
        }
        db.closeDB();
        /*
        String[] messageArray=new String[1000];
        int line=0;
        File myFilePath = new File("D:/ChatAppRecord/"+sendUid+"/messagelist.txt");
        try (
             //读取文件messagelist
            BufferedReader reader = new BufferedReader(new InputStreamReader(new FileInputStream(myFilePath),"UTF-8"))) {
            String tempString = null;
            // 一次读入一行，直到读入null为文件结束
            while ((tempString = reader.readLine()) != null) {
                if(tempString.substring(0,10).equals(getUid)){
                    messageArray[line]=tempString.substring(0,tempString.substring(0,tempString.lastIndexOf("{")).lastIndexOf("}")+1)+messageContent+"{--*%&￥&*#&*--}";
                }
                else{
                    messageArray[line]=tempString;
                }
                System.out.println("文件读取中："+messageArray[line]);
                line++;
            }
            //文件写入
            OutputStreamWriter write = new OutputStreamWriter(new FileOutputStream(myFilePath),"UTF-8");      
            try (BufferedWriter writer = new BufferedWriter(write)) {
                for(int i=0;i<line;i++){
                    writer.write(messageArray[i]+"\n"); 
                    System.out.println("文件写入中："+messageArray[i]);
                }
            }
        }
        catch(Exception e){
            e.printStackTrace();
        }*/
    }
 
    /**
     * 错误打印
     * @param session
     * @param error
     */
    @OnError
    public void onError(Session session, Throwable error) {
        error.printStackTrace();  
    }
 
    /**
     * 消息发送
     * @param message
     * @param sendUid
     * @param getUid
     * @param isFile
     * @throws IOException
     */
    public void sendMessageTo(String message, String sendUid, String getUid,String isFile) throws IOException {
        WebSocketChat item = clients.get(getUid);
        if(item != null) {
            //消息内容包括发送者，接受者和消息内容
            System.out.println("私信："+sendUid);
            db.connect();
            ResultSet rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+sendUid+"'");
            try{
                while(rs.next()){
                    item.session.getAsyncRemote().sendText(sendUid+","+message+","+getUid+"{-%^@#^%-}"+rs.getString("USERNAME")+"{-%^@#^%-}"+rs.getString("AVATAR")+"{-%^@#^%-}"+isFile);
                }
            }
            catch(Exception e){
                e.printStackTrace();
            }
            db.closeDB();
        }else{//离线消息发送
            System.out.println("对方已离线！");
        }
    }
    /**
     * 消息发送
     * @param filePath
     * @param sendUid
     * @param getUid
     * @throws IOException
     */
    public void sendImgMessage(String filePath,String sendUid,String getUid) throws IOException {
        /*try{
            System.out.println(getUid);
            WebSocketChat item = clients.get(getUid);
            if(item != null) {
                FileInputStream fs = new FileInputStream(filePath);
                //获取指定文件的长度并用它来创建一个可以存放内容的字节数组
                byte[] content = new byte[fs.available()];
                //将图片内容读入到字节数组
                fs.read(content);
                //使用刚才的字节数组创建ByteBuffer对象
                ByteBuffer byteBuffer = ByteBuffer.wrap(content);
                //Basic basic = item.session.getBasicRemote();
                Async async = item.session.getAsyncRemote();//发送byteBuffer对象到客户端
                async.sendBinary(byteBuffer);
                //关闭文件流对象
                fs.close(); 
            }else{//离线消息发送
                System.out.println("对方已离线！");
            }
        }catch(IOException e){
            e.printStackTrace();
        }*/
    }
    /**
     * 群聊发送消息
     * @param message
     * @throws IOException
     */
    public void sendMessageAll(String message) throws IOException {
        for(WebSocketChat item : clients.values()) {
            item.session.getAsyncRemote().sendText(message);
        }  
    }
 
    /**
     * 获取当前在线人数，线程安全
     * @return
     */
    public static synchronized int getOnlineCount() {
        return onlineCount;  
    }
 
    /**
     * 添加当前在线人数
     */
    public static synchronized void addOnlineCount() {
        WebSocketChat.onlineCount++;
    }
 
    /**
     * 减少当前在线人数
     */
    public static synchronized void subOnlineCount() {
        WebSocketChat.onlineCount--;
    }
 
    /**
     *
     * @return
     */
    public static synchronized Map<String, WebSocketChat> getClients() {
        return clients;  
    }
    
    /**
    *查询数据库中state的值
    * @return
    * @param uid
    * @throws SQLException
    */
    public static Boolean getState(String uid)throws SQLException  {
        db.connect();
        ResultSet rs=db.executeQuery("select * from APP.PERSONINFORMATION where ID='"+uid+"'");
        try{
            if(rs.next()){
                if(rs.getBoolean("STATE")==false){
                    return false;
                }
            }
        }
        catch(SQLException e){
            e.printStackTrace();
        }
        db.closeDB();
        return true;
    }
}