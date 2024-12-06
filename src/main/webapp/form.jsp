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
        <h1>Иванов Иван Иванович</h1>
        <h2>Группа: ИУ7-34Б</h2>
        <h3>Вариант: 1</h3>
    </header>

    <main class="container">
        <section class="form-section">
            <h2>Введите параметры:</h2>
            <form name="pointForm" action="controller" method="post">
                <div class="form-group">
                    <label for="x">Координата X:</label>
                    <!-- Предварительное заполнение поля X -->
                    <input type="text" id="x" name="x" required value="<c:out value='${currentX}' default=''/>">
                </div>

                <div class="form-group">
                    <label for="y_select">Координата Y:</label>
                    <!-- Выпадающий список для Y с выбором сохраненного значения -->
                    <select id="y_select" required>
                        <c:forEach var="yValue" items="${['-2', '-1.5', '-1', '-0.5', '0', '0.5', '1', '1.5', '2']}">
                            <option value="${yValue}" <c:if test="${yValue == currentY}">selected</c:if>>${yValue}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label>Радиус Области:</label>
                    <div class="button-group" id="radiusButtons" role="group" aria-label="Выбор радиуса">
                        <c:forEach var="rValue" items="${['1', '1.5', '2', '2.5', '3']}">
                            <button type="button" class="radius-btn <c:if test='${rValue == currentR}'>active</c:if>"
                                    data-value="${rValue}"
                                    aria-pressed="${rValue == currentR ? 'true' : 'false'}">
                                ${rValue}
                            </button>
                        </c:forEach>
                    </div>
                    <!-- Скрытое поле для хранения выбранного радиуса -->
                    <input type="hidden" id="radius" name="radius" value="<c:out value='${currentR}' default='1'/>" required>
                </div>

                <!-- Скрытое поле для хранения значения Y при клике на канвас -->
                <input type="hidden" id="y_hidden" name="y" value="<c:out value='${currentY}' default=''/>">

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
