<%@page import="com.qunar.flight.qmonitor.QMonitor"%><%@page import="java.util.Map"%><%@ page contentType="text/plain;charset=UTF-8" language="java"%><%
    for (Map.Entry<String, Long> entry : QMonitor.getValues().entrySet()) {
        String qName = entry.getKey();
        Long value = entry.getValue();
        out.append(qName).append("=").append(String.valueOf(value)).append("\n");
    }
%>