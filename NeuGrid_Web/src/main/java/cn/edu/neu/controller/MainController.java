package cn.edu.neu.controller;


import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
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
    // 全部客户
    @RequestMapping(value = "/getAllClients", method = {RequestMethod.POST})
    @ResponseBody
    public JSONArray getAllClients() throws Exception {
    	System.out.println("[INFO] api/getAllClients 收到访问请求，正在处理");
        //String yearTermNo = jsonParam.optString("term");
        JSONArray data = MySQL.getAllClients();
        String code = Constant.RESPONSE_CODE_SUCCESS_REALTIME; // 返回状态码
        String msg = "获取全部客户信息成功";// 返回信息
        return data;
    }
    
    private JSONObject response(String code, String msg, Object data) {
        JSONObject result = new JSONObject();
        result.put("code", code);
        result.put("data", data);
        result.put("msg", msg);
        return result;
    }
}
