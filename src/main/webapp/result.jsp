<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="ru.ifmo.se.model.CheckResult" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Результат Проверки</title>
    <link href="static/style/style.css" rel="stylesheet">
    <script src="static/scripts/dist/bundle.js" type="module"></script>
    <link href="https://fonts.googleapis.com" rel="preconnect">
    <link crossorigin href="https://fonts.gstatic.com" rel="preconnect">
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,300;0,400;0,700;0,900;1,300;1,400;1,700;1,900&display=swap" rel="stylesheet">
</head>
<body>
    <header class="header merriweather">
        <h1>Результат Проверки</h1>
    </header>
    <main>
        <section class="table-view">
            <h2>Результат Ваших Данных</h2>
            <table>
                <thead>
                    <tr>
                        <th>Координата X</th>
                        <th>Координата Y</th>
                        <th>Радиус Области</th>
                        <th>Попадает в Область</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${not empty result}">
                        <tr>
                            <td>${result.x}</td>
                            <td>${result.y}</td>
                            <td>${result.radius}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${result.inside}">Да</c:when>
                                    <c:otherwise>Нет</c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
            <div class="navigation">
                <a href="controller" class="button">Вернуться к форме</a>
            </div>
        </section>
    </main>
    <footer class="footer merriweather">
        <p>&copy; 2024 by Иванов И.И.</p>
    </footer>
</body>
</html>
