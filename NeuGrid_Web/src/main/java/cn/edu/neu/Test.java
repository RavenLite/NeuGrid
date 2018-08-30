/**
 * 
 */package cn.edu.neu;

import java.sql.SQLException;

import cn.edu.neu.database.MySQL;

/**
 * @author dell
 *
 */
public class Test {

	/**
	 * @param args
	 * @throws SQLException 
	 * @throws ClassNotFoundException 
	 */
	public static void main(String[] args) throws ClassNotFoundException, SQLException {

		MySQL.pay("1000", "100", "CCB", "2000");
		//MySQL.read(read_date, device_id, read_number, reader_id);
	}

}
