package ru.ifmo.se.service;

import ru.ifmo.se.model.CheckResult;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/checkArea")
public class AreaCheckServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheck(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processCheck(request, response);
    }

    private void processCheck(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            double x = Double.parseDouble(request.getParameter("x"));
            double y = Double.parseDouble(request.getParameter("y"));
            double radius = Double.parseDouble(request.getParameter("radius"));

            boolean isInside = (x * x + y * y) <= (radius * radius);

            // Создаем объект результата проверки
            CheckResult result = new CheckResult(x, y, radius, isInside);

            // Сохраняем результат в сессии
            HttpSession session = request.getSession();
            List<CheckResult> results = (List<CheckResult>) session.getAttribute("results");
            if (results == null) {
                results = new ArrayList<>();
            }
            results.add(result);
            session.setAttribute("results", results);

            // Устанавливаем атрибуты для отображения
            request.setAttribute("result", result);

            // Перенаправляем на страницу результатов
            request.getRequestDispatcher("/result.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            // Обработка ошибок ввода
            request.setAttribute("error", "Неверный формат чисел.");
            request.getRequestDispatcher("/form.jsp").forward(request, response);
        }
    }
}
