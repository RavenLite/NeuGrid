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
    
    private static PreparedStatement statementGetAllClients;
    private static PreparedStatement statementGetAllDevices;
    private static PreparedStatement statementGetAllReaders;
    private static PreparedStatement statementGetAllBanks;
    
    private static PreparedStatement statementAddClient;
    private static PreparedStatement statementAddDevice;
    private static PreparedStatement statementAddReader;
    private static PreparedStatement statementAddBank;
    
    private static PreparedStatement statementGetClientByClientID;
    private static PreparedStatement statementgetDevicesByClient_ID;
    private static PreparedStatement statementgetCostsByClient_ID;
    private static PreparedStatement statementgetTotalPaidFeeByClient_ID;
    
    // 预编译语句结束
    public static void prepareSql() throws SQLException {
    	statementGetAllClients = conn.prepareStatement("SELECT * FROM client");
    	statementGetAllDevices = conn.prepareStatement("SELECT * FROM device");
    	statementGetAllReaders = conn.prepareStatement("SELECT * FROM reader");
    	statementGetAllBanks = conn.prepareStatement("SELECT * FROM bank");
    	
    	statementAddClient = conn.prepareStatement("insert into client (CLIENT_ID, CLIENT_NAME, ADDRESS, BALANCE) values (?, ?, ?, 0)");
    	statementAddDevice = conn.prepareStatement("insert into device (DEVICE_ID, CLIENT_ID, DEVICE_TYPE) values (?, ?, ?)");
    	statementAddReader = conn.prepareStatement("insert into reader (READER_ID, READER_NAME) values (?, ?)");
    	statementAddBank = conn.prepareStatement("insert into bank (BANK_ID, BANK_NAME, ADDRESS, BALANCE) values (?, ?)");
    	
    	statementGetClientByClientID = conn.prepareStatement("SELECT * FROM client WHERE CLIENT_ID = ?");
    	statementgetDevicesByClient_ID = conn.prepareStatement("SELECT * FROM device WHERE CLIENT_ID = ?");
    	statementgetCostsByClient_ID = conn.prepareStatement("SELECT * FROM cost_log WHERE DEVICE_ID IN (SELECT DEVICE_ID FROM device WHERE CLIENT_ID = ?) and PAY_STATE = 0");
    	statementgetTotalPaidFeeByClient_ID = conn.prepareStatement("SELECT sum(PAID_FEE) AS 'TOTAL_FEE' FROM cost_log WHERE DEVICE_ID IN (SELECT DEVICE_ID FROM device WHERE CLIENT_ID = ?) and PAY_STATE = 0");
    }
    
    /* 1.获取某表全部记录 */
    // 1.1获取全部客户信息
	public static JSONArray getAllClients() throws ClassNotFoundException, SQLException {
		before();
		
		ResultSet resultSet = statementGetAllClients.executeQuery();
        JSONArray result = new JSONArray();
        while (resultSet.next()) {
        	JSONObject tempObj = new JSONObject();
        	tempObj.put("client_id", resultSet.getString("CLIENT_ID"));
        	tempObj.put("client_name", resultSet.getString("CLIENT_NAME"));
        	tempObj.put("address", resultSet.getString("ADDRESS"));
        	tempObj.put("balance", resultSet.getString("BALANCE"));
        	result.add(tempObj);
        }
        after();
        return result;
	}    
	// 1.2获取全部设备信息
	public static JSONArray getAllDevices() throws ClassNotFoundException, SQLException {
		before();
		
		ResultSet resultSet = statementGetAllDevices.executeQuery();
        JSONArray result = new JSONArray();
        while (resultSet.next()) {
        	JSONObject tempObj = new JSONObject();
        	tempObj.put("device_id", resultSet.getString("DEVICE_ID"));
        	tempObj.put("client_id", resultSet.getString("CLIENT_ID"));
        	tempObj.put("device_type", resultSet.getString("DEVICE_TYPE"));
        	result.add(tempObj);
        }
        after();
        return result;
	}    
	// 1.3获取全部抄表员信息
	public static JSONArray getAllReaders() throws ClassNotFoundException, SQLException {
		before();
		
		ResultSet resultSet = statementGetAllReaders.executeQuery();
        JSONArray result = new JSONArray();
        while (resultSet.next()) {
        	JSONObject tempObj = new JSONObject();
        	tempObj.put("reader_id", resultSet.getString("READER_ID"));
        	tempObj.put("reader_name", resultSet.getString("READER_NAME"));
        	result.add(tempObj);
        }
        after();
        return result;
	}    
	// 1.4获取全部银行信息
	public static JSONArray getAllBanks() throws ClassNotFoundException, SQLException {
		before();
		
		ResultSet resultSet = statementGetAllBanks.executeQuery();
        JSONArray result = new JSONArray();
        while (resultSet.next()) {
        	JSONObject tempObj = new JSONObject();
        	tempObj.put("bank_id", resultSet.getString("BANK_ID"));
        	tempObj.put("bank_name", resultSet.getString("BANK_NAME"));
        	result.add(tempObj);
        }
        after();
        return result;
	}    

	/* 2.向某表增加记录*/
	// 2.1添加客户
	public static boolean addClient(String client_id, String client_name, String address) throws ClassNotFoundException, SQLException {
		statementAddClient.setInt(1, Integer.valueOf(client_id));
		statementAddClient.setString(2, client_name);
		statementAddClient.setString(3, address);
		before();
		
		int count = statementAddClient.executeUpdate();
		after();
		return true;
		
	}
	// 2.2添加设备
	public static boolean addDevice(String device_id, String client_id, String device_type) throws ClassNotFoundException, SQLException {
		statementAddDevice.setInt(1, Integer.valueOf(device_id));
		statementAddDevice.setInt(2, Integer.valueOf(client_id));
		statementAddDevice.setString(3, device_type);
		before();
		
		int count = statementAddDevice.executeUpdate();
		after();
		return true;
		
	}
	// 2.3添加抄表员
	public static boolean addReader(String reader_id, String reader_name) throws ClassNotFoundException, SQLException {
		statementAddReader.setInt(1, Integer.valueOf(reader_id));
		statementAddReader.setString(2, reader_name);
		before();
		
		int count = statementAddReader.executeUpdate();
		after();
		return true;
		
	}
	// 2.4添加银行
	public static boolean addBank(String bank_id, String bank_name) throws ClassNotFoundException, SQLException {
		statementAddBank.setInt(1, Integer.valueOf(bank_id));
		statementAddBank.setString(2, bank_name);
		before();
		
		int count = statementAddBank.executeUpdate();
		after();
		return true;
		
	}
	
	
	/* 5.根据指定属性获取满足条件的记录 */
	// 5.1根据CLIENT_ID获取单个用户信息(client)
	public static JSONObject getClientByClientID(String client_id) throws ClassNotFoundException, SQLException {
		before();

		statementGetClientByClientID.setInt(1, Integer.valueOf(client_id));
		ResultSet resultSet = statementGetClientByClientID.executeQuery();
		JSONObject result = new JSONObject();
		if(resultSet.next()) {
			result.put("client_id", resultSet.getString("CLIENT_ID"));
			result.put("client_name", resultSet.getString("CLIENT_NAME"));
			result.put("address", resultSet.getString("ADDRESS"));
			result.put("balance", resultSet.getString("BALANCE"));
		}
		after();
		return result;
		
	}
	
	// 5.2根据CLIENT_ID获取某客户全部设备信息(device)
	public static JSONArray getDevicesByClient_ID(String client_id) throws ClassNotFoundException, SQLException {
		before();
		
		ResultSet resultSet = statementgetDevicesByClient_ID.executeQuery();
        JSONArray devices = new JSONArray();
        while (resultSet.next()) {
        	JSONObject tempObj = new JSONObject();
        	tempObj.put("device_id", resultSet.getString("DEVICE_ID"));
        	tempObj.put("client_id", resultSet.getString("CLIENT_ID"));
        	tempObj.put("device_type", resultSet.getString("DEVICE_TYPE"));
        	devices.add(tempObj);
        }
        after();
        return devices;
	}
	
	// 5.3根据CLIENT_ID获取某客户全部账单信息(cost_log)
	public static JSONArray getCostsByClient_ID(String client_id) throws ClassNotFoundException, SQLException {
		before();

		statementgetCostsByClient_ID.setInt(1, Integer.valueOf(client_id));
		System.out.println(statementgetCostsByClient_ID);
		ResultSet resultSet = statementgetCostsByClient_ID.executeQuery();
        JSONArray devices = new JSONArray();
        while (resultSet.next()) {
        	JSONObject tempObj = new JSONObject();
        	tempObj.put("cost_id", resultSet.getString("COST_ID"));
        	tempObj.put("device_id", resultSet.getString("DEVICE_ID"));
        	tempObj.put("date", resultSet.getString("DATE"));
        	tempObj.put("begin_number", resultSet.getString("BEGIN_NUMBER"));
        	tempObj.put("end_number", resultSet.getString("END_NUMBER"));
        	tempObj.put("basic_cost", resultSet.getString("BASIC_COST"));
        	tempObj.put("additional_cost_1", resultSet.getString("ADDITIONAL_COST_1"));
        	tempObj.put("additional_cost_2", resultSet.getString("ADDITIONAL_COST_2"));
        	tempObj.put("paid_fee", resultSet.getString("PAID_FEE"));
        	tempObj.put("actual_fee", resultSet.getString("ACTUAL_FEE"));
        	tempObj.put("late_fee", resultSet.getString("LATE_FEE"));
        	tempObj.put("payable_date", resultSet.getString("PAYABLE_DATE"));
        	tempObj.put("pay_date", resultSet.getString("PAY_DATE"));
        	tempObj.put("already_fee", resultSet.getString("ALREADY_FEE"));
        	tempObj.put("pay_state", resultSet.getString("PAY_STATE"));
        	devices.add(tempObj);
        }
        after();
        return devices;
	}
	
	// 5.4根据CLIENT_ID获取该客户全部设备欠费总额
	public static JSONObject getTotalPaidFeeByClient_ID(String client_id) throws ClassNotFoundException, SQLException {
		before();
		
		statementgetTotalPaidFeeByClient_ID.setInt(1, Integer.valueOf(client_id));
		ResultSet resultSet = statementgetTotalPaidFeeByClient_ID.executeQuery();
		JSONObject result = new JSONObject();
		if(resultSet.next()) {
			result.put("total_fee", resultSet.getString("TOTAL_FEE"));
		}
		after();
		return result;
		
	}
	
	
	/* 基础操作 */
    // 连接数据库
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

    // 断开数据库
    private static void disconnect() throws SQLException {
        if (!conn.isClosed()) {
            conn.close();
            System.out.println("[INFO] 数据库连接已断开  | Database disconnectes successfully");
        }
    }

    // 前置操作
    private static void before() throws SQLException, ClassNotFoundException {
        connect();
        stmt = conn.createStatement();
    }

    // 后置操作
    private static void after() throws SQLException {
        // disconnect(); // 暂时保持长连接
    }
}
