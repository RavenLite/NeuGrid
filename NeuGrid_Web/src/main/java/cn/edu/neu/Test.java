/**
 * 
 */package cn.edu.neu;

import java.sql.SQLException;
import java.text.ParseException;

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
	 * @throws ParseException 
	 */
	public static void main(String[] args) throws ClassNotFoundException, SQLException, ParseException {

		//MySQL.read("20180828", "2000", "140", "1"); // 抄表
		//MySQL.pay("1000", "100", "CCB", "2000"); // 缴费
		//MySQL.revert("5003"); // 冲正
		MySQL.check_total("CMB", "3", "300", "20180820");
		//MySQL.check_detail("CMB", "20180820");
	}

}
