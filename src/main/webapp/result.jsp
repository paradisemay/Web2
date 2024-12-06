<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <c:if test="${not empty result}">
            <tr>
                <td><c:out value="${result.x}"/></td>
                <td><c:out value="${result.y}"/></td>
                <td><c:out value="${result.radius}"/></td>
                <td>
                    <c:choose>
                        <c:when test="${result.inside}">Да</c:when>
                        <c:otherwise>Нет</c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:if>
    </table>
    <a href="controller">Вернуться к форме</a>
</body>
</html>
