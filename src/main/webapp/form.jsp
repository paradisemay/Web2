<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Проверка Точки в Области</title>
    <link rel="stylesheet" href="main.css">
</head>
<body>
    <header class="header">
        <h1>Мельников Тимофей Максимович</h1>
        <h2>Группа: P3216</h2>
        <h3>Вариант: 80929</h3>
    </header>

    <main class="container">
        <section class="form-section">
            <h2>Введите параметры:</h2>
            <form name="pointForm" action="controller" method="get">
                <div class="form-group">
                    <label for="x_select">Координата X:</label>
                    <!-- Выпадающий список для X с выбором сохраненного значения -->
                    <select id="x_select" required>
                        <c:forEach var="xValue" items="${['-5', '-4', '-3', '-2', '-1', '0', '1', '2', '3']}">
                            <option value="${xValue}" <c:if test="${xValue == currentX}">selected</c:if>>${xValue}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="y">Координата y:</label>
                    <!-- Предварительное заполнение поля y -->
                    <input type="text" id="y" name="y" required value="<c:out value='${currentY}' default=''/>">
                </div>
                
                <div class="form-group">
                    <label for="z">Координата z:</label>
                    <!-- Предварительное заполнение поля z -->
                    <input type="text" id="z" name="z" required value="<c:out value='${currentZ}' default=''/>">
                </div>

                <!-- Скрытое поле для хранения значения X при клике на канвас -->
                <input type="hidden" id="x_hidden" name="x" value="<c:out value='${currentX}' default=''/>">

                <button type="submit" class="btn-submit">Проверить</button>
            </form>
        </section>

        <section class="canvas-section">
            <h2>Интерактивная Область</h2>
            <canvas id="resultCanvas" width="400" height="400"></canvas>
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
                                <td><c:out value="${res.x}"/></td>
                                <td><c:out value="${res.y}"/></td>
                                <td><c:out value="${res.radius}"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${res.inside}">Да</c:when>
                                        <c:otherwise>Нет</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                </tbody>
            </table>
        </section>

        <c:if test="${not empty error}">
            <p class="error-message"><c:out value="${error}"/></p>
        </c:if>
    </main>

    <script>
        // Передача сохраненных значений в JavaScript для инициализации канваса
        window.savedX = <c:out value='${currentX}' default='0'/>;
        window.savedY = <c:out value='${currentY}' default='-2'/>;
        window.savedR = <c:out value='${currentR}' default='1'/>;
    </script>
    <script src="main.js" type="module"></script>
</body>
</html>
