package com.example.growthlens.controller;

import com.example.growthlens.common.LoginUserHolder;
import com.example.growthlens.common.Result;
import com.example.growthlens.entity.ChatRecord;
import com.example.growthlens.entity.SysUser;
import com.example.growthlens.service.ChatService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/chat")
public class ChatController {

    @Autowired
    private final ChatService chatService;

    public ChatController(ChatService chatService) {
        this.chatService = chatService;
    }

    @GetMapping("/index")
    public String index() {
        return "chat/index";
    }

    @GetMapping("/script")
    public String script() {
        return "chat/script";
    }

    @GetMapping("/plan")
    public String plan() {
        return "chat/plan";
    }

    @GetMapping("/history")
    public String history(
            @RequestParam(defaultValue = "1") Integer pageNum,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(required = false) String sceneType,
            @RequestParam(required = false) Integer isCollected,
            Model model) {
        SysUser user = LoginUserHolder.getCurrentUser();
        PageHelper.startPage(pageNum, pageSize);
        List<ChatRecord> list;
        if (isCollected != null && isCollected == 1) {
            list = chatService.getCollectedRecords(user.getId());
        } else if (sceneType != null && !sceneType.isEmpty()) {
            list = chatService.getChatRecordsBySceneType(user.getId(), sceneType);
        } else {
            list = chatService.getUserChatRecords(user.getId());
        }
        PageInfo<ChatRecord> pageInfo = new PageInfo<>(list);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("sceneType", sceneType);
        model.addAttribute("isCollected", isCollected);
        return "chat/history";
    }

    @PostMapping("/free")
    @ResponseBody
    public Result<String> freeChat(
            @RequestParam String question,
            @RequestParam(required = false) String sessionId) {
        SysUser user = LoginUserHolder.getCurrentUser();
        String answer = chatService.freeChat(user.getId(), user.getUsername(), question, sessionId);
        return Result.success("生成成功", answer);
    }

    @PostMapping("/script")
    @ResponseBody
    public Result<String> generateScript(
            @RequestParam String sceneSubType,
            @RequestParam String context) {
        SysUser user = LoginUserHolder.getCurrentUser();
        String answer = chatService.generateScript(user.getId(), user.getUsername(), sceneSubType, context);
        return Result.success("生成成功", answer);
    }

    @PostMapping("/plan")
    @ResponseBody
    public Result<String> generatePlan(
            @RequestParam String skillName,
            @RequestParam String targetLevel,
            @RequestParam String duration) {
        SysUser user = LoginUserHolder.getCurrentUser();
        String answer = chatService.generateStudyPlan(user.getId(), user.getUsername(), skillName, targetLevel, duration);
        return Result.success("生成成功", answer);
    }

    @PostMapping("/collect/{id}")
    @ResponseBody
    public Result<Object> toggleCollection(
            @PathVariable Long id,
            @RequestParam Integer isCollected) {
        chatService.toggleCollection(id, isCollected);
        return Result.success();
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public Result<Object> deleteRecord(@PathVariable Long id) {
        chatService.deleteRecord(id);
        return Result.success();
    }

    @GetMapping("/record/{id}")
    @ResponseBody
    public Result<ChatRecord> getRecord(@PathVariable Long id) {
        ChatRecord record = chatService.getRecordById(id);
        return Result.success(record);
    }
}
