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
    <link rel="stylesheet" href="main.css">
    <script src="main.js" type="module"></script>
</head>
<body>
    <header class="header">
        <h1>Иванов Иван Иванович</h1>
        <h2>Группа: ИУ7-34Б</h2>
        <h3>Вариант: 1</h3>
    </header>

    <main class="container">
        <section class="form-section">
            <h2>Введите параметры:</h2>
            <form name="pointForm" action="controller" method="post" onsubmit="return validateForm();">
                <div class="form-group">
                    <label for="x">Координата X (-5 ... 3):</label>
                    <!-- Используем type="text", чтобы проще ограничить ввод -->
                    <input type="text" id="x" name="x" required>
                </div>

                <div class="form-group">
                    <label for="y">Координата Y:</label>
                    <select id="y" name="y" required>
                        <option value="-2">-2</option>
                        <option value="-1.5">-1.5</option>
                        <option value="-1">-1</option>
                        <option value="-0.5">-0.5</option>
                        <option value="0">0</option>
                        <option value="0.5">0.5</option>
                        <option value="1">1</option>
                        <option value="1.5">1.5</option>
                        <option value="2">2</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Радиус Области:</label>
                    <div class="button-group" id="radiusButtons">
                        <button type="button" class="radius-btn" data-value="1">1</button>
                        <button type="button" class="radius-btn" data-value="1.5">1.5</button>
                        <button type="button" class="radius-btn" data-value="2">2</button>
                        <button type="button" class="radius-btn" data-value="2.5">2.5</button>
                        <button type="button" class="radius-btn" data-value="3">3</button>
                    </div>
                    <!-- Скрытое поле для хранения выбранного радиуса -->
                    <input type="hidden" id="radius" name="radius" required>
                </div>

                <button type="submit" class="btn btn-submit">Проверить</button>
            </form>
        </section>

        <section class="canvas-section">
            <h2>Интерактивная Область</h2>
            <canvas id="resultCanvas" width="400" height="400" onclick="getMouseCoordinates(event)"></canvas>
        </section>

        <section class="results-section">
            <h2>Предыдущие Результаты</h2>
            <table class="results-table">
                <thead>
                    <tr>
                        <th>X</th>
                        <th>Y</th>
                        <th>Радиус</th>
                        <th>Попадает</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${not empty results}">
                        <c:forEach var="res" items="${results}">
                            <tr>
                                <td>${res.x}</td>
                                <td>${res.y}</td>
                                <td>${res.radius}</td>
                                <td><c:choose>
                                    <c:when test="${res.inside}">Да</c:when>
                                    <c:otherwise>Нет</c:otherwise>
                                </c:choose></td>
                            </tr>
                        </c:forEach>
                    </c:if>
                </tbody>
            </table>
        </section>

        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>
    </main>
</body>
</html>
