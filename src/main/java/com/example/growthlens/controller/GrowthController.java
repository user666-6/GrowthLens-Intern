package com.example.growthlens.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/growth")
public class GrowthController {

    @GetMapping("/list")
    public String dashboard() {
        return "growth/dashboard";
    }

    @GetMapping("/skill")
    public String skill() {
        return "growth/skill";
    }

    @GetMapping("/project")
    public String project() {
        return "growth/project";
    }

    @GetMapping("/feedback")
    public String feedback() {
        return "growth/feedback";
    }
}
