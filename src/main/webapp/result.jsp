<%@ page import="ru.ifmo.se.model.CheckResult" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Результат Проверки</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        table {
            border-collapse: collapse;
            width: 400px;
            margin-bottom: 20px;
        }
        table, th, td {
            border: 1px solid #000;
        }
        th, td {
            padding: 8px;
            text-align: center;
        }
        a {
            text-decoration: none;
            color: blue;
        }
    </style>
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
