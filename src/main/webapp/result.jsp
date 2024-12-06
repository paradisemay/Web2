<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="ru.ifmo.se.model.CheckResult" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Результат Проверки</title>
    <link rel="stylesheet" href="result.css">
</head>
<body>
    <h2>Результат Проверки</h2>
    <table>
        <tr>
            <th>Координата X</th>
            <th>Координата Y</th>
            <th>Радиус Области</th>
            <th>Попадает в Область</th>
        </tr>
        <%
            CheckResult result = (CheckResult) request.getAttribute("result");
            if (result != null) {
        %>
        <tr>
            <td><%= result.getX() %></td>
            <td><%= result.getY() %></td>
            <td><%= result.getRadius() %></td>
            <td><%= result.isInside() ? "Да" : "Нет" %></td>
        </tr>
        <%
            }
        %>
    </table>
    <a href="controller">Вернуться к форме</a>
</body>
</html>
