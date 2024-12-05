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
    <style>
        /* Ваши стили */
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        h1, h2, h3 {
            margin: 5px 0;
        }
        form {
            margin-bottom: 20px;
        }
        label {
            display: inline-block;
            width: 150px;
        }
        input[type="text"] {
            width: 200px;
            padding: 5px;
            margin-bottom: 10px;
        }
        input[type="submit"] {
            padding: 5px 10px;
        }
        table {
            border-collapse: collapse;
            width: 500px;
        }
        table, th, td {
            border: 1px solid #000;
        }
        th, td {
            padding: 8px;
            text-align: center;
        }
        #resultCanvas {
            border:1px solid #000000;
            cursor: pointer;
        }
    </style>
    <script type="text/javascript">
        // Валидация формы
        function validateForm() {
            var x = document.forms["pointForm"]["x"].value;
            var y = document.forms["pointForm"]["y"].value;
            var radius = document.forms["pointForm"]["radius"].value;
            if (isNaN(x) || isNaN(y) || isNaN(radius)) {
                alert("Пожалуйста, введите числовые значения.");
                return false;
            }
            return true;
        }

        // Обработка клика по canvas
        function getMouseCoordinates(event) {
            var radiusInput = document.getElementById("radius").value;
            if (radiusInput === "") {
                alert("Радиус области не установлен.");
                return;
            }

            var canvas = document.getElementById("resultCanvas");
            var rect = canvas.getBoundingClientRect();
            var x = event.clientX - rect.left - canvas.width / 2;
            var y = canvas.height / 2 - (event.clientY - rect.top);

            // Отправка данных на сервер
            var form = document.createElement("form");
            form.method = "POST";
            form.action = "controller";

            var inputX = document.createElement("input");
            inputX.type = "hidden";
            inputX.name = "x";
            inputX.value = x;

            var inputY = document.createElement("input");
            inputY.type = "hidden";
            inputY.name = "y";
            inputY.value = y;

            var inputRadius = document.createElement("input");
            inputRadius.type = "hidden";
            inputRadius.name = "radius";
            inputRadius.value = radiusInput;

            form.appendChild(inputX);
            form.appendChild(inputY);
            form.appendChild(inputRadius);

            document.body.appendChild(form);
            form.submit();
        }

        // Отрисовка точки на canvas
        function drawPoint() {
            var canvas = document.getElementById("resultCanvas");
            var ctx = canvas.getContext("2d");
            var radius = parseFloat(document.getElementById("radius").value);
            var centerX = canvas.width / 2;
            var centerY = canvas.height / 2;

            // Очистка canvas
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // Рисуем координатные оси
            ctx.beginPath();
            ctx.moveTo(0, centerY);
            ctx.lineTo(canvas.width, centerY);
            ctx.moveTo(centerX, 0);
            ctx.lineTo(centerX, canvas.height);
            ctx.strokeStyle = "#000";
            ctx.stroke();

            // Рисуем область (круг)
            ctx.beginPath();
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
            ctx.strokeStyle = "#0000FF";
            ctx.stroke();

            // Рисуем все предыдущие точки
            <%
                List<CheckResult> results = (List<CheckResult>) session.getAttribute("results");
                if (results != null) {
                    for (CheckResult res : results) {
            %>
            ctx.beginPath();
            ctx.arc(centerX + <%= res.getX() %>, centerY - <%= res.getY() %>, 5, 0, 2 * Math.PI);
            ctx.fillStyle = <%= res.isInside() ? "'green'" : "'red'" %>;
            ctx.fill();
            ctx.stroke();
            <%
                    }
                }
            %>

            // Рисуем текущую точку, если она есть
            <%
                CheckResult current = (CheckResult) request.getAttribute("result");
                if (current != null) {
            %>
            ctx.beginPath();
            ctx.arc(centerX + <%= current.getX() %>, centerY - <%= current.getY() %>, 5, 0, 2 * Math.PI);
            ctx.fillStyle = <%= current.isInside() ? "'green'" : "'red'" %>;
            ctx.fill();
            ctx.stroke();
            <% } %>
        }

        // Загрузка страницы
        window.onload = function() {
            drawPoint();
        };
    </script>
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
                    <td>${res.inside ? "Да" : "Нет"}</td>
                </tr>
            </c:forEach>
        </c:if>
    </table>

    <c:if test="${not empty error}">
        <p style="color:red;">${error}</p>
    </c:if>
</body>
</html>
