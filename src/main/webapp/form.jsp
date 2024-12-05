<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="ru.ifmo.se.model.CheckResult" %>
<%@ page import="java.util.List" %>
<%@ page session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Проверка Точки в Области</title>
    <!-- Ваши стили и скрипты -->
</head>
<body>
    <h1>Иванов Иван Иванович</h1>
    <h2>Группа: ИУ7-34Б</h2>
    <h3>Вариант: 1</h3>

    <form name="pointForm" action="controller" method="post" onsubmit="return validateForm();">
        <label for="x">Координата X:</label>
        <input type="text" id="x" name="x" required><br><br>
        <label for="y">Координата Y:</label>
        <input type="text" id="y" name="y" required><br><br>
        <label for="radius">Радиус Области:</label>
        <input type="text" id="radius" name="radius" required><br><br>
        <input type="submit" value="Проверить">
    </form>

    <h2>Интерактивная Область</h2>
    <canvas id="resultCanvas" width="400" height="400" onclick="getMouseCoordinates(event)"></canvas><br><br>

    <h2>Предыдущие Результаты</h2>
    <table>
        <tr>
            <th>X</th>
            <th>Y</th>
            <th>Радиус</th>
            <th>Попадает</th>
        </tr>
        <c:if test="${not empty results}">
            <c:forEach var="res" items="${results}">
                <tr>
                    <td>${res.x}</td>
                    <td>${res.y}</td>
                    <td>${res.radius}</td>
                    <td><c:choose>
                            <c:when test="${res.inside}">Да</c:when>
                            <c:otherwise>Нет</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </c:if>
    </table>

    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>
</body>
</html>
