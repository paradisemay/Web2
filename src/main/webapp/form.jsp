<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    <link href="static/style/style.css" rel="stylesheet">
    <script src="static/scripts/dist/bundle.js" type="module"></script>
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;0,900;1,300;1,400;1,700;1,900&family=Playfair+Display:wght@500&display=swap" rel="stylesheet">
</head>
<body>
<header class="header merriweather">
    <h1>Иванов Иван Иванович</h1>
    <h2>Группа: ИУ7-34Б</h2>
    <h3>Вариант: 1</h3>
</header>
<main>
    <section class="form-container">
        <h2>Отправить форму</h2>
        <form class="input-form" name="pointForm" action="controller" method="post" onsubmit="return validateForm();">
            <div class="input-group">
                <label for="x">Введите X:</label>
                <input class="input-text" type="text" id="x" name="x" pattern="-?[0-5]|3" placeholder="От -5 до 3" title="Введите число от -5 до 3" required>
            </div>
            <div class="input-group">
                <label for="y">Введите Y:</label>
                <div class="button-group" id="y">
                    <button class="button-y" type="button" value="-5">-5</button>
                    <button class="button-y" type="button" value="-4">-4</button>
                    <button class="button-y" type="button" value="-3">-3</button>
                    <button class="button-y" type="button" value="-2">-2</button>
                    <button class="button-y" type="button" value="-1">-1</button>
                    <button class="button-y" type="button" value="0">0</button>
                    <button class="button-y" type="button" value="1">1</button>
                    <button class="button-y" type="button" value="2">2</button>
                    <button class="button-y" type="button" value="3">3</button>
                </div>
            </div>
            <div class="input-group">
                <label for="radius">Введите радиус:</label>
                <div class="button-group" id="radius">
                    <button class="button-radius" type="button" value="1">1</button>
                    <button class="button-radius" type="button" value="1.5">1.5</button>
                    <button class="button-radius" type="button" value="2">2</button>
                    <button class="button-radius" type="button" value="2.5">2.5</button>
                    <button class="button-radius" type="button" value="3">3</button>
                </div>
            </div>
            <div class="input-group">
                <button class="submit-button" type="submit">Проверить</button>
                <button class="clear-button" type="reset">Очистить</button>
            </div>
        </form>
    </section>

    <section class="table-view">
        <h2>Предыдущие Результаты</h2>
        <table id="resultTable">
            <tr>
                <th>Request time</th>
                <th>Running time</th>
                <th>Coordinate X</th>
                <th>Coordinate Y</th>
                <th>Radius length</th>
                <th>Result</th>
            </tr>
            <c:if test="${not empty results}">
                <c:forEach var="res" items="${results}">
                    <tr>
                        <td>${res.requestTime}</td>
                        <td>${res.runningTime}</td>
                        <td>${res.x}</td>
                        <td>${res.y}</td>
                        <td>${res.radius}</td>
                        <td>
                            <c:choose>
                                <c:when test="${res.inside}">Да</c:when>
                                <c:otherwise>Нет</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </c:if>
        </table>
    </section>

    <section class="canvas-container">
        <h2>График</h2>
        <canvas id="resultCanvas" width="400" height="400" onclick="getMouseCoordinates(event)"></canvas>
    </section>
</main>

<footer class="merriweather footer">
    <p>&copy; 2024 by Иванов И.И.</p>
</footer>
<div id="toast-container"></div>
</body>
</html>