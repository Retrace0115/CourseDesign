/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package CourseDesignPackage;
import java.sql.*;
/**
 *
 * @author KevinTech
 */
public class ConnectDataBase {
    Connection connection = null;
    
    ResultSet rs = null;
    String user="app";
    String password="123456";
    String url="jdbc:derby://localhost:1527/CourseDesign";//mysql数据库url
    
    public ConnectDataBase() {
	try {
	    //mysql数据库设置驱动程序
	    Class.forName("org.apache.derby.jdbc.ClientDriver"); 
	}
	catch(java.lang.ClassNotFoundException e) {
	    e.printStackTrace();
	}
    }
    /**
     * 连接数据库
     */
    public void connect(){
	try{
            //mysql数据库
	    connection = DriverManager.getConnection(url,user,password);  
	}
	catch(Exception e){
	    e.printStackTrace();
	}
    }
    /**
    * 关闭数据库*/
    public void closeDB(){
	try{
	    if(connection != null){
		connection.close();
		connection = null;
	    }
	}
	catch(Exception e){
	    e.printStackTrace();
	}
    }
    //查询
    public ResultSet executeQuery(String sql) {
	try {
	    PreparedStatement pstm = connection.prepareStatement(sql);
	    // 执行查询
	    rs = pstm.executeQuery();
	} 
	catch(SQLException ex) { 
	    ex.printStackTrace();
	}
	return rs;
    }
    //更新
    public int executeUpdate(String sql) {
	int count = 0;
	connect();
        try {
	    Statement stmt = connection.createStatement();
	    //执行更新
	    count = stmt.executeUpdate(sql);
	} 
	catch(SQLException ex) { 
	    System.err.println(ex.getMessage());		
	}
	closeDB();
	return count;
    }
    
}
