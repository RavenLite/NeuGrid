package cn.edu.neu.controller;


import java.sql.SQLException;
import java.text.ParseException;

import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import cn.edu.neu.Constant;
import cn.edu.neu.database.MySQL;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/**
 * @author Raven
 *
 */
@RestController
@RequestMapping("/api")
public class MainController {
	/* 1.获取全部信息类*/
    // 1.1获取全部客户信息
    @RequestMapping(value = "/getAllClients", method = {RequestMethod.POST})
    @ResponseBody
    public JSONObject getAllClients() throws Exception {
    	System.out.println("[INFO] /api/getAllClients 收到访问请求，正在处理");
        JSONArray data = MySQL.getAllClients();
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取全部客户信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 1.2获取全部设备信息
    @RequestMapping(value = "/getAllDevices", method = {RequestMethod.POST})
    @ResponseBody
    public JSONObject getAllDevices() throws Exception {
    	System.out.println("[INFO] /api/getAllDevices 收到访问请求，正在处理");
        JSONArray data = MySQL.getAllDevices();
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取全部设备信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 1.3获取全部抄表员信息
    @RequestMapping(value = "/getAllReaders", method = {RequestMethod.POST})
    @ResponseBody
    public JSONObject getAllReaders() throws Exception {
    	System.out.println("[INFO] /api/getAllReaders 收到访问请求，正在处理");
        JSONArray data = MySQL.getAllReaders();
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取全部抄表员信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 1.4获取全部银行信息
    @RequestMapping(value = "/getAllBanks", method = {RequestMethod.POST})
    @ResponseBody
    public JSONObject getAllBanks() throws Exception {
    	System.out.println("[INFO] /api/getAllBanks 收到访问请求，正在处理");
        JSONArray data = MySQL.getAllBanks();
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取全部银行信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    
    /* 2.增加信息类*/
    // 2.1添加客户
    @RequestMapping(value = "/addClient", method = {RequestMethod.GET})
    public void addClient(@RequestParam("client_name") String client_name, @RequestParam("client_id") String client_id, @RequestParam("address") String address) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/addClient 收到访问请求，正在处理");
    	
    	MySQL.addClient(client_id, client_name, address);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "添加客户信息成功";// 返回信息
    }
    
    // 2.2添加设备
    @RequestMapping(value = "/addDevice", method = {RequestMethod.GET})
    public void addDevice(@RequestParam("device_id") String device_id, @RequestParam("client_id") String client_id, @RequestParam("device_type") String device_type) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/addDevice 收到访问请求，正在处理");
    	
    	MySQL.addDevice(device_id, client_id, device_type);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "添加设备信息成功";// 返回信息
    }
    
    // 2.3添加抄表员
    @RequestMapping(value = "/addReader", method = {RequestMethod.GET})
    public void addReader(@RequestParam("reader_id") String reader_id, @RequestParam("reader_name") String reader_name) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/addReader 收到访问请求，正在处理");
    	
    	MySQL.addReader(reader_id, reader_name);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "添加抄表员信息成功";// 返回信息
    }
        
    // 2.4添加银行
    @RequestMapping(value = "/addBank", method = {RequestMethod.GET})
    public void addBank(@RequestParam("bank_id") String bank_id, @RequestParam("bank_name") String bank_name) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/addBank 收到访问请求，正在处理");
    	
    	MySQL.addBank(bank_id, bank_name);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "添加银行信息成功";// 返回信息
    }
    
    /* 4.六大存储过程功能类 */
    // 4.1缴费
    @RequestMapping(value = "/pay", method = {RequestMethod.GET})
    public JSONObject pay(@RequestParam("client_id") String client_id, @RequestParam("money") String money, @RequestParam("bank_id") String bank_id, @RequestParam("device_id") String device_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/pay 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.pay(client_id, client_id, bank_id, device_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "缴费请求成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 4.2冲正
    @RequestMapping(value = "/revert", method = {RequestMethod.GET})
    public JSONObject revert(@RequestParam("transfer_id") String transfer_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/revert 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.revert(transfer_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "冲正请求成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 4.3抄表
    @RequestMapping(value = "/read", method = {RequestMethod.GET})
    public JSONObject read(@RequestParam("read_date") String read_date, @RequestParam("device_id") String device_id, @RequestParam("read_number") String read_number, @RequestParam("reader_id") String reader_id) throws ClassNotFoundException, SQLException, ParseException {
    	System.out.println("[INFO] /api/read 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.read(read_date, device_id, read_number, reader_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "抄表请求成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 4.4对总账
    @RequestMapping(value = "/check_total", method = {RequestMethod.GET})
    public JSONObject check_total(@RequestParam("bank_id") String bank_id, @RequestParam("count") String count, @RequestParam("amount") String amount, @RequestParam("date") String date) throws ClassNotFoundException, SQLException, ParseException {
    	System.out.println("[INFO] /api/check_total 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.check_total(bank_id, count, amount, date);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "对总账请求成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 4.5对明细
    @RequestMapping(value = "/check_detail", method = {RequestMethod.GET})
    public JSONObject check_detail(@RequestParam("bank_id") String bank_id, @RequestParam("date") String date) throws ClassNotFoundException, SQLException, ParseException {
    	System.out.println("[INFO] /api/check_detail 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.check_detail(bank_id, date);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "对明细请求成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 4.6查询客户欠费金额及个人信息
    @RequestMapping(value = "/query", method = {RequestMethod.GET})
    public JSONObject query(@RequestParam("client_id") String client_id) throws ClassNotFoundException, SQLException, ParseException {
    	System.out.println("[INFO] /api/query 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.query(client_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "查询请求成功";// 返回信息
        return response(code, msg, data);
    }
    
    /* 5.特殊要求类*/
    // 5.1根据client_id获取某客户信息
    @RequestMapping(value = "/getClientByClientID", method = {RequestMethod.GET})
    public JSONObject getClientByClientID(@RequestParam("client_id") String client_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/getClientByClientID 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.getClientByClientID(client_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取客户信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 5.2根据client_id获取某客户拥有的设备信息
    @RequestMapping(value = "/getDevicesByClient_ID", method = {RequestMethod.GET})
    public JSONObject getDevicesByClient_ID(@RequestParam("client_id") String client_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/getDevicesByClient_ID 收到访问请求，正在处理");
    	
    	JSONArray data = MySQL.getDevicesByClient_ID(client_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取用户拥有的设备信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 5.3根据client_id获取某客户拥有的账单信息
    @RequestMapping(value = "/getCostsByClient_ID", method = {RequestMethod.GET})
    public JSONObject getCostsByClient_ID(@RequestParam("client_id") String client_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/getCostsByClient_ID 收到访问请求，正在处理");
    	
    	JSONArray data = MySQL.getCostsByClient_ID(client_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取用户拥有的账单信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 5.4根据client_id获取某客户全部设备欠费总额
    @RequestMapping(value = "/getTotalPaidFeeByClient_ID", method = {RequestMethod.GET})
    public JSONObject getTotalPaidFeeByClient_ID(@RequestParam("client_id") String client_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/getTotalPaidFeeByClient_ID 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.getTotalPaidFeeByClient_ID(client_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取客户全部设备欠费总额成功";// 返回信息
        return response(code, msg, data);
    }
    
    /* 工具——统一格式返回值*/
    private JSONObject response(String code, String msg, Object data) {
        JSONObject result = new JSONObject();
        result.put("code", code);
        result.put("data", data);
        result.put("msg", msg);
        return result;
    }
}
