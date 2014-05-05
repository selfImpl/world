package com.qunar.hotel.qtypeahead.controller;

import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.qunar.hotel.qtypeahead.datastructure.QElement;
import com.qunar.hotel.qtypeahead.search.QTypeaheadSearcher;

@Controller
public class QTypeaheadController {
	
	@Resource
	QTypeaheadSearcher searcher;
	
    @RequestMapping("typeahead")
    @ResponseBody
    public Object typeahead(
    		@RequestParam(value="city", defaultValue = "") String city,
            @RequestParam(value="citytag", defaultValue = "") String city_code,
            @RequestParam(value ="q", required = true) String query,
            @RequestParam(value ="limit", defaultValue = "10") int limit,
            @RequestParam(value ="app", defaultValue = "") String app) {
    	
    	List<QElement> results = searcher.search(city, city_code, query, limit, app);
    	
        return searcher.converOutput(city, query, results);
    }
    
    @RequestMapping("debug")
    @ResponseBody
    public Object debug(
    		@RequestParam(value="city", defaultValue = "") String city,
            @RequestParam(value="citytag", defaultValue = "") String city_code,
            @RequestParam(value ="q", required = true) String query,
            @RequestParam(value ="limit", defaultValue = "10") int limit,
            @RequestParam(value ="app", defaultValue = "") String app) {
    	
    	List<QElement> results = searcher.search(city, city_code, query, limit, app);
    	
        return results;
    }
}
