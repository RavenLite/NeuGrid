package cn.edu.neu.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * 数据库层操作，实现数据访问与service的分离
 * 
 * @author Raven
 */
public class MySQL {
    // JDBC驱动器名称及数据库地址
    private static final String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    private static final String DB_URL = "jdbc:mysql://localhost/neugrid";
    
    // 数据库访问凭证
    private static final String USER = "root";
    private static final String PASS = "9182urjfi79j91h9ughf819u";
    
    private static Connection conn = null;
    private static Statement stmt = null;
    
    // 预编译数据库语句 / 防止SQL注入， 提高性能
    private static boolean isPrepared = false;
    private static PreparedStatement statementGetAllClient;
    
    // 预编译语句结束
    public static void prepareSql() throws SQLException {
    	statementGetAllClient = conn.prepareStatement("SELECT * FROM client");
    }
    
	public static JSONArray getAllClients() throws ClassNotFoundException, SQLException {
		MySQL.before();
		// TODO:
		ResultSet resultSet = statementGetAllClient.executeQuery();
        JSONArray allClients = new JSONArray();
        while (resultSet.next()) {
        	JSONObject tempObj = new JSONObject();
        	tempObj.put("client_id", resultSet.getString("CLIENT_ID"));
        	tempObj.put("client_name", resultSet.getString("CLIENT_NAME"));
        	tempObj.put("address", resultSet.getString("ADDRESS"));
        	tempObj.put("balance", resultSet.getString("BALANCE"));
        	allClients.add(tempObj);
        }
        after();
        return allClients;
	}    
	
	/* 基础操作 */
    // 连接
    private static void connect() throws ClassNotFoundException, SQLException {
        if (conn == null || conn.isClosed()) { // 若连接为空或已关闭
            Class.forName(JDBC_DRIVER);
            System.out.println("[INFO] 正在尝试连接数据库  | Trying to connect with the database...");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            if (!conn.isClosed()) {
                prepareSql();
            } else {
                System.out.println("[WARNING] 数据库连接失败  | Database Connection Failed");
            }
        }
    }

    // 断开
    private static void disconnect() throws SQLException {
        if (!conn.isClosed()) {
            conn.close();
            System.out.println("[INFO] 数据库连接已断开  | Database disconnectes successfully");
        }
    }

    private static void before() throws SQLException, ClassNotFoundException {
        connect();
        stmt = conn.createStatement();
    }

    private static void after() throws SQLException {
        // disconnect(); // 暂时保持长连接
    }
}
