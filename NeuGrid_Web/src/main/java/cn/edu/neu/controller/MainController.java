package cn.edu.neu.controller;


import java.sql.SQLException;

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
    // 获取全部客户
    @RequestMapping(value = "/getAllClients", method = {RequestMethod.POST})
    @ResponseBody
    public JSONObject getAllClients() throws Exception {
    	System.out.println("[INFO] /api/getAllClients 收到访问请求，正在处理");
        //String yearTermNo = jsonParam.optString("term");
        JSONArray data = MySQL.getAllClients();
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取全部客户信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 添加客户
    @RequestMapping(value = "/addClient", method = {RequestMethod.GET})
    public void addClient(@RequestParam("client_name") String client_name, @RequestParam("client_id") String client_id, @RequestParam("address") String address) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/addClient 收到访问请求，正在处理");
    	
    	MySQL.addClient(client_id, client_name, address);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "添加客户成功";// 返回信息
    }
    
    // 根据client_id获取某客户信息
    @RequestMapping(value = "/getClientByClientID", method = {RequestMethod.GET})
    public JSONObject getClientByClientID(@RequestParam("client_id") String client_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/getClientByClientID 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.getClientByClientID(client_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取客户信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 根据client_id获取某客户拥有的设备信息
    @RequestMapping(value = "/getDevicesByClient_ID", method = {RequestMethod.GET})
    public JSONObject getDevicesByClient_ID(@RequestParam("client_id") String client_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/getDevicesByClient_ID 收到访问请求，正在处理");
    	
    	JSONArray data = MySQL.getDevicesByClient_ID(client_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取用户拥有的设备信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 根据client_id获取某客户拥有的账单信息
    @RequestMapping(value = "/getCostsByClient_ID", method = {RequestMethod.GET})
    public JSONObject getCostsByClient_ID(@RequestParam("client_id") String client_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/getCostsByClient_ID 收到访问请求，正在处理");
    	
    	JSONArray data = MySQL.getCostsByClient_ID(client_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取用户拥有的账单信息成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 根据client_id获取某客户全部设备欠费总额
    @RequestMapping(value = "/getTotalPaidFeeByClient_ID", method = {RequestMethod.GET})
    public JSONObject getTotalPaidFeeByClient_ID(@RequestParam("client_id") String client_id) throws ClassNotFoundException, SQLException {
    	System.out.println("[INFO] /api/getTotalPaidFeeByClient_ID 收到访问请求，正在处理");
    	
    	JSONObject data = MySQL.getTotalPaidFeeByClient_ID(client_id);
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取客户全部设备欠费总额成功";// 返回信息
        return response(code, msg, data);
    }
    
    // 获取全部设备
    
    private JSONObject response(String code, String msg, Object data) {
        JSONObject result = new JSONObject();
        result.put("code", code);
        result.put("data", data);
        result.put("msg", msg);
        return result;
    }
}
